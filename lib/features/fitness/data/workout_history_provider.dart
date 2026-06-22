import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/workout_session_model.dart';

class WorkoutHistoryNotifier extends Notifier<List<WorkoutSession>> {
  static const _key = 'workout_session_history';

  @override
  List<WorkoutSession> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => WorkoutSession.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((s) => s.toJson()).toList()));
  }

  Future<void> addSession(WorkoutSession session) async {
    state = [...state, session];
    await _save();
  }
}

final workoutHistoryProvider =
    NotifierProvider<WorkoutHistoryNotifier, List<WorkoutSession>>(
        WorkoutHistoryNotifier.new);
