import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/symptom.dart';

typedef SymptomMap = Map<String, Set<CycleSymptom>>;

class SymptomNotifier extends StateNotifier<SymptomMap> {
  SymptomNotifier() : super({}) {
    _load();
  }

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final result = <String, Set<CycleSymptom>>{};
    for (final key in prefs.getKeys()) {
      if (!key.startsWith('symptoms_v1_')) continue;
      final dateKey = key.substring('symptoms_v1_'.length);
      final raw = prefs.getString(key);
      if (raw == null) continue;
      final List<dynamic> list = jsonDecode(raw);
      result[dateKey] = list
          .map((s) => CycleSymptom.values.firstWhere(
                (e) => e.name == s,
                orElse: () => CycleSymptom.crampi,
              ))
          .toSet();
    }
    state = result;
  }

  Future<void> toggle(DateTime date, CycleSymptom symptom) async {
    final key = _dateKey(date);
    final current = Set<CycleSymptom>.from(state[key] ?? {});
    if (current.contains(symptom)) {
      current.remove(symptom);
    } else {
      current.add(symptom);
    }
    final newState = Map<String, Set<CycleSymptom>>.from(state);
    if (current.isEmpty) {
      newState.remove(key);
    } else {
      newState[key] = current;
    }
    final prefs = await SharedPreferences.getInstance();
    if (current.isEmpty) {
      await prefs.remove('symptoms_v1_$key');
    } else {
      await prefs.setString(
          'symptoms_v1_$key', jsonEncode(current.map((e) => e.name).toList()));
    }
    state = newState;
  }
}

final symptomProvider =
    StateNotifierProvider<SymptomNotifier, SymptomMap>((ref) => SymptomNotifier());
