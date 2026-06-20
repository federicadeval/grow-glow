import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/supplement_provider.dart';
import '../../data/supplements_database.dart';
import '../../domain/supplement.dart';

class SupplementsListScreen extends ConsumerWidget {
  const SupplementsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppState = ref.watch(supplementProvider);

    final grouped = <SupplementCategory, List<Supplement>>{};
    for (final s in kSupplements) {
      grouped.putIfAbsent(s.category, () => []).add(s);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('I miei integratori'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.supplement.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 15, color: AppColors.supplementDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Attiva solo gli integratori che stai usando o hai acquistato. Appariranno nella tua routine giornaliera.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.supplementDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          for (final category in SupplementCategory.values) ...[
            _CategoryHeader(category: category),
            const SizedBox(height: 10),
            ...grouped[category]!.map((s) => _SupplementCard(
                  supplement: s,
                  isActive: suppState.activeIds.contains(s.id),
                  onToggle: () => ref
                      .read(supplementProvider.notifier)
                      .toggleActive(s.id),
                )),
            const SizedBox(height: 20),
          ],
        ],
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: category.bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 13, color: category.fgColor),
              const SizedBox(width: 5),
              Text(category.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
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
class _SupplementCard extends StatefulWidget {
  final Supplement supplement;
  final bool isActive;
  final VoidCallback onToggle;

  const _SupplementCard({
    required this.supplement,
    required this.isActive,
    required this.onToggle,
  });

  @override
  State<_SupplementCard> createState() => _SupplementCardState();
}

class _SupplementCardState extends State<_SupplementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.supplement.category;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: widget.isActive
              ? cat.bgColor.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isActive ? cat.bgColor : AppColors.divider,
            width: widget.isActive ? 1.5 : 1,
          ),
          boxShadow: widget.isActive
              ? null
              : [
                  BoxShadow(
                    color: AppColors.divider.withValues(alpha: 0.8),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(Icons.medication_rounded,
                        size: 22, color: cat.fgColor),
                  ),
                  const SizedBox(width: 12),

                  // Name + dosage
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.supplement.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(widget.supplement.dosage,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: widget.supplement.timing.map((t) =>
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: cat.bgColor.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(t.label,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: cat.fgColor),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Active toggle
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? cat.fgColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.isActive ? cat.fgColor : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        widget.isActive ? 'Attivo' : 'Aggiungi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: widget.isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Expandable: benefit + note
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 12),
                          Text(widget.supplement.benefit,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          if (widget.supplement.note != null) ...[
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
                                      size: 13,
                                      color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(widget.supplement.note!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
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
            ],
          ),
        ),
      ),
    );
  }
}
