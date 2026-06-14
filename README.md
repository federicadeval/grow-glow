# Grow & Glow ✨

App Flutter per il miglioramento personale con 3 sezioni: **Fitness**, **Beauty** e **Todo List**.

## Stack
- **Flutter** — UI cross-platform (iOS + Android)
- **Supabase** — Backend as a service (PostgreSQL + Auth)
- **Riverpod** — State management
- **Go Router** — Navigazione

## Setup

### 1. Crea il progetto Supabase
1. Vai su [app.supabase.com](https://app.supabase.com) e crea un nuovo progetto
2. Nel **SQL Editor**, incolla e esegui il contenuto di `supabase/schema.sql`
3. Copia **Project URL** e **anon key** da `Settings > API`

### 2. Configura le credenziali
Apri `lib/core/constants/supabase_constants.dart` e sostituisci:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 3. Installa le dipendenze e avvia
```bash
flutter pub get
flutter run
```

## Struttura del progetto
```
lib/
├── core/
│   ├── theme/         # AppTheme, AppColors (pastel palette)
│   ├── constants/     # Supabase keys
│   └── router/        # GoRouter con auth redirect
├── features/
│   ├── auth/          # Login & Registrazione
│   ├── home/          # Shell con bottom nav
│   ├── fitness/       # Palestra + Dieta
│   ├── beauty/        # Skincare routine
│   └── todo/          # Todo list con categorie
└── shared/
    └── widgets/       # Widget riutilizzabili
```

## Prossimi passi
- [ ] Collegare le schermate al database Supabase (repository layer)
- [ ] Aggiungere Riverpod providers per lo state management
- [ ] Notifiche locali per ricordare le routine
- [ ] Grafici progressi fitness con fl_chart
- [ ] Upload foto prodotti skincare
