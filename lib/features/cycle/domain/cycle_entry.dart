import 'package:flutter/material.dart';

enum CyclePhase { mestruale, follicolare, ovulatoria, luteinica }

extension CyclePhaseData on CyclePhase {
  String get label {
    switch (this) {
      case CyclePhase.mestruale:   return 'Mestruale';
      case CyclePhase.follicolare: return 'Follicolare';
      case CyclePhase.ovulatoria:  return 'Ovulatoria';
      case CyclePhase.luteinica:   return 'Luteinica';
    }
  }

  String get emoji {
    switch (this) {
      case CyclePhase.mestruale:   return '🌸';
      case CyclePhase.follicolare: return '🌱';
      case CyclePhase.ovulatoria:  return '⭐';
      case CyclePhase.luteinica:   return '🌙';
    }
  }

  String get description {
    switch (this) {
      case CyclePhase.mestruale:   return 'Riposati e prenditi cura di te';
      case CyclePhase.follicolare: return 'Energia in crescita, ottimo per allenarsi';
      case CyclePhase.ovulatoria:  return 'Picco di energia e vitalità';
      case CyclePhase.luteinica:   return 'Rallenta, ascolta il tuo corpo';
    }
  }

  Color get color {
    switch (this) {
      case CyclePhase.mestruale:   return const Color(0xFFF2C4CE);
      case CyclePhase.follicolare: return const Color(0xFFB8DDB8);
      case CyclePhase.ovulatoria:  return const Color(0xFFFFE08A);
      case CyclePhase.luteinica:   return const Color(0xFFCEC0E8);
    }
  }

  Color get darkColor {
    switch (this) {
      case CyclePhase.mestruale:   return const Color(0xFF8B2040);
      case CyclePhase.follicolare: return const Color(0xFF1A5C1A);
      case CyclePhase.ovulatoria:  return const Color(0xFF7A5A00);
      case CyclePhase.luteinica:   return const Color(0xFF3A2060);
    }
  }

  int daysCount(int cycleLength, int periodLength) {
    switch (this) {
      case CyclePhase.mestruale:   return periodLength;
      case CyclePhase.follicolare: return 13 - periodLength;
      case CyclePhase.ovulatoria:  return 3;
      case CyclePhase.luteinica:   return cycleLength - 16;
    }
  }
}
