import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text('Grow &\nGlow',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.lavenderDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text('Il tuo spazio per crescere ogni giorno.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Entra'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
