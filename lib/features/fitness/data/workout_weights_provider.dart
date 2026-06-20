import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutWeightsNotifier extends Notifier<Map<String, String>> {
  static const _key = 'workout_custom_weights';

  @override
  Map<String, String> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      state = map.cast<String, String>();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state));
  }

  String? getWeight(String workoutId, int exerciseIndex) =>
      state['${workoutId}_$exerciseIndex'];

  Future<void> setWeightsForWorkout(String workoutId, List<String> weights) async {
    final updated = Map<String, String>.from(state);
    for (var i = 0; i < weights.length; i++) {
      if (weights[i].isNotEmpty) updated['${workoutId}_$i'] = weights[i];
    }
    state = updated;
    await _save();
  }
}

final workoutWeightsProvider =
    NotifierProvider<WorkoutWeightsNotifier, Map<String, String>>(
        WorkoutWeightsNotifier.new);
