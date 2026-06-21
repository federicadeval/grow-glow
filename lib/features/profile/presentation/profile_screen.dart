import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../domain/user_profile.dart';
import '../data/profile_provider.dart';
import '../../cycle/domain/cycle_entry.dart';
import '../../cycle/data/cycle_provider.dart';

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
  late DietStyle _dietStyle;
  late List<String> _intolerances;
  late TextEditingController _foodsToAvoidCtrl;
  late TextEditingController _customKcalCtrl;

  bool _initialized = false;

  void _initFrom(UserProfile p) {
    _age = p.age;
    _gender = p.gender;
    _weightKg = p.weightKg;
    _heightCm = p.heightCm;
    _goal = p.goal;
    _dietStyle = p.dietStyle;
    _intolerances = List.from(p.intolerances);
    _foodsToAvoidCtrl = TextEditingController(text: p.foodsToAvoid);
    _customKcalCtrl = TextEditingController(
      text: p.customKcalGoal != null ? '${p.customKcalGoal}' : '',
    );
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _foodsToAvoidCtrl.dispose();
      _customKcalCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    if (!_initialized) {
      _initFrom(profile ?? UserProfile.defaultProfile);
    }

    final customKcal = int.tryParse(_customKcalCtrl.text.trim());

    final preview = UserProfile(
      age: _age,
      gender: _gender,
      weightKg: _weightKg,
      heightCm: _heightCm,
      goal: _goal,
      dietStyle: _dietStyle,
      intolerances: _intolerances,
      foodsToAvoid: _foodsToAvoidCtrl.text,
      customKcalGoal: customKcal,
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
              const SizedBox(height: 12),
              TextField(
                controller: _customKcalCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Obiettivo personalizzato (opzionale)',
                  hintText: 'Lascia vuoto per usare il valore suggerito',
                  suffixText: 'kcal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (_) => setState(() {}),
              ),
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
              const SizedBox(height: 24),

              _SectionTitle('Preferenze alimentari'),
              const SizedBox(height: 12),

              _Label('Stile alimentare'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DietStyle.values.map((d) => GestureDetector(
                  onTap: () => setState(() => _dietStyle = d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _dietStyle == d ? AppColors.mintDark : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _dietStyle == d ? AppColors.mintDark : AppColors.divider),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(d.icon, size: 16, color: _dietStyle == d ? Colors.white : AppColors.textPrimary),
                        const SizedBox(width: 6),
                        Text(d.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: _dietStyle == d ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 16),

              _Label('Intolleranze / allergie'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kAllIntolerances.map((intol) {
                  final selected = _intolerances.contains(intol);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (selected) _intolerances.remove(intol);
                      else _intolerances.add(intol);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.peach : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selected ? AppColors.peachDark : AppColors.divider),
                      ),
                      child: Text(intol,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? AppColors.peachDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              _Label('Altro da evitare'),
              const SizedBox(height: 4),
              TextField(
                controller: _foodsToAvoidCtrl,
                decoration: const InputDecoration(
                  hintText: 'Es. coriandolo, melanzane, cipolle crude…',
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
              ),
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
              const SizedBox(height: 32),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 24),
              const _CycleSettingsSection(),
              const SizedBox(height: 40),
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
      dietStyle: _dietStyle,
      intolerances: List.from(_intolerances),
      foodsToAvoid: _foodsToAvoidCtrl.text.trim(),
      customKcalGoal: int.tryParse(_customKcalCtrl.text.trim()),
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
            Icon(goal.icon, size: 28, color: selected ? AppColors.peachDark : AppColors.textSecondary),
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
    final isCustom = profile.customKcalGoal != null;
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
          Row(
            children: [
              Text(
                isCustom ? 'Kcal giornaliere (personalizzato)' : 'Kcal giornaliere suggerite',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.peachDark.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('${profile.effectiveKcal} kcal',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.peachDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isCustom
              ? 'Suggerito: ${profile.suggestedKcal} kcal  ·  TDEE: ${profile.tdee.round()} kcal'
              : 'Obiettivo: ${profile.goal.label}  ·  TDEE: ${profile.tdee.round()} kcal',
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
              _MacroItem(label: 'Proteine', value: '${profile.proteinG}g', color: AppColors.peachDark, icon: Icons.set_meal_rounded),
              _MacroItem(label: 'Carboidrati', value: '${profile.carbsG}g', color: AppColors.mintDark, icon: Icons.grain_rounded),
              _MacroItem(label: 'Grassi', value: '${profile.fatG}g', color: AppColors.lavenderDark, icon: Icons.opacity_rounded),
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
  final IconData icon;
  const _MacroItem({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Cycle settings (profile) ─────────────────────────────────

class _CycleSettingsSection extends ConsumerWidget {
  const _CycleSettingsSection();

  static const _mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu',
                         'lug', 'ago', 'set', 'ott', 'nov', 'dic'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycle = ref.watch(cycleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ciclo mestruale',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 14),

        // Ultima mestruazione
        const Text('Ultima mestruazione',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: cycle.lastPeriodDate ?? DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 180)),
              lastDate: DateTime.now(),
              helpText: "Primo giorno dell'ultima mestruazione",
            );
            if (date != null) {
              ref.read(cycleProvider.notifier).updateLastPeriodDate(date);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cycle.lastPeriodDate != null
                      ? '${cycle.lastPeriodDate!.day} ${_mesi[cycle.lastPeriodDate!.month - 1]} ${cycle.lastPeriodDate!.year}'
                      : 'Seleziona una data',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cycle.lastPeriodDate != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Durata ciclo + durata mestruazioni
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Durata ciclo',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  _CycleStepper(
                    value: cycle.cycleLength,
                    unit: 'giorni',
                    min: 21,
                    max: 35,
                    onChanged: (v) => ref.read(cycleProvider.notifier).updateCycleLength(v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Durata mestruazioni',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  _CycleStepper(
                    value: cycle.periodLength,
                    unit: 'giorni',
                    min: 2,
                    max: 9,
                    onChanged: (v) => ref.read(cycleProvider.notifier).updatePeriodLength(v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CycleStepper extends StatelessWidget {
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _CycleStepper({
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: value > min ? () => onChanged(value - 1) : null,
            child: Icon(Icons.remove_rounded,
              size: 18,
              color: value > min ? AppColors.textPrimary : AppColors.divider,
            ),
          ),
          Text('$value $unit',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          GestureDetector(
            onTap: value < max ? () => onChanged(value + 1) : null,
            child: Icon(Icons.add_rounded,
              size: 18,
              color: value < max ? AppColors.textPrimary : AppColors.divider,
            ),
          ),
        ],
      ),
    );
  }
}

