class FoodItem {
  final String name;
  final double kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final String category;

  const FoodItem({
    required this.name,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.category,
  });
}

const List<FoodItem> kFoodDatabase = [
  // Cereali e pasta
  FoodItem(name: 'Pasta di semola cotta',         kcalPer100g: 157, proteinPer100g: 5.8, carbsPer100g: 30.9, fatPer100g: 0.9, category: 'Cereali'),
  FoodItem(name: 'Pasta integrale cotta',          kcalPer100g: 149, proteinPer100g: 5.5, carbsPer100g: 29.2, fatPer100g: 0.8, category: 'Cereali'),
  FoodItem(name: 'Riso bianco cotto',              kcalPer100g: 130, proteinPer100g: 2.7, carbsPer100g: 28.2, fatPer100g: 0.3, category: 'Cereali'),
  FoodItem(name: 'Riso integrale cotto',           kcalPer100g: 123, proteinPer100g: 2.6, carbsPer100g: 25.6, fatPer100g: 0.9, category: 'Cereali'),
  FoodItem(name: 'Riso basmati cotto',             kcalPer100g: 121, proteinPer100g: 2.5, carbsPer100g: 25.2, fatPer100g: 0.4, category: 'Cereali'),
  FoodItem(name: 'Farro cotto',                   kcalPer100g: 150, proteinPer100g: 5.5, carbsPer100g: 29.0, fatPer100g: 1.0, category: 'Cereali'),
  FoodItem(name: 'Quinoa cotta',                  kcalPer100g: 120, proteinPer100g: 4.4, carbsPer100g: 21.3, fatPer100g: 1.9, category: 'Cereali'),
  FoodItem(name: 'Avena (fiocchi)',               kcalPer100g: 370, proteinPer100g: 13.0, carbsPer100g: 58.0, fatPer100g: 7.0, category: 'Cereali'),
  FoodItem(name: 'Pane integrale',                kcalPer100g: 224, proteinPer100g: 8.5, carbsPer100g: 41.0, fatPer100g: 3.2, category: 'Cereali'),
  FoodItem(name: 'Pane di segale',                kcalPer100g: 220, proteinPer100g: 8.0, carbsPer100g: 41.5, fatPer100g: 1.7, category: 'Cereali'),
  FoodItem(name: 'Fette biscottate integrali',    kcalPer100g: 358, proteinPer100g: 10.5, carbsPer100g: 68.0, fatPer100g: 4.5, category: 'Cereali'),
  FoodItem(name: 'Granola',                       kcalPer100g: 380, proteinPer100g: 8.0, carbsPer100g: 57.0, fatPer100g: 14.0, category: 'Cereali'),
  FoodItem(name: 'Crostini integrali',            kcalPer100g: 350, proteinPer100g: 9.0, carbsPer100g: 66.0, fatPer100g: 4.0, category: 'Cereali'),

  // Legumi
  FoodItem(name: 'Lenticchie cotte',              kcalPer100g: 116, proteinPer100g: 9.0, carbsPer100g: 20.1, fatPer100g: 0.4, category: 'Legumi'),
  FoodItem(name: 'Ceci cotti',                    kcalPer100g: 164, proteinPer100g: 8.9, carbsPer100g: 27.4, fatPer100g: 2.6, category: 'Legumi'),
  FoodItem(name: 'Fagioli borlotti cotti',        kcalPer100g: 111, proteinPer100g: 7.8, carbsPer100g: 19.5, fatPer100g: 0.5, category: 'Legumi'),
  FoodItem(name: 'Fagioli neri cotti',            kcalPer100g: 132, proteinPer100g: 8.9, carbsPer100g: 23.7, fatPer100g: 0.5, category: 'Legumi'),
  FoodItem(name: 'Edamame cotti',                 kcalPer100g: 121, proteinPer100g: 11.9, carbsPer100g: 8.9, fatPer100g: 5.2, category: 'Legumi'),
  FoodItem(name: 'Piselli cotti',                 kcalPer100g: 84,  proteinPer100g: 5.4, carbsPer100g: 14.4, fatPer100g: 0.4, category: 'Legumi'),

  // Proteine vegetali
  FoodItem(name: 'Tofu naturale',                 kcalPer100g: 76,  proteinPer100g: 8.1, carbsPer100g: 1.9, fatPer100g: 4.2, category: 'Proteine'),
  FoodItem(name: 'Tofu alla piastra',             kcalPer100g: 100, proteinPer100g: 9.5, carbsPer100g: 2.5, fatPer100g: 5.5, category: 'Proteine'),

  // Uova
  FoodItem(name: 'Uovo intero',                   kcalPer100g: 143, proteinPer100g: 12.6, carbsPer100g: 0.7, fatPer100g: 9.9, category: 'Uova'),
  FoodItem(name: 'Albume d\'uovo',                kcalPer100g: 52,  proteinPer100g: 10.9, carbsPer100g: 0.7, fatPer100g: 0.2, category: 'Uova'),

  // Soia
  FoodItem(name: 'Latte di soia',                 kcalPer100g: 33,  proteinPer100g: 3.3, carbsPer100g: 1.8, fatPer100g: 1.8, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia naturale',       kcalPer100g: 57,  proteinPer100g: 3.8, carbsPer100g: 5.4, fatPer100g: 1.9, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia con frutta',     kcalPer100g: 72,  proteinPer100g: 3.0, carbsPer100g: 9.5, fatPer100g: 1.7, category: 'Soia'),

  // Verdure
  FoodItem(name: 'Spinaci crudi',                 kcalPer100g: 23,  proteinPer100g: 2.9, carbsPer100g: 3.6, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Spinaci cotti',                 kcalPer100g: 31,  proteinPer100g: 3.5, carbsPer100g: 3.8, fatPer100g: 0.5, category: 'Verdure'),
  FoodItem(name: 'Broccoli cotti',                kcalPer100g: 35,  proteinPer100g: 2.4, carbsPer100g: 7.2, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Zucchine cotte',                kcalPer100g: 17,  proteinPer100g: 1.3, carbsPer100g: 3.5, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Carote crude',                  kcalPer100g: 35,  proteinPer100g: 0.9, carbsPer100g: 8.2, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Peperoni crudi',                kcalPer100g: 27,  proteinPer100g: 1.0, carbsPer100g: 6.3, fatPer100g: 0.3, category: 'Verdure'),
  FoodItem(name: 'Pomodori',                      kcalPer100g: 18,  proteinPer100g: 0.9, carbsPer100g: 3.9, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Insalata mista',                kcalPer100g: 15,  proteinPer100g: 1.3, carbsPer100g: 2.5, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Cetriolo',                      kcalPer100g: 12,  proteinPer100g: 0.7, carbsPer100g: 2.2, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Cipolla',                       kcalPer100g: 32,  proteinPer100g: 1.1, carbsPer100g: 7.6, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Aglio',                         kcalPer100g: 111, proteinPer100g: 4.5, carbsPer100g: 23.2, fatPer100g: 0.5, category: 'Verdure'),
  FoodItem(name: 'Patate lesse',                  kcalPer100g: 86,  proteinPer100g: 1.9, carbsPer100g: 20.1, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Patate dolci cotte',            kcalPer100g: 90,  proteinPer100g: 2.0, carbsPer100g: 20.7, fatPer100g: 0.1, category: 'Verdure'),

  // Frutta
  FoodItem(name: 'Mela',                          kcalPer100g: 52,  proteinPer100g: 0.3, carbsPer100g: 13.8, fatPer100g: 0.2, category: 'Frutta'),
  FoodItem(name: 'Banana',                        kcalPer100g: 89,  proteinPer100g: 1.1, carbsPer100g: 22.8, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Pera',                          kcalPer100g: 57,  proteinPer100g: 0.4, carbsPer100g: 15.2, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Kiwi',                          kcalPer100g: 61,  proteinPer100g: 1.1, carbsPer100g: 14.7, fatPer100g: 0.5, category: 'Frutta'),
  FoodItem(name: 'Arancia',                       kcalPer100g: 47,  proteinPer100g: 0.9, carbsPer100g: 11.8, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Frutti di bosco misti',         kcalPer100g: 45,  proteinPer100g: 0.7, carbsPer100g: 10.5, fatPer100g: 0.5, category: 'Frutta'),
  FoodItem(name: 'Avocado',                       kcalPer100g: 160, proteinPer100g: 2.0, carbsPer100g: 8.5, fatPer100g: 14.7, category: 'Frutta'),
  FoodItem(name: 'Fragole',                       kcalPer100g: 33,  proteinPer100g: 0.7, carbsPer100g: 7.7, fatPer100g: 0.3, category: 'Frutta'),

  // Condimenti e grassi
  FoodItem(name: 'Olio EVO',                      kcalPer100g: 884, proteinPer100g: 0.0, carbsPer100g: 0.0, fatPer100g: 100.0, category: 'Condimenti'),
  FoodItem(name: 'Burro di arachidi',             kcalPer100g: 588, proteinPer100g: 25.0, carbsPer100g: 20.0, fatPer100g: 50.0, category: 'Condimenti'),
  FoodItem(name: 'Burro di mandorle',             kcalPer100g: 614, proteinPer100g: 21.0, carbsPer100g: 20.0, fatPer100g: 55.0, category: 'Condimenti'),
  FoodItem(name: 'Pesto genovese',                kcalPer100g: 454, proteinPer100g: 6.0, carbsPer100g: 5.0, fatPer100g: 46.0, category: 'Condimenti'),
  FoodItem(name: 'Salsa di pomodoro',             kcalPer100g: 29,  proteinPer100g: 1.6, carbsPer100g: 5.8, fatPer100g: 0.2, category: 'Condimenti'),

  // Frutta secca
  FoodItem(name: 'Mandorle',                      kcalPer100g: 579, proteinPer100g: 21.0, carbsPer100g: 22.0, fatPer100g: 50.0, category: 'Frutta secca'),
  FoodItem(name: 'Noci',                          kcalPer100g: 654, proteinPer100g: 15.0, carbsPer100g: 14.0, fatPer100g: 65.0, category: 'Frutta secca'),

  // Formaggi
  FoodItem(name: 'Mozzarella fior di latte',      kcalPer100g: 253, proteinPer100g: 18.0, carbsPer100g: 2.7, fatPer100g: 19.5, category: 'Formaggi'),
  FoodItem(name: 'Parmigiano grattugiato',        kcalPer100g: 392, proteinPer100g: 33.0, carbsPer100g: 0.0, fatPer100g: 28.0, category: 'Formaggi'),
];

List<FoodItem> searchFood(String query) {
  if (query.isEmpty) return [];
  final q = query.toLowerCase();
  return kFoodDatabase.where((f) => f.name.toLowerCase().contains(q)).toList();
}

FoodItem? findFood(String name) {
  try {
    return kFoodDatabase.firstWhere((f) => f.name == name);
  } catch (_) {
    return null;
  }
}
