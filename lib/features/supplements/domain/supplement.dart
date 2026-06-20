import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum SupplementCategory { fitness, salute, beauty }

extension SupplementCategoryData on SupplementCategory {
  String get label {
    switch (this) {
      case SupplementCategory.fitness: return 'Fitness';
      case SupplementCategory.salute:  return 'Salute';
      case SupplementCategory.beauty:  return 'Beauty';
    }
  }

  Color get bgColor {
    switch (this) {
      case SupplementCategory.fitness: return AppColors.fitness;
      case SupplementCategory.salute:  return AppColors.diet;
      case SupplementCategory.beauty:  return AppColors.beauty;
    }
  }

  Color get fgColor {
    switch (this) {
      case SupplementCategory.fitness: return AppColors.fitnessDark;
      case SupplementCategory.salute:  return AppColors.dietDark;
      case SupplementCategory.beauty:  return AppColors.beautyDark;
    }
  }

  IconData get icon {
    switch (this) {
      case SupplementCategory.fitness: return Icons.fitness_center_rounded;
      case SupplementCategory.salute:  return Icons.favorite_rounded;
      case SupplementCategory.beauty:  return Icons.auto_awesome_rounded;
    }
  }
}

enum SupplementTiming { mattina, sera, pasto, preWorkout, postWorkout }

extension SupplementTimingData on SupplementTiming {
  String get label {
    switch (this) {
      case SupplementTiming.mattina:     return 'Mattina';
      case SupplementTiming.sera:        return 'Sera';
      case SupplementTiming.pasto:       return 'Con i pasti';
      case SupplementTiming.preWorkout:  return 'Pre-workout';
      case SupplementTiming.postWorkout: return 'Post-workout';
    }
  }
}

class Supplement {
  final String id;
  final String name;
  final String dosage;
  final SupplementCategory category;
  final List<SupplementTiming> timing;
  final String benefit;
  final String? note;

  const Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.category,
    required this.timing,
    required this.benefit,
    this.note,
  });
}
