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
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) _foodsToAvoidCtrl.dispose();
    super.dispose();
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
      dietStyle: _dietStyle,
      intolerances: _intolerances,
      foodsToAvoid: _foodsToAvoidCtrl.text,
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
              const _CycleSection(),
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
          Text('Kcal giornaliere suggerite',
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

// ─── Cycle section ────────────────────────────────────────────

class _CycleSection extends ConsumerWidget {
  const _CycleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycle = ref.watch(cycleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ciclo mestruale',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            if (cycle.lastEntry != null)
              GestureDetector(
                onTap: () => _confirmDelete(context, ref),
                child: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.textSecondary),
              ),
          ],
        ),
        const SizedBox(height: 14),
        if (cycle.lastEntry == null)
          _CycleEmptyState(onStart: () => _pickAndLogStart(context, ref))
        else ...[
          _CycleStatusCard(cycle: cycle),
          const SizedBox(height: 14),
          _CyclePhaseBar(cycle: cycle),
          const SizedBox(height: 14),
          _CycleMonthCalendar(cycle: cycle),
          const SizedBox(height: 16),
          _CycleActionButtons(cycle: cycle,
            onStart: () => _pickAndLogStart(context, ref),
            onEnd: () => _pickAndLogEnd(context, ref),
          ),
          const SizedBox(height: 14),
          _CycleSettingsRow(cycle: cycle),
        ],
      ],
    );
  }

  Future<void> _pickAndLogStart(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: 'Inizio ciclo',
    );
    if (date != null) {
      await ref.read(cycleProvider.notifier).logPeriodStart(date);
    }
  }

  Future<void> _pickAndLogEnd(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 14)),
      lastDate: DateTime.now(),
      helpText: 'Fine mestruazioni',
    );
    if (date != null) {
      await ref.read(cycleProvider.notifier).endCurrentPeriod(date);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rimuovi ultimo ciclo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Rimuovi')),
        ],
      ),
    );
    if (ok == true) ref.read(cycleProvider.notifier).deleteLast();
  }
}

class _CycleEmptyState extends StatelessWidget {
  final VoidCallback onStart;
  const _CycleEmptyState({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2C4CE).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2C4CE)),
      ),
      child: Column(
        children: [
          const Text('🌸', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          const Text('Inizia a tracciare il tuo ciclo',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text('Registra il primo giorno del tuo ciclo\nper vedere fasi, previsioni e calendario.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B2040),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Inizia ciclo oggi',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleStatusCard extends StatelessWidget {
  final CycleState cycle;
  const _CycleStatusCard({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final phase = cycle.currentPhase!;
    final day = cycle.currentCycleDay!;
    final next = cycle.nextPeriodDate!;
    final daysLeft = cycle.daysToNextPeriod!;
    final mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu', 'lug', 'ago', 'set', 'ott', 'nov', 'dic'];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: phase.color.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: phase.color),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: phase.color,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(phase.emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phase.label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: phase.darkColor),
                ),
                Text('Giorno $day del ciclo',
                  style: TextStyle(fontSize: 12, color: phase.darkColor.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 2),
                Text(phase.description,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$daysLeft gg',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: phase.darkColor),
              ),
              Text('al prossimo', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text('${next.day} ${mesi[next.month - 1]}',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: phase.darkColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CyclePhaseBar extends StatelessWidget {
  final CycleState cycle;
  const _CyclePhaseBar({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final phases = CyclePhase.values;
    final currentDay = cycle.currentCycleDay!;
    final total = cycle.cycleLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: phases.map((phase) {
              final days = phase.daysCount(cycle.cycleLength, cycle.periodLength);
              return Expanded(
                flex: days,
                child: Container(height: 14, color: phase.color),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        // Current day indicator
        LayoutBuilder(builder: (context, constraints) {
          final x = ((currentDay - 1) / total) * constraints.maxWidth;
          return Stack(
            children: [
              const SizedBox(height: 6, width: double.infinity),
              Positioned(
                left: x.clamp(0, constraints.maxWidth - 2),
                child: Container(
                  width: 2, height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 4),
        // Labels
        Row(
          children: phases.map((phase) {
            final days = phase.daysCount(cycle.cycleLength, cycle.periodLength);
            return Expanded(
              flex: days,
              child: Text(phase.label,
                style: TextStyle(fontSize: 9, color: phase.darkColor, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CycleMonthCalendar extends StatelessWidget {
  final CycleState cycle;
  const _CycleMonthCalendar({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final startWeekday = firstDay.weekday; // 1=Mon, 7=Sun
    const headers = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            _monthLabel(now),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: headers.map((h) => Expanded(
              child: Center(
                child: Text(h, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: daysInMonth + (startWeekday - 1),
            itemBuilder: (context, i) {
              if (i < startWeekday - 1) return const SizedBox.shrink();
              final day = i - (startWeekday - 1) + 1;
              final date = DateTime(now.year, now.month, day);
              final phase = cycle.phaseForDate(date);
              final isToday = day == now.day;
              return Container(
                decoration: BoxDecoration(
                  color: phase?.color.withValues(alpha: 0.6) ?? Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday
                      ? Border.all(color: AppColors.textPrimary, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text('$day',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.normal,
                      color: phase != null ? phase.darkColor : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Legend
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: CyclePhase.values.map((p) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(p.label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  static String _monthLabel(DateTime d) {
    const mesi = ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'];
    return '${mesi[d.month - 1]} ${d.year}';
  }
}

class _CycleActionButtons extends StatelessWidget {
  final CycleState cycle;
  final VoidCallback onStart;
  final VoidCallback onEnd;
  const _CycleActionButtons({required this.cycle, required this.onStart, required this.onEnd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onStart,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF8B2040),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('Inizia ciclo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          ),
        ),
        if (cycle.isInActivePeriod) ...[
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onEnd,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF8B2040)),
                ),
                child: const Center(
                  child: Text('Fine mestruazioni',
                    style: TextStyle(color: Color(0xFF8B2040), fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CycleSettingsRow extends ConsumerWidget {
  final CycleState cycle;
  const _CycleSettingsRow({required this.cycle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _CycleStepper(
            label: 'Durata ciclo',
            value: cycle.cycleLength,
            unit: 'giorni',
            min: 21,
            max: 35,
            onChanged: (v) => ref.read(cycleProvider.notifier).updateCycleLength(v),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CycleStepper(
            label: 'Durata mestruazioni',
            value: cycle.periodLength,
            unit: 'giorni',
            min: 2,
            max: 9,
            onChanged: (v) => ref.read(cycleProvider.notifier).updatePeriodLength(v),
          ),
        ),
      ],
    );
  }
}

class _CycleStepper extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  const _CycleStepper({
    required this.label,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Row(
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
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
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
        ],
      ),
    );
  }
}
