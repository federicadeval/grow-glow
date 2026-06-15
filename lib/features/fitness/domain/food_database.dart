class FoodItem {
  final String name;
  final double kcalPer100g;
  final String category;

  const FoodItem({required this.name, required this.kcalPer100g, required this.category});
}

const List<FoodItem> kFoodDatabase = [
  // Cereali e pasta
  FoodItem(name: 'Pasta di semola cotta', kcalPer100g: 157, category: 'Cereali'),
  FoodItem(name: 'Pasta integrale cotta', kcalPer100g: 149, category: 'Cereali'),
  FoodItem(name: 'Riso bianco cotto', kcalPer100g: 130, category: 'Cereali'),
  FoodItem(name: 'Riso integrale cotto', kcalPer100g: 123, category: 'Cereali'),
  FoodItem(name: 'Riso basmati cotto', kcalPer100g: 121, category: 'Cereali'),
  FoodItem(name: 'Farro cotto', kcalPer100g: 150, category: 'Cereali'),
  FoodItem(name: 'Quinoa cotta', kcalPer100g: 120, category: 'Cereali'),
  FoodItem(name: 'Avena (fiocchi)', kcalPer100g: 370, category: 'Cereali'),
  FoodItem(name: 'Pane integrale', kcalPer100g: 224, category: 'Cereali'),
  FoodItem(name: 'Pane di segale', kcalPer100g: 220, category: 'Cereali'),
  FoodItem(name: 'Fette biscottate integrali', kcalPer100g: 358, category: 'Cereali'),
  FoodItem(name: 'Granola', kcalPer100g: 380, category: 'Cereali'),
  FoodItem(name: 'Crostini integrali', kcalPer100g: 350, category: 'Cereali'),

  // Legumi
  FoodItem(name: 'Lenticchie cotte', kcalPer100g: 116, category: 'Legumi'),
  FoodItem(name: 'Ceci cotti', kcalPer100g: 164, category: 'Legumi'),
  FoodItem(name: 'Fagioli borlotti cotti', kcalPer100g: 111, category: 'Legumi'),
  FoodItem(name: 'Fagioli neri cotti', kcalPer100g: 132, category: 'Legumi'),
  FoodItem(name: 'Edamame cotti', kcalPer100g: 121, category: 'Legumi'),
  FoodItem(name: 'Piselli cotti', kcalPer100g: 84, category: 'Legumi'),

  // Proteine vegetali
  FoodItem(name: 'Tofu naturale', kcalPer100g: 76, category: 'Proteine'),
  FoodItem(name: 'Tofu alla piastra', kcalPer100g: 100, category: 'Proteine'),

  // Uova e latticini soia
  FoodItem(name: 'Uovo intero', kcalPer100g: 143, category: 'Uova'),
  FoodItem(name: 'Albume d\'uovo', kcalPer100g: 52, category: 'Uova'),
  FoodItem(name: 'Latte di soia', kcalPer100g: 33, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia naturale', kcalPer100g: 57, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia con frutta', kcalPer100g: 72, category: 'Soia'),

  // Verdure
  FoodItem(name: 'Spinaci crudi', kcalPer100g: 23, category: 'Verdure'),
  FoodItem(name: 'Spinaci cotti', kcalPer100g: 31, category: 'Verdure'),
  FoodItem(name: 'Broccoli cotti', kcalPer100g: 35, category: 'Verdure'),
  FoodItem(name: 'Zucchine cotte', kcalPer100g: 17, category: 'Verdure'),
  FoodItem(name: 'Carote crude', kcalPer100g: 35, category: 'Verdure'),
  FoodItem(name: 'Carote cotte', kcalPer100g: 35, category: 'Verdure'),
  FoodItem(name: 'Peperoni crudi', kcalPer100g: 27, category: 'Verdure'),
  FoodItem(name: 'Pomodori', kcalPer100g: 18, category: 'Verdure'),
  FoodItem(name: 'Insalata mista', kcalPer100g: 15, category: 'Verdure'),
  FoodItem(name: 'Cetriolo', kcalPer100g: 12, category: 'Verdure'),
  FoodItem(name: 'Cipolla', kcalPer100g: 32, category: 'Verdure'),
  FoodItem(name: 'Aglio', kcalPer100g: 111, category: 'Verdure'),
  FoodItem(name: 'Patate lesse', kcalPer100g: 86, category: 'Verdure'),
  FoodItem(name: 'Patate dolci cotte', kcalPer100g: 90, category: 'Verdure'),

  // Frutta
  FoodItem(name: 'Mela', kcalPer100g: 52, category: 'Frutta'),
  FoodItem(name: 'Banana', kcalPer100g: 89, category: 'Frutta'),
  FoodItem(name: 'Pera', kcalPer100g: 57, category: 'Frutta'),
  FoodItem(name: 'Kiwi', kcalPer100g: 61, category: 'Frutta'),
  FoodItem(name: 'Arancia', kcalPer100g: 47, category: 'Frutta'),
  FoodItem(name: 'Frutti di bosco misti', kcalPer100g: 45, category: 'Frutta'),
  FoodItem(name: 'Avocado', kcalPer100g: 160, category: 'Frutta'),
  FoodItem(name: 'Uva', kcalPer100g: 67, category: 'Frutta'),
  FoodItem(name: 'Fragole', kcalPer100g: 33, category: 'Frutta'),

  // Condimenti e grassi
  FoodItem(name: 'Olio EVO', kcalPer100g: 884, category: 'Condimenti'),
  FoodItem(name: 'Burro di arachidi', kcalPer100g: 588, category: 'Condimenti'),
  FoodItem(name: 'Burro di mandorle', kcalPer100g: 614, category: 'Condimenti'),
  FoodItem(name: 'Pesto genovese', kcalPer100g: 454, category: 'Condimenti'),
  FoodItem(name: 'Salsa di pomodoro', kcalPer100g: 29, category: 'Condimenti'),

  // Frutta secca
  FoodItem(name: 'Mandorle', kcalPer100g: 579, category: 'Frutta secca'),
  FoodItem(name: 'Noci', kcalPer100g: 654, category: 'Frutta secca'),

  // Altro
  FoodItem(name: 'Mozzarella fior di latte', kcalPer100g: 253, category: 'Formaggi'),
  FoodItem(name: 'Parmigiano grattugiato', kcalPer100g: 392, category: 'Formaggi'),
];

List<FoodItem> searchFood(String query) {
  if (query.isEmpty) return [];
  final q = query.toLowerCase();
  return kFoodDatabase.where((f) => f.name.toLowerCase().contains(q)).toList();
}
