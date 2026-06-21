import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_banner.dart';
import '../../data/supplement_provider.dart';
import '../../data/supplements_database.dart';
import '../../domain/supplement.dart';
import 'supplements_list_screen.dart';

const _timingOrder = [
  SupplementTiming.mattina,
  SupplementTiming.pasto,
  SupplementTiming.preWorkout,
  SupplementTiming.postWorkout,
  SupplementTiming.sera,
];

class SupplementScreen extends ConsumerWidget {
  const SupplementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppState = ref.watch(supplementProvider);
    final active = kSupplements
        .where((s) => suppState.activeIds.contains(s.id))
        .toList();
    final takenCount = suppState.takenTodayIds
        .where((id) => suppState.activeIds.contains(id))
        .length;
    final activeCount = active.length;

    // Group by timing (use first timing as primary)
    final byTiming = <SupplementTiming, List<Supplement>>{};
    for (final s in active) {
      byTiming.putIfAbsent(s.timing.first, () => []).add(s);
    }
    final orderedTimings =
        _timingOrder.where((t) => byTiming.containsKey(t)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBanner(
                icon: Icons.medication_rounded,
                title: 'Integratori',
                subtitle: 'Routine personalizzata con basi scientifiche',
                bgColor: AppColors.supplement,
                fgColor: AppColors.supplementDark,
              ),
              const SizedBox(height: 24),

              // ── Routine oggi ──────────────────────────────────
              Text('Routine di oggi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              if (active.isEmpty)
                _EmptyRoutineCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SupplementsListScreen()),
                  ).then((_) {}),
                )
              else ...[
                // Progress summary
                _ProgressSummaryCard(
                  taken: takenCount,
                  total: activeCount,
                ),
                const SizedBox(height: 12),

                // Routine sections by timing
                for (final timing in orderedTimings) ...[
                  _TimingSection(
                    timing: timing,
                    supplements: byTiming[timing]!,
                    takenIds: suppState.takenTodayIds,
                    onToggleTaken: (id) => ref
                        .read(supplementProvider.notifier)
                        .toggleTaken(id),
                  ),
                  const SizedBox(height: 10),
                ],
              ],

              const SizedBox(height: 18),

              // ── I miei integratori ────────────────────────────
              Text('I miei integratori',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              _NavCard(
                icon: Icons.medication_rounded,
                title: 'Tutti gli integratori',
                subtitle: 'Attiva quelli che stai usando o vuoi iniziare',
                color: AppColors.supplementDark,
                bgColor: AppColors.supplement,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SupplementsListScreen()),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Progress summary card ────────────────────────────────────
class _ProgressSummaryCard extends StatelessWidget {
  final int taken;
  final int total;
  const _ProgressSummaryCard({required this.taken, required this.total});

  @override
  Widget build(BuildContext context) {
    final allDone = taken == total;
    final progress = total > 0 ? taken / total : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: allDone ? AppColors.supplement : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allDone
              ? AppColors.supplementDark.withValues(alpha: 0.25)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      allDone ? 'Tutto fatto per oggi!' : '$taken di $total presi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: allDone
                            ? AppColors.supplementDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (allDone) ...[
                      const SizedBox(width: 6),
                      const Text('✓',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.supplementDark)),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      allDone
                          ? AppColors.supplementDark
                          : AppColors.supplement,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$taken/$total',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: allDone ? AppColors.supplementDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Timing section card ──────────────────────────────────────
class _TimingSection extends StatelessWidget {
  final SupplementTiming timing;
  final List<Supplement> supplements;
  final Set<String> takenIds;
  final ValueChanged<String> onToggleTaken;

  const _TimingSection({
    required this.timing,
    required this.supplements,
    required this.takenIds,
    required this.onToggleTaken,
  });

  @override
  Widget build(BuildContext context) {
    final takenInSection =
        supplements.where((s) => takenIds.contains(s.id)).length;
    final allDone = takenInSection == supplements.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.supplement.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.supplement,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_timingIcon(timing),
                          size: 13, color: AppColors.supplementDark),
                      const SizedBox(width: 5),
                      Text(timing.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.supplementDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: allDone
                        ? AppColors.supplementDark
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    allDone
                        ? 'Fatto ✓'
                        : '$takenInSection/${supplements.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: allDone ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Supplement items
          for (int i = 0; i < supplements.length; i++) ...[
            _SupplementItem(
              supplement: supplements[i],
              isTaken: takenIds.contains(supplements[i].id),
              onToggle: () => onToggleTaken(supplements[i].id),
            ),
            if (i < supplements.length - 1)
              const Divider(
                  height: 1, color: AppColors.divider, indent: 16, endIndent: 16),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  IconData _timingIcon(SupplementTiming t) {
    switch (t) {
      case SupplementTiming.mattina:     return Icons.wb_sunny_rounded;
      case SupplementTiming.sera:        return Icons.nightlight_rounded;
      case SupplementTiming.pasto:       return Icons.restaurant_rounded;
      case SupplementTiming.preWorkout:  return Icons.bolt_rounded;
      case SupplementTiming.postWorkout: return Icons.fitness_center_rounded;
    }
  }
}

// ─── Single supplement item inside timing section ─────────────
class _SupplementItem extends StatelessWidget {
  final Supplement supplement;
  final bool isTaken;
  final VoidCallback onToggle;

  const _SupplementItem({
    required this.supplement,
    required this.isTaken,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cat = supplement.category;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isTaken
                  ? AppColors.supplementDark
                  : cat.bgColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.medication_rounded,
              size: 20,
              color: isTaken ? Colors.white : cat.fgColor,
            ),
          ),
          const SizedBox(width: 12),

          // Name + dosage + benefit
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplement.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(supplement.dosage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(supplement.benefit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                if (supplement.note != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(supplement.note!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Taken button
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isTaken
                    ? const Color(0xFF2D7A4A)
                    : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isTaken ? const Color(0xFF2D7A4A) : AppColors.divider,
                ),
              ),
              child: Icon(
                isTaken ? Icons.check_rounded : Icons.add_rounded,
                size: 18,
                color: isTaken ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────
class _EmptyRoutineCard extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyRoutineCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.supplement,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.medication_rounded,
                  color: AppColors.supplementDark, size: 26),
            ),
            const SizedBox(height: 12),
            const Text('Nessun integratore attivo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Vai al catalogo per attivare quelli che stai usando',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.supplementDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Vai al catalogo',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Navigation card (like beauty _ProgressCard) ──────────────
class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 26, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: color),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
