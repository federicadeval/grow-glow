import 'models/meal_plan_model.dart';
import 'food_database.dart';

Ingredient _ing(String name, double grams) {
  final food = findFood(name);
  return Ingredient(
    name: name,
    grams: grams,
    kcalPer100g: food?.kcalPer100g ?? 0,
    proteinPer100g: food?.proteinPer100g ?? 0,
    carbsPer100g: food?.carbsPer100g ?? 0,
    fatPer100g: food?.fatPer100g ?? 0,
  );
}

WeekMealPlan generateWeeklyPlan() {
  return WeekMealPlan(days: {
    // ── Lunedì ───────────────────────────────────────────────
    0: DayMeals(
      colazione: MealEntry(
        name: 'Avena con latte di soia e banana',
        kcal: 0,
        ingredients: [
          _ing('Avena (fiocchi)', 60),
          _ing('Latte di soia', 200),
          _ing('Banana', 100),
        ],
      ),
      spuntino: MealEntry(
        name: 'Mela',
        kcal: 0,
        ingredients: [_ing('Mela', 160)],
      ),
      pranzo: MealEntry(
        name: 'Pasta integrale al pomodoro con insalata',
        kcal: 0,
        ingredients: [
          _ing('Pasta integrale cotta', 280),
          _ing('Salsa di pomodoro', 100),
          _ing('Olio EVO', 10),
          _ing('Parmigiano grattugiato', 10),
          _ing('Insalata mista', 80),
        ],
      ),
      cena: MealEntry(
        name: 'Tofu alla piastra con verdure grigliate e pane',
        kcal: 0,
        ingredients: [
          _ing('Tofu alla piastra', 180),
          _ing('Zucchine cotte', 150),
          _ing('Peperoni crudi', 100),
          _ing('Olio EVO', 10),
          _ing('Pane integrale', 60),
        ],
      ),
    ),

    // ── Martedì ──────────────────────────────────────────────
    1: DayMeals(
      colazione: MealEntry(
        name: 'Yogurt di soia con granola e frutti di bosco',
        kcal: 0,
        ingredients: [
          _ing('Yogurt di soia naturale', 200),
          _ing('Granola', 40),
          _ing('Frutti di bosco misti', 80),
        ],
      ),
      spuntino: MealEntry(
        name: 'Yogurt di soia',
        kcal: 0,
        ingredients: [_ing('Yogurt di soia naturale', 150)],
      ),
      pranzo: MealEntry(
        name: 'Riso integrale con lenticchie e carote',
        kcal: 0,
        ingredients: [
          _ing('Riso integrale cotto', 220),
          _ing('Lenticchie cotte', 150),
          _ing('Carote crude', 100),
          _ing('Olio EVO', 10),
        ],
      ),
      cena: MealEntry(
        name: 'Frittata di verdure con pane integrale',
        kcal: 0,
        ingredients: [
          _ing('Uovo intero', 150),   // ~3 uova
          _ing('Zucchine cotte', 120),
          _ing('Spinaci cotti', 80),
          _ing('Olio EVO', 8),
          _ing('Pane integrale', 60),
          _ing('Insalata mista', 60),
        ],
      ),
    ),

    // ── Mercoledì ────────────────────────────────────────────
    2: DayMeals(
      colazione: MealEntry(
        name: 'Avena con latte di soia e frutti di bosco',
        kcal: 0,
        ingredients: [
          _ing('Avena (fiocchi)', 60),
          _ing('Latte di soia', 200),
          _ing('Frutti di bosco misti', 80),
        ],
      ),
      spuntino: MealEntry(
        name: 'Pera',
        kcal: 0,
        ingredients: [_ing('Pera', 160)],
      ),
      pranzo: MealEntry(
        name: 'Farro con zucchine, ceci e olio EVO',
        kcal: 0,
        ingredients: [
          _ing('Farro cotto', 200),
          _ing('Ceci cotti', 120),
          _ing('Zucchine cotte', 150),
          _ing('Olio EVO', 12),
        ],
      ),
      cena: MealEntry(
        name: 'Tofu in padella con peperoni e riso basmati',
        kcal: 0,
        ingredients: [
          _ing('Tofu naturale', 200),
          _ing('Peperoni crudi', 150),
          _ing('Cipolla', 50),
          _ing('Riso basmati cotto', 180),
          _ing('Olio EVO', 10),
        ],
      ),
    ),

    // ── Giovedì ──────────────────────────────────────────────
    3: DayMeals(
      colazione: MealEntry(
        name: 'Yogurt di soia con granola e banana',
        kcal: 0,
        ingredients: [
          _ing('Yogurt di soia naturale', 200),
          _ing('Granola', 40),
          _ing('Banana', 80),
        ],
      ),
      spuntino: MealEntry(
        name: 'Yogurt di soia',
        kcal: 0,
        ingredients: [_ing('Yogurt di soia naturale', 150)],
      ),
      pranzo: MealEntry(
        name: 'Pasta con broccoli e aglio',
        kcal: 0,
        ingredients: [
          _ing('Pasta di semola cotta', 270),
          _ing('Broccoli cotti', 200),
          _ing('Aglio', 10),
          _ing('Olio EVO', 15),
          _ing('Parmigiano grattugiato', 10),
        ],
      ),
      cena: MealEntry(
        name: 'Zuppa di ceci con crostini integrali',
        kcal: 0,
        ingredients: [
          _ing('Ceci cotti', 200),
          _ing('Pomodori', 150),
          _ing('Carote crude', 80),
          _ing('Spinaci crudi', 60),
          _ing('Olio EVO', 10),
          _ing('Crostini integrali', 40),
        ],
      ),
    ),

    // ── Venerdì ──────────────────────────────────────────────
    4: DayMeals(
      colazione: MealEntry(
        name: 'Fette biscottate con burro di mandorle e latte di soia',
        kcal: 0,
        ingredients: [
          _ing('Fette biscottate integrali', 40),
          _ing('Burro di mandorle', 20),
          _ing('Latte di soia', 200),
        ],
      ),
      spuntino: MealEntry(
        name: 'Kiwi e fragole',
        kcal: 0,
        ingredients: [
          _ing('Kiwi', 100),
          _ing('Fragole', 100),
        ],
      ),
      pranzo: MealEntry(
        name: 'Bowl riso basmati, edamame e avocado',
        kcal: 0,
        ingredients: [
          _ing('Riso basmati cotto', 200),
          _ing('Edamame cotti', 100),
          _ing('Avocado', 80),
          _ing('Cetriolo', 100),
          _ing('Olio EVO', 8),
        ],
      ),
      cena: MealEntry(
        name: 'Uova strapazzate con spinaci e patate al forno',
        kcal: 0,
        ingredients: [
          _ing('Uovo intero', 150),   // ~3 uova
          _ing('Spinaci cotti', 150),
          _ing('Patate lesse', 200),
          _ing('Olio EVO', 10),
        ],
      ),
    ),

    // ── Sabato ───────────────────────────────────────────────
    5: DayMeals(
      colazione: MealEntry(
        name: 'Fette biscottate con burro di arachidi e latte di soia',
        kcal: 0,
        ingredients: [
          _ing('Fette biscottate integrali', 40),
          _ing('Burro di arachidi', 20),
          _ing('Latte di soia', 200),
        ],
      ),
      spuntino: MealEntry(
        name: 'Yogurt di soia con frutti di bosco',
        kcal: 0,
        ingredients: [
          _ing('Yogurt di soia naturale', 150),
          _ing('Frutti di bosco misti', 60),
        ],
      ),
      pranzo: MealEntry(
        name: 'Pizza integrale con verdure',
        kcal: 0,
        notes: 'Fatta in casa con impasto integrale',
        ingredients: [
          _ing('Pane integrale', 200),       // base equivalente
          _ing('Salsa di pomodoro', 80),
          _ing('Mozzarella fior di latte', 80),
          _ing('Zucchine cotte', 80),
          _ing('Peperoni crudi', 60),
          _ing('Olio EVO', 10),
        ],
      ),
      cena: MealEntry(
        name: 'Frittata di zucchine con pane di segale',
        kcal: 0,
        ingredients: [
          _ing('Uovo intero', 150),
          _ing('Zucchine cotte', 150),
          _ing('Olio EVO', 8),
          _ing('Pane di segale', 60),
          _ing('Insalata mista', 80),
        ],
      ),
    ),

    // ── Domenica ─────────────────────────────────────────────
    6: DayMeals(
      colazione: MealEntry(
        name: 'Avena con latte di soia e banana',
        kcal: 0,
        ingredients: [
          _ing('Avena (fiocchi)', 70),
          _ing('Latte di soia', 250),
          _ing('Banana', 100),
        ],
      ),
      spuntino: MealEntry(
        name: 'Arancia',
        kcal: 0,
        ingredients: [_ing('Arancia', 180)],
      ),
      pranzo: MealEntry(
        name: 'Risotto alle verdure',
        kcal: 0,
        ingredients: [
          _ing('Riso bianco cotto', 280),
          _ing('Zucchine cotte', 100),
          _ing('Carote crude', 80),
          _ing('Piselli cotti', 80),
          _ing('Olio EVO', 10),
          _ing('Parmigiano grattugiato', 15),
        ],
      ),
      cena: MealEntry(
        name: 'Pasta al pesto con insalata',
        kcal: 0,
        ingredients: [
          _ing('Pasta di semola cotta', 250),
          _ing('Pesto genovese', 30),
          _ing('Parmigiano grattugiato', 10),
          _ing('Insalata mista', 100),
          _ing('Pomodori', 80),
        ],
      ),
    ),
  });
}
