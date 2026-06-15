import 'models/meal_plan_model.dart';

/// Generates a fixed weekly vegetarian meal plan (eggs ok, tofu ok, no tempeh).
/// Snacks: fruit or soy yogurt only.
WeekMealPlan generateWeeklyPlan() {
  final days = <int, DayMeals>{};

  // Colazione pool (rotazione L·M·V / M·G / S·D)
  const colazioneA = MealEntry(name: 'Latte di soia + fiocchi d\'avena + banana', kcal: 370);
  const colazioneB = MealEntry(name: 'Yogurt di soia + granola + frutti di bosco', kcal: 330);
  const colazioneC = MealEntry(name: 'Fette biscottate integrali + burro di mandorle + latte di soia', kcal: 380);

  // Spuntini
  const spuntinoYogurt = MealEntry(name: 'Yogurt di soia', kcal: 120);
  const spuntinoFrutta = MealEntry(name: 'Frutta fresca (mela / pera / kiwi)', kcal: 90);

  // 0 = Lunedì … 6 = Domenica
  days[0] = const DayMeals(
    colazione: colazioneA,
    spuntino: spuntinoFrutta,
    pranzo: MealEntry(name: 'Pasta integrale al pomodoro + insalata verde', kcal: 550),
    cena: MealEntry(name: 'Tofu alla piastra + verdure grigliate + pane integrale', kcal: 480),
  );

  days[1] = const DayMeals(
    colazione: colazioneB,
    spuntino: spuntinoYogurt,
    pranzo: MealEntry(name: 'Riso integrale + lenticchie + carote saltate', kcal: 520),
    cena: MealEntry(name: 'Frittata di verdure + insalata + pane integrale', kcal: 420),
  );

  days[2] = const DayMeals(
    colazione: colazioneA,
    spuntino: spuntinoFrutta,
    pranzo: MealEntry(name: 'Farro con zucchine, ceci e olio EVO', kcal: 490),
    cena: MealEntry(name: 'Tofu in padella con peperoni + riso basmati', kcal: 490),
  );

  days[3] = const DayMeals(
    colazione: colazioneB,
    spuntino: spuntinoYogurt,
    pranzo: MealEntry(name: 'Pasta con broccoli e aglio', kcal: 510),
    cena: MealEntry(name: 'Zuppa di ceci + crostini integrali', kcal: 440),
  );

  days[4] = const DayMeals(
    colazione: colazioneA,
    spuntino: spuntinoFrutta,
    pranzo: MealEntry(name: 'Bowl: riso basmati + edamame + avocado + cetriolo', kcal: 560),
    cena: MealEntry(name: 'Uova strapazzate con spinaci + patate al forno', kcal: 480),
  );

  days[5] = const DayMeals(
    colazione: colazioneC,
    spuntino: spuntinoYogurt,
    pranzo: MealEntry(name: 'Pizza integrale fatta in casa', kcal: 620),
    cena: MealEntry(name: 'Frittata di zucchine + pane di segale', kcal: 460),
  );

  days[6] = const DayMeals(
    colazione: colazioneC,
    spuntino: spuntinoFrutta,
    pranzo: MealEntry(name: 'Risotto alle verdure di stagione', kcal: 540),
    cena: MealEntry(name: 'Pasta al pesto leggero + insalatina', kcal: 490),
  );

  return WeekMealPlan(days: days);
}
