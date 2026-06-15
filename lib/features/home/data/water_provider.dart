import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterNotifier extends Notifier<int> {
  static const _bottleMl = 500;
  static const _goalMl = 2000;

  static int get bottleMl => _bottleMl;
  static int get goalMl => _goalMl;

  String get _key {
    final now = DateTime.now();
    return 'water_ml_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  int build() {
    _load();
    return 0;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(_key) ?? 0;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, state);
  }

  void addBottle() {
    state = state + _bottleMl;
    _save();
  }

  void removeBottle() {
    if (state >= _bottleMl) {
      state = state - _bottleMl;
      _save();
    }
  }
}

final waterProvider = NotifierProvider<WaterNotifier, int>(WaterNotifier.new);
