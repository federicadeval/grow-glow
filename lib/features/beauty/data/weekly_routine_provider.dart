import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/weekly_routine.dart';

class WeeklyRoutineNotifier extends Notifier<Map<int, DayRoutineConfig>> {
  static const _prefix = 'beauty_weekly_routine';

  @override
  Map<int, DayRoutineConfig> build() {
    _load();
    return {for (int i = 1; i <= 7; i++) i: DayRoutineConfig(weekday: i)};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<int, DayRoutineConfig> result = {};
    for (int i = 1; i <= 7; i++) {
      final raw = prefs.getString('${_prefix}_$i');
      if (raw != null) {
        result[i] = DayRoutineConfig.fromJson(
            jsonDecode(raw) as Map<String, dynamic>);
      } else {
        result[i] = DayRoutineConfig(weekday: i);
      }
    }
    state = result;
  }

  Future<void> setDayProducts(
      int weekday, bool isMorning, List<String> productIds) async {
    final current =
        state[weekday] ?? DayRoutineConfig(weekday: weekday);
    final updated = isMorning
        ? current.copyWith(morningProductIds: productIds)
        : current.copyWith(eveningProductIds: productIds);
    state = Map.from(state)..[weekday] = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        '${_prefix}_$weekday', jsonEncode(updated.toJson()));
  }
}

final weeklyRoutineProvider =
    NotifierProvider<WeeklyRoutineNotifier, Map<int, DayRoutineConfig>>(
  WeeklyRoutineNotifier.new,
);
