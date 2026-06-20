import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/supplement_provider.dart';
import '../../data/supplements_database.dart';
import '../../domain/supplement.dart';

class SupplementScreen extends ConsumerStatefulWidget {
  const SupplementScreen({super.key});

  @override
  ConsumerState<SupplementScreen> createState() => _SupplementScreenState();
}

class _SupplementScreenState extends ConsumerState<SupplementScreen> {
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final suppState = ref.watch(supplementProvider);
    final activeCount = suppState.activeIds.length;
    final takenCount = suppState.takenTodayIds.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, activeCount, takenCount),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final category in SupplementCategory.values) ...[
                  _CategoryHeader(category: category),
                  const SizedBox(height: 8),
                  ...kSupplements
                      .where((s) => s.category == category)
                      .map((s) => _SupplementCard(
                            supplement: s,
                            isActive: suppState.activeIds.contains(s.id),
                            isTaken: suppState.takenTodayIds.contains(s.id),
                            isExpanded: _expandedId == s.id,
                            onToggleExpand: () => setState(() {
                              _expandedId = _expandedId == s.id ? null : s.id;
                            }),
                            onToggleActive: () => ref
                                .read(supplementProvider.notifier)
                                .toggleActive(s.id),
                            onToggleTaken: () => ref
                                .read(supplementProvider.notifier)
                                .toggleTaken(s.id),
                          )),
                  const SizedBox(height: 16),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int activeCount, int takenCount) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.heroBackground,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: -50, right: -40,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  color: AppColors.heroBlobA.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 20, left: -20,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.heroBlobB.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_rounded,
                                color: AppColors.heroText, size: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Integratori',
                          style: TextStyle(
                            color: AppColors.heroText,
                            fontSize: 22, fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _HeaderPill(
                          value: '$activeCount',
                          label: 'attivi',
                          icon: Icons.check_circle_outline_rounded,
                        ),
                        const SizedBox(width: 8),
                        _HeaderPill(
                          value: activeCount > 0 ? '$takenCount/$activeCount' : '–',
                          label: 'presi oggi',
                          icon: Icons.medication_rounded,
                          highlight: activeCount > 0 && takenCount == activeCount,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category header ──────────────────────────────────────────
class _CategoryHeader extends StatelessWidget {
  final SupplementCategory category;
  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: category.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 13, color: category.fgColor),
              const SizedBox(width: 5),
              Text(category.label,
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: category.fgColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Supplement card ──────────────────────────────────────────
class _SupplementCard extends StatelessWidget {
  final Supplement supplement;
  final bool isActive;
  final bool isTaken;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onToggleActive;
  final VoidCallback onToggleTaken;

  const _SupplementCard({
    required this.supplement,
    required this.isActive,
    required this.isTaken,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onToggleActive,
    required this.onToggleTaken,
  });

  @override
  Widget build(BuildContext context) {
    final cat = supplement.category;

    return GestureDetector(
      onTap: onToggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isActive
              ? cat.bgColor.withValues(alpha: 0.18)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? cat.bgColor : AppColors.divider,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.medication_rounded,
                        color: cat.fgColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  // Name + dosage
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(supplement.name,
                          style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(supplement.dosage,
                          style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Active toggle
                  GestureDetector(
                    onTap: onToggleActive,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? cat.fgColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? cat.fgColor : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        isActive ? 'Attivo' : 'Aggiungi',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Expanded details
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.divider, height: 1),
                          const SizedBox(height: 12),
                          Text(supplement.benefit,
                            style: const TextStyle(
                              fontSize: 13, color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          if (supplement.note != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline_rounded,
                                      size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(supplement.note!,
                                      style: const TextStyle(
                                        fontSize: 12, color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              // Bottom row: timing chips + taken button (only when active)
              if (isActive) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Timing chips
                    Wrap(
                      spacing: 6,
                      children: supplement.timing.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cat.bgColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(t.label,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: cat.fgColor),
                        ),
                      )).toList(),
                    ),
                    const Spacer(),
                    // Taken today button
                    GestureDetector(
                      onTap: onToggleTaken,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isTaken
                              ? const Color(0xFF2D7A4A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isTaken
                                ? const Color(0xFF2D7A4A)
                                : AppColors.divider,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isTaken ? Icons.check_rounded : Icons.add_rounded,
                              size: 13,
                              color: isTaken ? Colors.white : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isTaken ? 'Preso' : 'Segna',
                              style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700,
                                color: isTaken ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header pill ─────────────────────────────────────────────
class _HeaderPill extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool highlight;

  const _HeaderPill({
    required this.value,
    required this.label,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: highlight ? 0.3 : 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.heroText),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800,
                  color: AppColors.heroText, height: 1,
                ),
              ),
              Text(label,
                style: const TextStyle(
                  fontSize: 9, color: AppColors.heroTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
