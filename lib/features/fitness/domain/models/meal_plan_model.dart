import 'dart:convert';

// ─── Ingredient ──────────────────────────────────────────────────────────────

class Ingredient {
  final String name;
  final double grams;
  final double kcalPer100g;

  const Ingredient({required this.name, required this.grams, required this.kcalPer100g});

  int get kcal => (grams * kcalPer100g / 100).round();

  Ingredient copyWith({double? grams}) =>
      Ingredient(name: name, grams: grams ?? this.grams, kcalPer100g: kcalPer100g);

  Map<String, dynamic> toJson() => {'name': name, 'grams': grams, 'kcalPer100g': kcalPer100g};

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
    name: j['name'] as String,
    grams: (j['grams'] as num).toDouble(),
    kcalPer100g: (j['kcalPer100g'] as num).toDouble(),
  );
}

// ─── MealType ────────────────────────────────────────────────────────────────

enum MealType { colazione, pranzo, cena, spuntino }

extension MealTypeLabel on MealType {
  String get label {
    switch (this) {
      case MealType.colazione: return 'Colazione';
      case MealType.pranzo: return 'Pranzo';
      case MealType.cena: return 'Cena';
      case MealType.spuntino: return 'Spuntino';
    }
  }

  String get emoji {
    switch (this) {
      case MealType.colazione: return '🌅';
      case MealType.pranzo: return '☀️';
      case MealType.cena: return '🌙';
      case MealType.spuntino: return '🍎';
    }
  }
}

class MealEntry {
  final String name;
  final int kcal;          // manual kcal (used when ingredients list is empty)
  final String notes;
  final bool isEatingOut;
  final List<Ingredient> ingredients;

  const MealEntry({
    required this.name,
    required this.kcal,
    this.notes = '',
    this.isEatingOut = false,
    this.ingredients = const [],
  });

  bool get isEmpty => name.isEmpty;

  /// Returns ingredients-based kcal if available, otherwise manual kcal.
  int get effectiveKcal =>
      ingredients.isNotEmpty ? ingredients.fold(0, (s, i) => s + i.kcal) : kcal;

  MealEntry copyWith({
    String? name,
    int? kcal,
    String? notes,
    bool? isEatingOut,
    List<Ingredient>? ingredients,
  }) {
    return MealEntry(
      name: name ?? this.name,
      kcal: kcal ?? this.kcal,
      notes: notes ?? this.notes,
      isEatingOut: isEatingOut ?? this.isEatingOut,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'kcal': kcal,
    'notes': notes,
    'isEatingOut': isEatingOut,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
  };

  factory MealEntry.fromJson(Map<String, dynamic> j) => MealEntry(
    name: j['name'] as String? ?? '',
    kcal: j['kcal'] as int? ?? 0,
    notes: j['notes'] as String? ?? '',
    isEatingOut: j['isEatingOut'] as bool? ?? false,
    ingredients: (j['ingredients'] as List<dynamic>?)
        ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],
  );

  static const empty = MealEntry(name: '', kcal: 0);
}

class DayMeals {
  final MealEntry colazione;
  final MealEntry pranzo;
  final MealEntry cena;
  final MealEntry spuntino;

  const DayMeals({
    this.colazione = MealEntry.empty,
    this.pranzo = MealEntry.empty,
    this.cena = MealEntry.empty,
    this.spuntino = MealEntry.empty,
  });

  int get totalKcal => colazione.kcal + pranzo.kcal + cena.kcal + spuntino.kcal;

  MealEntry getByType(MealType type) {
    switch (type) {
      case MealType.colazione: return colazione;
      case MealType.pranzo: return pranzo;
      case MealType.cena: return cena;
      case MealType.spuntino: return spuntino;
    }
  }

  DayMeals setByType(MealType type, MealEntry entry) {
    return DayMeals(
      colazione: type == MealType.colazione ? entry : colazione,
      pranzo: type == MealType.pranzo ? entry : pranzo,
      cena: type == MealType.cena ? entry : cena,
      spuntino: type == MealType.spuntino ? entry : spuntino,
    );
  }

  Map<String, dynamic> toJson() => {
    'colazione': colazione.toJson(),
    'pranzo': pranzo.toJson(),
    'cena': cena.toJson(),
    'spuntino': spuntino.toJson(),
  };

  factory DayMeals.fromJson(Map<String, dynamic> j) => DayMeals(
    colazione: MealEntry.fromJson(j['colazione'] as Map<String, dynamic>? ?? {}),
    pranzo: MealEntry.fromJson(j['pranzo'] as Map<String, dynamic>? ?? {}),
    cena: MealEntry.fromJson(j['cena'] as Map<String, dynamic>? ?? {}),
    spuntino: MealEntry.fromJson(j['spuntino'] as Map<String, dynamic>? ?? {}),
  );
}

// Key: 0=Mon … 6=Sun
class WeekMealPlan {
  final Map<int, DayMeals> days;

  const WeekMealPlan({required this.days});

  factory WeekMealPlan.empty() => WeekMealPlan(
    days: {for (int i = 0; i < 7; i++) i: const DayMeals()},
  );

  DayMeals day(int index) => days[index] ?? const DayMeals();

  WeekMealPlan setDay(int index, DayMeals meals) {
    final updated = Map<int, DayMeals>.from(days);
    updated[index] = meals;
    return WeekMealPlan(days: updated);
  }

  String toJson() => jsonEncode({
    for (final e in days.entries) '${e.key}': e.value.toJson(),
  });

  factory WeekMealPlan.fromJson(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return WeekMealPlan(days: {
      for (final e in map.entries)
        int.parse(e.key): DayMeals.fromJson(e.value as Map<String, dynamic>),
    });
  }

  // Returns the ISO week key for a given date: YYYY-WW
  static String weekKey(DateTime date) {
    final jan4 = DateTime(date.year, 1, 4);
    final startOfWeek1 = jan4.subtract(Duration(days: jan4.weekday - 1));
    final weekNum = ((date.difference(startOfWeek1).inDays) / 7).floor() + 1;
    return '${date.year}-${weekNum.toString().padLeft(2, '0')}';
  }
}
