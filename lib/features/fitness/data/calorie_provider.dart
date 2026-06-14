import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyCalories {
  final int burnedKcal;      // da allenamenti
  final int consumedKcal;    // da pasti
  final String date;         // yyyy-MM-dd

  const DailyCalories({
    required this.burnedKcal,
    required this.consumedKcal,
    required this.date,
  });

  DailyCalories copyWith({int? burnedKcal, int? consumedKcal}) => DailyCalories(
    burnedKcal: burnedKcal ?? this.burnedKcal,
    consumedKcal: consumedKcal ?? this.consumedKcal,
    date: date,
  );

  Map<String, dynamic> toJson() => {
    'burnedKcal': burnedKcal,
    'consumedKcal': consumedKcal,
    'date': date,
  };

  factory DailyCalories.fromJson(Map<String, dynamic> json) => DailyCalories(
    burnedKcal: json['burnedKcal'] as int,
    consumedKcal: json['consumedKcal'] as int,
    date: json['date'] as String,
  );

  static String get todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
  }
}

class CalorieNotifier extends Notifier<DailyCalories> {
  static const _kPrefix = 'daily_kcal_';

  @override
  DailyCalories build() {
    final today = DailyCalories.todayKey;
    _load(today);
    return DailyCalories(burnedKcal: 0, consumedKcal: 0, date: today);
  }

  Future<void> _load(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_kPrefix$date');
    if (raw != null) {
      state = DailyCalories.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_kPrefix${state.date}', jsonEncode(state.toJson()));
  }

  Future<void> addBurned(int kcal) async {
    state = state.copyWith(burnedKcal: state.burnedKcal + kcal);
    await _save();
  }

  Future<void> addConsumed(int kcal) async {
    state = state.copyWith(consumedKcal: state.consumedKcal + kcal);
    await _save();
  }

  Future<void> removeConsumed(int kcal) async {
    final newVal = (state.consumedKcal - kcal).clamp(0, 99999);
    state = state.copyWith(consumedKcal: newVal);
    await _save();
  }
}

final calorieProvider = NotifierProvider<CalorieNotifier, DailyCalories>(
  CalorieNotifier.new,
);
