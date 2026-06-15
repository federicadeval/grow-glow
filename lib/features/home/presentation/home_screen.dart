import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/water_provider.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/beauty')) return 1;
    if (location.startsWith('/todo')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WaterBanner(ref: ref),
          Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'Fitness',
                  color: AppColors.fitnessDark,
                  bgColor: AppColors.fitness,
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/fitness'),
                ),
                _NavItem(
                  icon: Icons.auto_awesome_rounded,
                  label: 'Beauty',
                  color: AppColors.beautyDark,
                  bgColor: AppColors.beauty,
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/beauty'),
                ),
                _NavItem(
                  icon: Icons.checklist_rounded,
                  label: 'Todo',
                  color: AppColors.todoDark,
                  bgColor: AppColors.todo,
                  isSelected: currentIndex == 2,
                  onTap: () => context.go('/todo'),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _WaterBanner extends StatelessWidget {
  final WidgetRef ref;
  const _WaterBanner({required this.ref});

  @override
  Widget build(BuildContext context) {
    final ml = ref.watch(waterProvider);
    final goal = WaterNotifier.goalMl;
    final bottle = WaterNotifier.bottleMl;
    final bottles = ml ~/ bottle;
    final totalBottles = goal ~/ bottle;
    final progress = (ml / goal).clamp(0.0, 1.0);

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('💧', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$bottles / $totalBottles borracce',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${ml} / ${goal} ml',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFBBDEFB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => ref.read(waterProvider.notifier).removeBottle(),
            icon: const Icon(Icons.remove_circle_outline, size: 22),
            color: AppColors.textSecondary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => ref.read(waterProvider.notifier).addBottle(),
            icon: const Icon(Icons.add_circle_outline, size: 22),
            color: const Color(0xFF1E88E5),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textSecondary, size: 22),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
