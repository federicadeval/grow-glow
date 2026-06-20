import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum ProductCategory {
  cleanser,
  serum,
  moisturizer,
  spf,
  exfoliant,
  retinoid,
  treatment,
}

extension ProductCategoryData on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.cleanser:   return 'Detergente';
      case ProductCategory.serum:      return 'Siero';
      case ProductCategory.moisturizer:return 'Idratante';
      case ProductCategory.spf:        return 'SPF';
      case ProductCategory.exfoliant:  return 'Esfoliante';
      case ProductCategory.retinoid:   return 'Retinoide';
      case ProductCategory.treatment:  return 'Trattamento';
    }
  }

  Color get bgColor {
    switch (this) {
      case ProductCategory.cleanser:   return AppColors.sky;
      case ProductCategory.serum:      return AppColors.peach;
      case ProductCategory.moisturizer:return AppColors.beauty;
      case ProductCategory.spf:        return AppColors.cream;
      case ProductCategory.exfoliant:  return AppColors.mint;
      case ProductCategory.retinoid:   return AppColors.lavender;
      case ProductCategory.treatment:  return AppColors.blush;
    }
  }

  Color get fgColor {
    switch (this) {
      case ProductCategory.cleanser:   return const Color(0xFF2A7FB0);
      case ProductCategory.serum:      return AppColors.peachDark;
      case ProductCategory.moisturizer:return AppColors.beautyDark;
      case ProductCategory.spf:        return AppColors.peachDark;
      case ProductCategory.exfoliant:  return AppColors.mintDark;
      case ProductCategory.retinoid:   return AppColors.lavenderDark;
      case ProductCategory.treatment:  return AppColors.blushDark;
    }
  }
}

enum ProductTiming { morning, evening, both }

extension ProductTimingData on ProductTiming {
  String get label {
    switch (this) {
      case ProductTiming.morning: return 'Mattina';
      case ProductTiming.evening: return 'Sera';
      case ProductTiming.both:    return 'Mattina & Sera';
    }
  }
}

class Product {
  final String id;
  final String fullName;
  final String brand;
  final String shortName;
  final ProductCategory category;
  final String description;
  final String howToUse;
  final List<String> keyIngredients;
  final IconData icon;
  final ProductTiming timing;
  final String? warnings;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.fullName,
    required this.brand,
    required this.shortName,
    required this.category,
    required this.description,
    required this.howToUse,
    this.keyIngredients = const [],
    required this.icon,
    required this.timing,
    this.warnings,
    this.imageUrl,
  });
}
