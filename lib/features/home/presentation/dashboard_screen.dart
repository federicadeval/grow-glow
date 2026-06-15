import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
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

    final waterBottles = waterMl ~/ WaterNotifier.bottleMl;
    final waterGoalBottles = WaterNotifier.goalMl ~/ WaterNotifier.bottleMl;
    final waterProgress = (waterMl / WaterNotifier.goalMl).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting! 👋',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        _formatDate(now),
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/profile'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lavender,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person_rounded, color: AppColors.lavenderDark, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Kcal card
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('🔥 Calorie oggi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        GestureDetector(
                          onTap: () => context.go('/fitness'),
                          child: Text('Dettaglio →', style: TextStyle(fontSize: 12, color: AppColors.fitnessDark)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: kcalProgress,
                        minHeight: 8,
                        backgroundColor: AppColors.fitness,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.fitnessDark),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _KcalStat('🎯', 'Obiettivo', '$targetKcal'),
                        _KcalStat('🏋️', 'Bruciato', '${calories.burnedKcal}'),
                        _KcalStat('🍽️', 'Consumato', '${calories.consumedKcal}'),
                        _KcalStat('✅', 'Rimanenti', '$remaining'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Acqua card
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💧 Acqua oggi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: waterProgress,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFBBDEFB),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$waterBottles / $waterGoalBottles borracce',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _WaterButton(
                          icon: Icons.remove_circle_outline,
                          color: AppColors.textSecondary,
                          onTap: () => ref.read(waterProvider.notifier).removeBottle(),
                        ),
                        const SizedBox(width: 8),
                        _WaterButton(
                          icon: Icons.add_circle_outline,
                          color: const Color(0xFF1E88E5),
                          onTap: () => ref.read(waterProvider.notifier).addBottle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Shortcuts
              const Text('Sezioni', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _ShortcutCard(
                    label: 'Palestra',
                    emoji: '🏋️',
                    color: AppColors.fitness,
                    darkColor: AppColors.fitnessDark,
                    onTap: () => context.go('/fitness'),
                  ),
                  _ShortcutCard(
                    label: 'Dieta',
                    emoji: '🥗',
                    color: const Color(0xFFD4F0D4),
                    darkColor: const Color(0xFF2E7D32),
                    onTap: () => context.go('/fitness/diet'),
                  ),
                  _ShortcutCard(
                    label: 'Beauty',
                    emoji: '✨',
                    color: AppColors.beauty,
                    darkColor: AppColors.beautyDark,
                    onTap: () => context.go('/beauty'),
                  ),
                  _ShortcutCard(
                    label: 'Todo',
                    emoji: '✅',
                    color: AppColors.todo,
                    darkColor: AppColors.todoDark,
                    onTap: () => context.go('/todo'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Riepilogo settimanale
              const Text('Settimana', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _WeeklySummary(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const giorni = ['lunedì', 'martedì', 'mercoledì', 'giovedì', 'venerdì', 'sabato', 'domenica'];
    const mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu', 'lug', 'ago', 'set', 'ott', 'nov', 'dic'];
    return '${giorni[d.weekday - 1]} ${d.day} ${mesi[d.month - 1]}';
  }
}

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

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ultimi 7 giorni', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              Text('$allenamenti allenamenti · $totalKcal kcal', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_days.length, (i) {
              final d = _days[i];
              final isToday = i == _days.length - 1;
              final barH = maxKcal > 0 ? (d.burnedKcal / maxKcal * 60).clamp(4.0, 60.0) : 4.0;
              final hasWater = d.waterMl >= WaterNotifier.goalMl;
              return Expanded(
                child: Column(
                  children: [
                    if (d.burnedKcal > 0)
                      Text('${d.burnedKcal}', style: TextStyle(fontSize: 9, color: AppColors.fitnessDark)),
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
                    Text(giorni[d.day.weekday - 1], style: TextStyle(fontSize: 11, color: isToday ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isToday ? FontWeight.w700 : FontWeight.normal)),
                    const SizedBox(height: 2),
                    Icon(Icons.water_drop_rounded, size: 10, color: hasWater ? const Color(0xFF1E88E5) : AppColors.divider),
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

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _KcalStat extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _KcalStat(this.emoji, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final Color darkColor;
  final VoidCallback onTap;
  const _ShortcutCard({required this.label, required this.emoji, required this.color, required this.darkColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: darkColor)),
          ],
        ),
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _WaterButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
