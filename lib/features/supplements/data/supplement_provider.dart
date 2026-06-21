import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplementState {
  final Set<String> activeIds;
  final Set<String> takenTodayIds;

  const SupplementState({
    required this.activeIds,
    required this.takenTodayIds,
  });

  SupplementState copyWith({Set<String>? activeIds, Set<String>? takenTodayIds}) {
    return SupplementState(
      activeIds: activeIds ?? this.activeIds,
      takenTodayIds: takenTodayIds ?? this.takenTodayIds,
    );
  }
}

class SupplementNotifier extends Notifier<SupplementState> {
  static const _activeKey = 'supplement_active_ids';

  String get _takenKey {
    final now = DateTime.now();
    return 'supplement_taken_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  SupplementState build() {
    _load();
    return const SupplementState(activeIds: {}, takenTodayIds: {});
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final activeRaw = prefs.getString(_activeKey);
    final takenRaw = prefs.getString(_takenKey);

    final activeIds = activeRaw != null
        ? Set<String>.from(jsonDecode(activeRaw) as List)
        : <String>{};
    final takenTodayIds = takenRaw != null
        ? Set<String>.from(jsonDecode(takenRaw) as List)
        : <String>{};

    state = SupplementState(activeIds: activeIds, takenTodayIds: takenTodayIds);
  }

  Future<void> toggleActive(String id) async {
    final newActive = Set<String>.from(state.activeIds);
    if (newActive.contains(id)) {
      newActive.remove(id);
      final newTaken = Set<String>.from(state.takenTodayIds)..remove(id);
      state = state.copyWith(activeIds: newActive, takenTodayIds: newTaken);
    } else {
      newActive.add(id);
      state = state.copyWith(activeIds: newActive);
    }
    await _saveActive();
    await _saveTaken();
  }

  Future<void> toggleTaken(String id) async {
    final newTaken = Set<String>.from(state.takenTodayIds);
    if (newTaken.contains(id)) {
      newTaken.remove(id);
    } else {
      newTaken.add(id);
    }
    state = state.copyWith(takenTodayIds: newTaken);
    await _saveTaken();
  }

  Future<void> _saveActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, jsonEncode(state.activeIds.toList()));
  }

  Future<void> _saveTaken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_takenKey, jsonEncode(state.takenTodayIds.toList()));
  }
}

final supplementProvider = NotifierProvider<SupplementNotifier, SupplementState>(
  SupplementNotifier.new,
);
