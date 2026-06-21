import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeautyProductState {
  final Set<String> activeIds;

  const BeautyProductState({required this.activeIds});

  BeautyProductState copyWith({Set<String>? activeIds}) =>
      BeautyProductState(activeIds: activeIds ?? this.activeIds);
}

class BeautyProductNotifier extends Notifier<BeautyProductState> {
  static const _activeKey = 'beauty_active_product_ids';

  @override
  BeautyProductState build() {
    _load();
    return const BeautyProductState(activeIds: {});
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeKey);
    final ids = raw != null
        ? Set<String>.from(jsonDecode(raw) as List)
        : <String>{};
    state = BeautyProductState(activeIds: ids);
  }

  Future<void> toggleActive(String id) async {
    final newIds = Set<String>.from(state.activeIds);
    if (newIds.contains(id)) {
      newIds.remove(id);
    } else {
      newIds.add(id);
    }
    state = state.copyWith(activeIds: newIds);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKey, jsonEncode(newIds.toList()));
  }
}

final beautyProductProvider =
    NotifierProvider<BeautyProductNotifier, BeautyProductState>(
  BeautyProductNotifier.new,
);
