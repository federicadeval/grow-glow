import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../cycle/data/cycle_provider.dart';
import '../../cycle/domain/cycle_entry.dart';
import '../../fitness/data/calorie_provider.dart';
import '../../profile/data/profile_provider.dart';
import '../data/water_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calories = ref.watch(calorieProvider);
    final profile = ref.watch(profileProvider);
    final waterMl = ref.watch(waterProvider);
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12 ? 'Buongiorno' : hour < 18 ? 'Buon pomeriggio' : 'Buonasera';

    final targetKcal = profile?.suggestedKcal.round() ?? 2000;
    final remaining = (targetKcal - calories.consumedKcal + calories.burnedKcal).clamp(0, 99999);
    final kcalProgress = (calories.consumedKcal / targetKcal).clamp(0.0, 1.0);
    final waterL = waterMl / 1000.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Dark hero ──
            _HeroBlock(
              greeting: greeting,
              now: now,
              consumedKcal: calories.consumedKcal,
              targetKcal: targetKcal,
              remaining: remaining,
              kcalProgress: kcalProgress,
              waterL: waterL,
              onAvatarTap: () => context.push('/profile'),
              onWaterTap: () => ref.read(waterProvider.notifier).addBottle(),
              onWaterLongPress: () => ref.read(waterProvider.notifier).removeBottle(),
            ),

            // ── White peel + sections ──
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Le sezioni',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.35,
                      children: [
                        _SectionCard(
                          label: 'Fitness',
                          icon: Icons.fitness_center_rounded,
                          color: AppColors.fitness,
                          darkColor: AppColors.fitnessDark,
                          onTap: () => context.go('/fitness'),
                        ),
                        _SectionCard(
                          label: 'Beauty',
                          icon: Icons.auto_awesome_rounded,
                          color: AppColors.beauty,
                          darkColor: AppColors.beautyDark,
                          onTap: () => context.go('/beauty'),
                        ),
                        _SectionCard(
                          label: 'Dieta',
                          icon: Icons.restaurant_rounded,
                          color: AppColors.diet,
                          darkColor: AppColors.dietDark,
                          onTap: () => context.go('/diet'),
                        ),
                        _SectionCard(
                          label: 'Todo',
                          icon: Icons.checklist_rounded,
                          color: AppColors.todo,
                          darkColor: AppColors.todoDark,
                          onTap: () => context.go('/todo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SupplementSectionCard(
                      onTap: () => context.go('/supplements'),
                    ),
                    const SizedBox(height: 24),
                    const Text('Questa settimana',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 14),
                    _WeeklySummary(),
                    const SizedBox(height: 24),
                    _CycleSectionCard(
                      onTap: () => context.go('/cycle'),
                    ),
                    const SizedBox(height: 24),
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

// ─── Hero block ───────────────────────────────────────────────
class _HeroBlock extends StatelessWidget {
  final String greeting;
  final DateTime now;
  final int consumedKcal;
  final int targetKcal;
  final int remaining;
  final double kcalProgress;
  final double waterL;
  final VoidCallback onAvatarTap;
  final VoidCallback onWaterTap;
  final VoidCallback onWaterLongPress;

  const _HeroBlock({
    required this.greeting,
    required this.now,
    required this.consumedKcal,
    required this.targetKcal,
    required this.remaining,
    required this.kcalProgress,
    required this.waterL,
    required this.onAvatarTap,
    required this.onWaterTap,
    required this.onWaterLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.heroBackground,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blob A — large, bottom right
          Positioned(
            bottom: -70, right: -60,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                color: AppColors.heroBlobA.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Blob B — medium, top left
          Positioned(
            top: 10, left: -25,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppColors.heroBlobB.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Blob C — small accent, top right
          Positioned(
            top: 70, right: 24,
            child: Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: AppColors.heroAccent.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$greeting,',
                            style: const TextStyle(
                              color: AppColors.heroText,
                              fontSize: 22, fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text('Federica!',
                            style: const TextStyle(
                              color: AppColors.heroText,
                              fontSize: 22, fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(_formatDate(now),
                            style: const TextStyle(color: AppColors.heroTextSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onAvatarTap,
                        child: Container(
                          width: 38, height: 38,
                          decoration: const BoxDecoration(
                            color: AppColors.heroBlobB,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.heroText, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stat pills
                  Row(
                    children: [
                      Expanded(child: _StatPill(value: '$consumedKcal', label: 'kcal', sub: 'di $targetKcal')),
                      const SizedBox(width: 8),
                      Expanded(child: _StatPill(
                        value: waterL.toStringAsFixed(1),
                        label: 'litri',
                        sub: waterL >= 2.0 ? 'obiettivo ✓' : 'di 2L · tap +',
                        onTap: onWaterTap,
                        onLongPress: onWaterLongPress,
                      )),
                      const SizedBox(width: 8),
                      Expanded(child: _StatPill(value: '$remaining', label: 'rimaste', sub: 'kcal')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: kcalProgress,
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.heroBlobB),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Calorie oggi',
                        style: TextStyle(color: AppColors.heroTextSecondary, fontSize: 9)),
                      Text('$remaining kcal rimaste',
                        style: const TextStyle(color: AppColors.heroTextSecondary, fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const giorni = ['lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'];
    const mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu', 'lug', 'ago', 'set', 'ott', 'nov', 'dic'];
    return '${giorni[d.weekday - 1]} ${d.day} ${mesi[d.month - 1]}';
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final String sub;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const _StatPill({required this.value, required this.label, required this.sub, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: onTap != null
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: onTap != null ? 0.25 : 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.heroText, height: 1),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: const TextStyle(fontSize: 9, color: AppColors.heroTextSecondary, fontWeight: FontWeight.w600),
          ),
          Text(sub,
            style: const TextStyle(fontSize: 8, color: AppColors.heroTextSecondary),
          ),
        ],
      ),
    );
    if (onTap == null && onLongPress == null) return pill;
    return GestureDetector(onTap: onTap, onLongPress: onLongPress, child: pill);
  }
}

// ─── Section card ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color darkColor;
  final VoidCallback onTap;

  const _SectionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.darkColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: darkColor, size: 18),
            ),
            Text(label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: darkColor),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Weekly summary ───────────────────────────────────────────
class _WeeklySummary extends StatefulWidget {
  @override
  State<_WeeklySummary> createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<_WeeklySummary> {
  List<_DayData> _days = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final result = <_DayData>[];
    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final raw = prefs.getString('daily_kcal_$key');
      int burned = 0;
      if (raw != null) {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        burned = json['burnedKcal'] as int? ?? 0;
      }
      final waterRaw = prefs.getInt('water_ml_$key') ?? 0;
      result.add(_DayData(day: day, burnedKcal: burned, waterMl: waterRaw));
    }
    if (mounted) setState(() => _days = result);
  }

  @override
  Widget build(BuildContext context) {
    if (_days.isEmpty) return const SizedBox.shrink();

    const giorni = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
    final maxKcal = _days.map((d) => d.burnedKcal).fold(0, (a, b) => a > b ? a : b);
    final totalKcal = _days.fold(0, (s, d) => s + d.burnedKcal);
    final allenamenti = _days.where((d) => d.burnedKcal > 0).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ultimi 7 giorni',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('$allenamenti allenamenti · $totalKcal kcal',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_days.length, (i) {
              final d = _days[i];
              final isToday = i == _days.length - 1;
              final barH = maxKcal > 0 ? (d.burnedKcal / maxKcal * 56).clamp(4.0, 56.0) : 4.0;
              final hasWater = d.waterMl >= WaterNotifier.goalMl;
              return Expanded(
                child: Column(
                  children: [
                    if (d.burnedKcal > 0)
                      Text('${d.burnedKcal}',
                        style: const TextStyle(fontSize: 8, color: AppColors.fitnessDark)),
                    const SizedBox(height: 2),
                    Container(
                      height: barH,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.fitnessDark : AppColors.fitness,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(giorni[d.day.weekday - 1],
                      style: TextStyle(
                        fontSize: 10,
                        color: isToday ? AppColors.textPrimary : AppColors.textSecondary,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Icon(Icons.water_drop_rounded,
                      size: 10,
                      color: hasWater ? AppColors.dietDark : AppColors.divider,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DayData {
  final DateTime day;
  final int burnedKcal;
  final int waterMl;
  const _DayData({required this.day, required this.burnedKcal, required this.waterMl});
}

// ─── Supplement section card (full-width) ────────────────────
class _SupplementSectionCard extends StatelessWidget {
  final VoidCallback onTap;
  const _SupplementSectionCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.supplement,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(Icons.medication_rounded,
                  color: AppColors.supplementDark, size: 18),
            ),
            const SizedBox(width: 12),
            Text('Integratori',
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800,
                color: AppColors.supplementDark,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.supplementDark, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Cycle section card (compact, full-width) ────────────────
class _CycleSectionCard extends ConsumerWidget {
  final VoidCallback onTap;
  const _CycleSectionCard({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycle = ref.watch(cycleProvider);

    if (cycle.lastPeriodDate == null) {
      return GestureDetector(
        onTap: () => context.push('/profile'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2C4CE).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF2C4CE)),
          ),
          child: const Row(
            children: [
              Text('🌸', style: TextStyle(fontSize: 22)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ciclo',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF8B2040)),
                    ),
                    Text('Configura nel Profilo',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      );
    }

    final phase = cycle.currentPhase!;
    final daysLeft = cycle.daysToNextPeriod!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: phase.color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: phase.color),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: phase.color, shape: BoxShape.circle),
              child: Center(child: Text(phase.emoji, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ciclo · ${phase.label}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: phase.darkColor),
                  ),
                  Text(phase.description,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$daysLeft gg',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: phase.darkColor),
                ),
                Text('al prossimo',
                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: phase.darkColor, size: 18),
          ],
        ),
      ),
    );
  }
}
