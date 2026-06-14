import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/user_profile.dart';
import '../data/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _age;
  late Gender _gender;
  late double _weightKg;
  late double _heightCm;
  late FitnessGoal _goal;

  bool _initialized = false;

  void _initFrom(UserProfile p) {
    _age = p.age;
    _gender = p.gender;
    _weightKg = p.weightKg;
    _heightCm = p.heightCm;
    _goal = p.goal;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    if (!_initialized) {
      _initFrom(profile ?? UserProfile.defaultProfile);
    }

    final preview = UserProfile(
      age: _age,
      gender: _gender,
      weightKg: _weightKg,
      heightCm: _heightCm,
      goal: _goal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Il mio profilo'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Salva', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Riepilogo kcal suggerite
              _KcalPreviewCard(profile: preview),
              const SizedBox(height: 24),

              _SectionTitle('Dati personali'),
              const SizedBox(height: 12),

              // Sesso
              _Label('Sesso'),
              Row(
                children: Gender.values.map((g) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ChoiceChip(
                      label: g == Gender.female ? '👩 Donna' : '👨 Uomo',
                      selected: _gender == g,
                      onTap: () => setState(() => _gender = g),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 16),

              // Età
              _Label('Età: $_age anni'),
              Slider(
                value: _age.toDouble(),
                min: 16,
                max: 80,
                divisions: 64,
                activeColor: AppColors.peachDark,
                label: '$_age',
                onChanged: (v) => setState(() => _age = v.round()),
              ),
              const SizedBox(height: 8),

              // Peso
              _Label('Peso: ${_weightKg.toStringAsFixed(1)} kg'),
              Slider(
                value: _weightKg,
                min: 40,
                max: 130,
                divisions: 90,
                activeColor: AppColors.peachDark,
                label: '${_weightKg.toStringAsFixed(1)} kg',
                onChanged: (v) => setState(() => _weightKg = double.parse(v.toStringAsFixed(1))),
              ),
              const SizedBox(height: 8),

              // Altezza
              _Label('Altezza: ${_heightCm.toStringAsFixed(0)} cm'),
              Slider(
                value: _heightCm,
                min: 140,
                max: 210,
                divisions: 70,
                activeColor: AppColors.peachDark,
                label: '${_heightCm.toStringAsFixed(0)} cm',
                onChanged: (v) => setState(() => _heightCm = v.roundToDouble()),
              ),
              const SizedBox(height: 24),

              _SectionTitle('Obiettivo'),
              const SizedBox(height: 12),

              ...FitnessGoal.values.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _GoalCard(
                  goal: g,
                  selected: _goal == g,
                  onTap: () => setState(() => _goal = g),
                ),
              )),

              const SizedBox(height: 24),

              // Macro breakdown
              _MacroCard(profile: preview),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peachDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Salva profilo', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    final profile = UserProfile(
      age: _age,
      gender: _gender,
      weightKg: _weightKg,
      heightCm: _heightCm,
      goal: _goal,
    );
    await ref.read(profileProvider.notifier).save(profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profilo salvato ✓')),
      );
      Navigator.pop(context);
    }
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.titleLarge,
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.peachDark : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.peachDark : AppColors.divider,
          ),
        ),
        child: Center(
          child: Text(label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final FitnessGoal goal;
  final bool selected;
  final VoidCallback onTap;
  const _GoalCard({required this.goal, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.peach : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.peachDark : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(goal.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(goal.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: selected ? AppColors.peachDark : AppColors.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.peachDark),
          ],
        ),
      ),
    );
  }
}

class _KcalPreviewCard extends StatelessWidget {
  final UserProfile profile;
  const _KcalPreviewCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.peach, AppColors.fitness],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🔥 Kcal giornaliere suggerite',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.peachDark.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text('${profile.suggestedKcal} kcal',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.peachDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text('Obiettivo: ${profile.goal.label}  ·  TDEE: ${profile.tdee.round()} kcal',
            style: TextStyle(fontSize: 12, color: AppColors.peachDark.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final UserProfile profile;
  const _MacroCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.peach.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Macro suggeriti', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MacroItem(label: 'Proteine', value: '${profile.proteinG}g', color: AppColors.peachDark, emoji: '🥩'),
              _MacroItem(label: 'Carboidrati', value: '${profile.carbsG}g', color: AppColors.mintDark, emoji: '🍞'),
              _MacroItem(label: 'Grassi', value: '${profile.fatG}g', color: AppColors.lavenderDark, emoji: '🥑'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String emoji;
  const _MacroItem({required this.label, required this.value, required this.color, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
