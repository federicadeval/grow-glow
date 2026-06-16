import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/domain/user_profile.dart';
import '../../../profile/data/profile_provider.dart';
import '../../data/calorie_provider.dart';

class FitnessScreen extends ConsumerWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final daily = ref.watch(calorieProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GreetingCard(profile: profile),
            const SizedBox(height: 16),

            // Banner kcal giornaliero
            _KcalBanner(profile: profile, daily: daily, ref: ref),
            const SizedBox(height: 24),

            Text('Le tue sezioni',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FitnessCard(
                    title: 'Palestra',
                    subtitle: 'Schede & allenamenti',
                    icon: Icons.fitness_center_rounded,
                    color: AppColors.peachDark,
                    bgColor: AppColors.peach,
                    onTap: () => context.go('/fitness/workout'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _FitnessCard(
                    title: 'Dieta',
                    subtitle: 'Piani & pasti',
                    icon: Icons.restaurant_rounded,
                    color: AppColors.mintDark,
                    bgColor: AppColors.mint,
                    onTap: () => context.go('/diet'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Riepilogo settimanale',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _WeeklySummaryCard(),
          ],
        ),
      ),
    );
  }
}

// ─── Greeting ────────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  final UserProfile? profile;
  const _GreetingCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Buongiorno' : hour < 18 ? 'Buon pomeriggio' : 'Buonasera';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.peach, AppColors.fitness],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$greeting! 🌅',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.peachDark,
            ),
          ),
          const SizedBox(height: 4),
          Text('Pronta per allenarti oggi?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.peachDark.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Banner kcal giornaliero ──────────────────────────────────
class _KcalBanner extends StatelessWidget {
  final UserProfile? profile;
  final DailyCalories daily;
  final WidgetRef ref;

  const _KcalBanner({required this.profile, required this.daily, required this.ref});

  @override
  Widget build(BuildContext context) {
    final target = profile?.suggestedKcal ?? 0;
    final net = target + daily.burnedKcal - daily.consumedKcal;
    final progress = target > 0
        ? (daily.consumedKcal / target).clamp(0.0, 1.0)
        : 0.0;

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
              Text('Kcal oggi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
            // Barra progresso
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

            // Tre numeri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _KcalCell(
                  label: 'Obiettivo',
                  value: target,
                  unit: 'kcal',
                  color: AppColors.peachDark,
                  icon: Icons.flag_rounded,
                ),
                _KcalCell(
                  label: 'Bruciate',
                  value: daily.burnedKcal,
                  unit: 'kcal',
                  color: AppColors.mintDark,
                  icon: Icons.fitness_center_rounded,
                ),
                _KcalCell(
                  label: 'Consumate',
                  value: daily.consumedKcal,
                  unit: 'kcal',
                  color: AppColors.lavenderDark,
                  icon: Icons.restaurant_rounded,
                ),
                _KcalCell(
                  label: 'Rimanenti',
                  value: net,
                  unit: 'kcal',
                  color: net >= 0 ? AppColors.mintDark : AppColors.blushDark,
                  icon: net >= 0 ? Icons.check_circle_rounded : Icons.warning_rounded,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Bottone aggiungi pasto
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddMealDialog(context, ref),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.mintDark),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, color: AppColors.mintDark, size: 18),
                    label: const Text('Aggiungi pasto',
                      style: TextStyle(color: AppColors.mintDark, fontSize: 13),
                    ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aggiungi pasto',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Annulla'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (kcal > 0) {
                        ref.read(calorieProvider.notifier).addConsumed(kcal);
                      }
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
  final String unit;
  final Color color;
  final IconData icon;

  const _KcalCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text('$value',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color),
        ),
        Text(unit, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Fitness cards ────────────────────────────────────────────
class _FitnessCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _FitnessCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
            ),
            Text(subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Weekly summary ───────────────────────────────────────────
class _WeeklySummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final days = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
    final completed = [true, true, false, true, false, false, false];
    final today = DateTime.now().weekday - 1;

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) => _DayDot(
              label: days[i],
              isCompleted: completed[i],
              isToday: i == today,
            )),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(label: 'Allenamenti', value: '3', icon: Icons.bolt_rounded),
              _StatChip(label: 'Calorie', value: '1840', icon: Icons.local_fire_department_rounded),
              _StatChip(label: 'Streak', value: '5d', icon: Icons.emoji_events_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isToday;

  const _DayDot({required this.label, required this.isCompleted, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
            color: isToday ? AppColors.peachDark : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.peachDark : AppColors.divider,
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: AppColors.peachDark, width: 2) : null,
          ),
          child: isCompleted
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : null,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.peachDark, size: 20),
        const SizedBox(height: 4),
        Text(value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
