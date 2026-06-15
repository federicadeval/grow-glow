import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/meal_plan_model.dart';

class MealPlanState {
  final WeekMealPlan plan;
  final String weekKey;

  const MealPlanState({required this.plan, required this.weekKey});
}

class MealPlanNotifier extends Notifier<MealPlanState> {
  static const _prefix = 'meal_plan_';

  @override
  MealPlanState build() {
    final key = WeekMealPlan.weekKey(DateTime.now());
    _load(key);
    return MealPlanState(plan: WeekMealPlan.empty(), weekKey: key);
  }

  Future<void> _load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw != null) {
      state = MealPlanState(plan: WeekMealPlan.fromJson(raw), weekKey: key);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix${state.weekKey}', state.plan.toJson());
  }

  Future<void> setMeal(int dayIndex, MealType type, MealEntry entry) async {
    final updatedDay = state.plan.day(dayIndex).setByType(type, entry);
    final updatedPlan = state.plan.setDay(dayIndex, updatedDay);
    state = MealPlanState(plan: updatedPlan, weekKey: state.weekKey);
    await _save();
  }

  Future<void> clearMeal(int dayIndex, MealType type) async {
    await setMeal(dayIndex, type, MealEntry.empty);
  }
}

final mealPlanProvider = NotifierProvider<MealPlanNotifier, MealPlanState>(
  MealPlanNotifier.new,
);
