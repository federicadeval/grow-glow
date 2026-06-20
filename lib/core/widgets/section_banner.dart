import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color fgColor;
  final Widget? trailing;

  const SectionBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.bgColor = AppColors.heroBackground,
    this.fgColor = AppColors.heroText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = fgColor.withValues(alpha: 0.65);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: fgColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: fgColor,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                  style: TextStyle(fontSize: 13, color: secondary),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
