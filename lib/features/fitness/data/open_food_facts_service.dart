import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodFactsResult {
  final String name;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final String brand;

  const FoodFactsResult({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.brand = '',
  });

  String get displayName => brand.isNotEmpty ? '$name ($brand)' : name;
}

class OpenFoodFactsService {
  static Future<FoodFactsResult?> lookup(String barcode) async {
    final barcodeTrimmed = barcode.trim();
    if (barcodeTrimmed.isEmpty) return null;

    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcodeTrimmed.json?fields=product_name,brands,nutriments',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'GrowGlow/1.0'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if ((json['status'] as int?) != 1) return null;

      final product = json['product'] as Map<String, dynamic>? ?? {};
      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

      final name = (product['product_name'] as String?)?.trim() ?? '';
      if (name.isEmpty) return null;

      double _n(String key) {
        final v = nutriments[key];
        if (v == null) return 0;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0;
      }

      // prefer _100g suffix, fall back to base key
      final kcal = _n('energy-kcal_100g') > 0
          ? _n('energy-kcal_100g')
          : _n('energy_100g') / 4.184; // kJ → kcal fallback

      return FoodFactsResult(
        name: name,
        kcalPer100g: kcal,
        proteinPer100g: _n('proteins_100g'),
        carbsPer100g: _n('carbohydrates_100g'),
        fatPer100g: _n('fat_100g'),
        brand: (product['brands'] as String?)?.split(',').first.trim() ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
