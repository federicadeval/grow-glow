import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomFoodItem {
  final String name;
  final String brand;
  final String barcode;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;

  const CustomFoodItem({
    required this.name,
    this.brand = '',
    this.barcode = '',
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
  });

  String get displayName => brand.isNotEmpty ? '$name ($brand)' : name;

  Map<String, dynamic> toMap() => {
    'name': name,
    'brand': brand,
    'barcode': barcode,
    'kcalPer100g': kcalPer100g,
    'proteinPer100g': proteinPer100g,
    'carbsPer100g': carbsPer100g,
    'fatPer100g': fatPer100g,
  };

  factory CustomFoodItem.fromMap(Map<String, dynamic> m) => CustomFoodItem(
    name: m['name'] as String,
    brand: (m['brand'] as String?) ?? '',
    barcode: (m['barcode'] as String?) ?? '',
    kcalPer100g: (m['kcalPer100g'] as num).toDouble(),
    proteinPer100g: (m['proteinPer100g'] as num).toDouble(),
    carbsPer100g: (m['carbsPer100g'] as num).toDouble(),
    fatPer100g: (m['fatPer100g'] as num).toDouble(),
  );
}

class CustomFoodNotifier extends Notifier<List<CustomFoodItem>> {
  static const _key = 'custom_foods_db';

  @override
  List<CustomFoodItem> build() {
    _load();
    return [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final list = (jsonDecode(raw) as List<dynamic>)
        .map((e) => CustomFoodItem.fromMap(e as Map<String, dynamic>))
        .toList();
    state = list;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.map((e) => e.toMap()).toList()));
  }

  Future<void> add(CustomFoodItem item) async {
    // Replaces existing entry with same barcode (if non-empty) or same name+brand.
    state = [
      ...state.where((e) =>
        !(item.barcode.isNotEmpty && e.barcode == item.barcode) &&
        !(e.name == item.name && e.brand == item.brand)),
      item,
    ];
    await _persist();
  }

  Future<void> remove(CustomFoodItem item) async {
    state = state.where((e) => !(e.name == item.name && e.brand == item.brand && e.barcode == item.barcode)).toList();
    await _persist();
  }

  CustomFoodItem? findByBarcode(String barcode) {
    if (barcode.isEmpty) return null;
    try {
      return state.firstWhere((e) => e.barcode.isNotEmpty && e.barcode == barcode);
    } catch (_) {
      return null;
    }
  }

  List<CustomFoodItem> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return state.where((e) =>
      e.name.toLowerCase().contains(q) ||
      e.brand.toLowerCase().contains(q)).toList();
  }
}

final customFoodProvider = NotifierProvider<CustomFoodNotifier, List<CustomFoodItem>>(
  CustomFoodNotifier.new,
);
