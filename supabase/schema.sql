-- ============================================================
-- Grow & Glow — Supabase Schema
-- Esegui questo script nel SQL Editor di app.supabase.com
-- ============================================================

-- Abilita Row Level Security su tutte le tabelle
-- (ogni utente vede solo i propri dati)

-- ─── PROFILI UTENTE ─────────────────────────────────────────
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  full_name text,
  avatar_url text,
  created_at timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "Users can manage their own profile"
  on public.profiles for all using (auth.uid() = id);

-- Auto-crea profilo alla registrazione
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data->>'full_name');
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─── FITNESS: SCHEDE ALLENAMENTO ────────────────────────────
create table public.workout_plans (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  name text not null,
  emoji text default '💪',
  description text,
  created_at timestamptz default now()
);
alter table public.workout_plans enable row level security;
create policy "Users manage their own workout plans"
  on public.workout_plans for all using (auth.uid() = user_id);

create table public.exercises (
  id uuid default gen_random_uuid() primary key,
  plan_id uuid references public.workout_plans on delete cascade,
  name text not null,
  sets integer,
  reps integer,
  weight_kg numeric,
  rest_seconds integer default 60,
  notes text,
  order_index integer default 0
);
alter table public.exercises enable row level security;
create policy "Users manage their exercises"
  on public.exercises for all
  using (exists (
    select 1 from public.workout_plans
    where id = exercises.plan_id and user_id = auth.uid()
  ));

create table public.workout_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  plan_id uuid references public.workout_plans,
  logged_at timestamptz default now(),
  duration_minutes integer,
  notes text
);
alter table public.workout_logs enable row level security;
create policy "Users manage their workout logs"
  on public.workout_logs for all using (auth.uid() = user_id);

-- ─── FITNESS: DIETA ─────────────────────────────────────────
create table public.meal_plans (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  name text not null,
  daily_calories integer,
  protein_g integer,
  carbs_g integer,
  fat_g integer,
  created_at timestamptz default now()
);
alter table public.meal_plans enable row level security;
create policy "Users manage their meal plans"
  on public.meal_plans for all using (auth.uid() = user_id);

create table public.meal_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  meal_type text check (meal_type in ('colazione', 'pranzo', 'cena', 'snack')),
  name text not null,
  calories integer,
  protein_g numeric,
  carbs_g numeric,
  fat_g numeric,
  logged_at timestamptz default now()
);
alter table public.meal_logs enable row level security;
create policy "Users manage their meal logs"
  on public.meal_logs for all using (auth.uid() = user_id);

-- ─── BEAUTY: ROUTINE ────────────────────────────────────────
create table public.skincare_routines (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  name text not null,
  routine_type text check (routine_type in ('morning', 'evening', 'weekly')),
  created_at timestamptz default now()
);
alter table public.skincare_routines enable row level security;
create policy "Users manage their routines"
  on public.skincare_routines for all using (auth.uid() = user_id);

create table public.routine_steps (
  id uuid default gen_random_uuid() primary key,
  routine_id uuid references public.skincare_routines on delete cascade,
  name text not null,
  description text,
  emoji text,
  duration_seconds integer,
  order_index integer default 0,
  product_name text
);
alter table public.routine_steps enable row level security;
create policy "Users manage their routine steps"
  on public.routine_steps for all
  using (exists (
    select 1 from public.skincare_routines
    where id = routine_steps.routine_id and user_id = auth.uid()
  ));

create table public.routine_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  routine_id uuid references public.skincare_routines on delete cascade,
  completed_at timestamptz default now()
);
alter table public.routine_logs enable row level security;
create policy "Users manage their routine logs"
  on public.routine_logs for all using (auth.uid() = user_id);

-- ─── TODO LIST ───────────────────────────────────────────────
create table public.todos (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles on delete cascade,
  title text not null,
  is_completed boolean default false,
  priority text check (priority in ('low', 'medium', 'high')) default 'medium',
  category text check (category in ('personal', 'health', 'work', 'shopping')) default 'personal',
  due_date date,
  completed_at timestamptz,
  created_at timestamptz default now()
);
alter table public.todos enable row level security;
create policy "Users manage their todos"
  on public.todos for all using (auth.uid() = user_id);

-- ─── INDICI PER PERFORMANCE ─────────────────────────────────
create index on public.workout_logs (user_id, logged_at desc);
create index on public.meal_logs (user_id, logged_at desc);
create index on public.routine_logs (user_id, completed_at desc);
create index on public.todos (user_id, is_completed, created_at desc);
