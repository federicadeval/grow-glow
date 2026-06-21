import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/fitness')) return 1;
    if (location.startsWith('/diet')) return 2;
    if (location.startsWith('/beauty')) return 3;
    if (location.startsWith('/todo')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  color: AppColors.lavenderDark,
                  bgColor: AppColors.lavender,
                  isSelected: currentIndex == 0,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'Fitness',
                  color: AppColors.fitnessDark,
                  bgColor: AppColors.fitness,
                  isSelected: currentIndex == 1,
                  onTap: () => context.go('/fitness'),
                ),
                _NavItem(
                  icon: Icons.restaurant_rounded,
                  label: 'Dieta',
                  color: AppColors.dietDark,
                  bgColor: AppColors.diet,
                  isSelected: currentIndex == 2,
                  onTap: () => context.go('/diet'),
                ),
                _NavItem(
                  icon: Icons.auto_awesome_rounded,
                  label: 'Beauty',
                  color: AppColors.beautyDark,
                  bgColor: AppColors.beauty,
                  isSelected: currentIndex == 3,
                  onTap: () => context.go('/beauty'),
                ),
                _NavItem(
                  icon: Icons.checklist_rounded,
                  label: 'Todo',
                  color: AppColors.todoDark,
                  bgColor: AppColors.todo,
                  isSelected: currentIndex == 4,
                  onTap: () => context.go('/todo'),
                ),
              ],
            ),
          ),
        ),
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
          horizontal: isSelected ? 16 : 12,
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
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
