import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_banner.dart';
import '../../../profile/data/profile_provider.dart';
import '../../data/calorie_provider.dart';
import '../../domain/models/workout_model.dart';
import 'workout_screen.dart';
import 'workout_session_screen.dart';
import 'c25k_session_screen.dart';

class FitnessScreen extends ConsumerStatefulWidget {
  const FitnessScreen({super.key});

  @override
  ConsumerState<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends ConsumerState<FitnessScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // 0=Mon…6=Sun
  List<int> _weekBurnedKcal = List.filled(7, 0); // Mon–Sun

  static const _dayLabels = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _loadWeekData();
  }

  Future<void> _loadWeekData() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    // Find the Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final burned = <int>[];
    for (int i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final key = 'daily_kcal_${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final raw = prefs.getString(key);
      int kcal = 0;
      if (raw != null) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        kcal = json['burnedKcal'] as int? ?? 0;
      }
      burned.add(kcal);
    }
    if (mounted) setState(() => _weekBurnedKcal = burned);
  }

  int get _weeklySessions => _weekBurnedKcal.where((k) => k > 0).length;
  int get _weeklyKcal => _weekBurnedKcal.fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final daily = ref.watch(calorieProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Colored top strip (scrolls with content) ────────
              Container(
                color: AppColors.fitness,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: SectionBanner(
                        icon: Icons.fitness_center_rounded,
                        title: 'Fitness',
                        subtitle: 'Allenati e monitora le calorie ogni giorno',
                        bgColor: AppColors.fitness,
                        fgColor: AppColors.fitnessDark,
                      ),
                    ),
                    // Stats row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatPill(Icons.fitness_center_rounded, 'Sessioni', '$_weeklySessions'),
                          _StatPill(Icons.local_fire_department_rounded, 'Kcal bruciate', '$_weeklyKcal'),
                          _StatPill(Icons.flag_rounded, 'Obiettivo', '${profile?.suggestedKcal ?? 0}'),
                          _StatPill(Icons.check_circle_rounded, 'Oggi', '${daily.burnedKcal}'),
                        ],
                      ),
                    ),
                    // Day selector
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        children: List.generate(7, (i) {
                          final isSelected = i == _selectedDay;
                          final hasWorkout = _weekBurnedKcal[i] > 0;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedDay = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.fitnessDark : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_dayLabels[i],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : AppColors.fitnessDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasWorkout
                                            ? (isSelected ? Colors.white : AppColors.fitnessDark)
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Scrollable content ───────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KcalBanner(profile: profile, daily: daily, ref: ref),
                    const SizedBox(height: 24),

                    Text('Le mie schede',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('Tap su una scheda per avviare la sessione',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ...builtinWorkouts.map((w) => WorkoutCard(
                      workout: w,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkoutSessionScreen(workout: w),
                        ),
                      ).then((_) => _loadWeekData()),
                    )),
                    const SizedBox(height: 24),

                    Text('Corsa',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.go('/fitness/workout'),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.mint, AppColors.sky],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.directions_run_rounded, size: 36, color: AppColors.mintDark),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Couch to 5K',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.mintDark,
                                    ),
                                  ),
                                  Text('9 settimane · 3 sessioni/settimana · da 0 a 5 km',
                                    style: TextStyle(fontSize: 13, color: AppColors.mintDark.withValues(alpha: 0.8)),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.mintDark, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat pill (same style as diet's _KcalPill) ───────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatPill(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.fitnessDark),
        const SizedBox(height: 2),
        Text(value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.fitnessDark),
        ),
        Text(label,
          style: TextStyle(fontSize: 10, color: AppColors.fitnessDark.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

// ─── Kcal banner ─────────────────────────────────────────────
class _KcalBanner extends StatelessWidget {
  final dynamic profile;
  final DailyCalories daily;
  final WidgetRef ref;

  const _KcalBanner({required this.profile, required this.daily, required this.ref});

  @override
  Widget build(BuildContext context) {
    final target = profile?.suggestedKcal ?? 0;
    final net = target + daily.burnedKcal - daily.consumedKcal;
    final progress = target > 0 ? (daily.consumedKcal / target).clamp(0.0, 1.0) : 0.0;
    final hasProfile = profile != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.peach.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kcal oggi', style: Theme.of(context).textTheme.titleMedium),
              if (!hasProfile)
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Configura profilo →',
                      style: TextStyle(fontSize: 12, color: AppColors.peachDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (hasProfile) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.95 ? AppColors.blushDark : AppColors.peachDark,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _KcalCell(label: 'Obiettivo', value: target, color: AppColors.peachDark, icon: Icons.flag_rounded),
                _KcalCell(label: 'Bruciate', value: daily.burnedKcal, color: AppColors.mintDark, icon: Icons.fitness_center_rounded),
                _KcalCell(label: 'Consumate', value: daily.consumedKcal, color: AppColors.lavenderDark, icon: Icons.restaurant_rounded),
                _KcalCell(label: 'Rimanenti', value: net, color: net >= 0 ? AppColors.mintDark : AppColors.blushDark,
                  icon: net >= 0 ? Icons.check_circle_rounded : Icons.warning_rounded),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddMealDialog(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.mintDark),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_rounded, color: AppColors.mintDark, size: 18),
                    label: const Text('Aggiungi pasto', style: TextStyle(color: AppColors.mintDark, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text(
              'Imposta il tuo profilo per vedere le kcal giornaliere personalizzate.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddMealDialog(BuildContext context, WidgetRef ref) {
    int kcal = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aggiungi pasto', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Kcal consumate',
                suffixText: 'kcal',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (v) => kcal = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla'))),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (kcal > 0) ref.read(calorieProvider.notifier).addConsumed(kcal);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
                    child: const Text('Aggiungi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KcalCell extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _KcalCell({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        Text('kcal', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
