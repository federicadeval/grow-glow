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
  FoodItem(name: 'Pane bianco',                   kcalPer100g: 265, proteinPer100g: 9.0, carbsPer100g: 53.0, fatPer100g: 1.3, category: 'Cereali'),
  FoodItem(name: 'Pane di farro',                 kcalPer100g: 230, proteinPer100g: 9.0, carbsPer100g: 43.0, fatPer100g: 2.5, category: 'Cereali'),
  FoodItem(name: 'Fette biscottate integrali',    kcalPer100g: 358, proteinPer100g: 10.5, carbsPer100g: 68.0, fatPer100g: 4.5, category: 'Cereali'),
  FoodItem(name: 'Granola',                       kcalPer100g: 380, proteinPer100g: 8.0, carbsPer100g: 57.0, fatPer100g: 14.0, category: 'Cereali'),
  FoodItem(name: 'Crostini integrali',            kcalPer100g: 350, proteinPer100g: 9.0, carbsPer100g: 66.0, fatPer100g: 4.0, category: 'Cereali'),
  FoodItem(name: 'Couscous cotto',                kcalPer100g: 112, proteinPer100g: 3.8, carbsPer100g: 23.2, fatPer100g: 0.2, category: 'Cereali'),
  FoodItem(name: 'Polenta cotta',                 kcalPer100g: 80,  proteinPer100g: 1.8, carbsPer100g: 17.0, fatPer100g: 0.4, category: 'Cereali'),
  FoodItem(name: 'Cracker integrali',             kcalPer100g: 400, proteinPer100g: 10.0, carbsPer100g: 65.0, fatPer100g: 10.0, category: 'Cereali'),
  FoodItem(name: 'Cornflakes',                    kcalPer100g: 357, proteinPer100g: 7.0, carbsPer100g: 84.0, fatPer100g: 0.4, category: 'Cereali'),
  FoodItem(name: 'Orzo perlato cotto',            kcalPer100g: 123, proteinPer100g: 2.3, carbsPer100g: 28.2, fatPer100g: 0.4, category: 'Cereali'),
  FoodItem(name: 'Miglio cotto',                  kcalPer100g: 119, proteinPer100g: 3.5, carbsPer100g: 23.7, fatPer100g: 1.0, category: 'Cereali'),
  FoodItem(name: 'Pizza margherita',              kcalPer100g: 266, proteinPer100g: 11.0, carbsPer100g: 33.0, fatPer100g: 10.0, category: 'Cereali'),
  FoodItem(name: 'Pizza integrale',               kcalPer100g: 230, proteinPer100g: 10.0, carbsPer100g: 35.0, fatPer100g: 6.0, category: 'Cereali'),
  FoodItem(name: 'Impasto pizza crudo',           kcalPer100g: 242, proteinPer100g: 7.0, carbsPer100g: 49.0, fatPer100g: 2.5, category: 'Cereali'),
  FoodItem(name: 'Gnocchi di patate cotti',       kcalPer100g: 130, proteinPer100g: 3.0, carbsPer100g: 28.0, fatPer100g: 0.5, category: 'Cereali'),
  FoodItem(name: 'Lasagne cotte',                 kcalPer100g: 135, proteinPer100g: 5.5, carbsPer100g: 18.0, fatPer100g: 4.5, category: 'Cereali'),

  // Legumi
  FoodItem(name: 'Lenticchie cotte',              kcalPer100g: 116, proteinPer100g: 9.0, carbsPer100g: 20.1, fatPer100g: 0.4, category: 'Legumi'),
  FoodItem(name: 'Ceci cotti',                    kcalPer100g: 164, proteinPer100g: 8.9, carbsPer100g: 27.4, fatPer100g: 2.6, category: 'Legumi'),
  FoodItem(name: 'Fagioli borlotti cotti',        kcalPer100g: 111, proteinPer100g: 7.8, carbsPer100g: 19.5, fatPer100g: 0.5, category: 'Legumi'),
  FoodItem(name: 'Fagioli neri cotti',            kcalPer100g: 132, proteinPer100g: 8.9, carbsPer100g: 23.7, fatPer100g: 0.5, category: 'Legumi'),
  FoodItem(name: 'Fagioli bianchi cotti',         kcalPer100g: 139, proteinPer100g: 9.7, carbsPer100g: 25.1, fatPer100g: 0.5, category: 'Legumi'),
  FoodItem(name: 'Edamame cotti',                 kcalPer100g: 121, proteinPer100g: 11.9, carbsPer100g: 8.9, fatPer100g: 5.2, category: 'Legumi'),
  FoodItem(name: 'Piselli cotti',                 kcalPer100g: 84,  proteinPer100g: 5.4, carbsPer100g: 14.4, fatPer100g: 0.4, category: 'Legumi'),
  FoodItem(name: 'Fave cotte',                    kcalPer100g: 110, proteinPer100g: 7.9, carbsPer100g: 19.7, fatPer100g: 0.4, category: 'Legumi'),
  FoodItem(name: 'Hummus',                        kcalPer100g: 177, proteinPer100g: 8.0, carbsPer100g: 14.0, fatPer100g: 9.6, category: 'Legumi'),

  // Carne
  FoodItem(name: 'Petto di pollo cotto',          kcalPer100g: 165, proteinPer100g: 31.0, carbsPer100g: 0.0, fatPer100g: 3.6, category: 'Carne'),
  FoodItem(name: 'Coscia di pollo cotta',         kcalPer100g: 209, proteinPer100g: 25.9, carbsPer100g: 0.0, fatPer100g: 10.9, category: 'Carne'),
  FoodItem(name: 'Pollo intero cotto',            kcalPer100g: 215, proteinPer100g: 29.0, carbsPer100g: 0.0, fatPer100g: 10.9, category: 'Carne'),
  FoodItem(name: 'Tacchino petto cotto',          kcalPer100g: 135, proteinPer100g: 29.0, carbsPer100g: 0.0, fatPer100g: 1.0, category: 'Carne'),
  FoodItem(name: 'Manzo macinato cotto',          kcalPer100g: 254, proteinPer100g: 26.0, carbsPer100g: 0.0, fatPer100g: 17.0, category: 'Carne'),
  FoodItem(name: 'Bistecca di manzo cotta',       kcalPer100g: 217, proteinPer100g: 26.0, carbsPer100g: 0.0, fatPer100g: 12.0, category: 'Carne'),
  FoodItem(name: 'Filetto di manzo cotto',        kcalPer100g: 207, proteinPer100g: 28.0, carbsPer100g: 0.0, fatPer100g: 10.0, category: 'Carne'),
  FoodItem(name: 'Vitello scaloppine cotte',      kcalPer100g: 175, proteinPer100g: 28.0, carbsPer100g: 0.0, fatPer100g: 6.5, category: 'Carne'),
  FoodItem(name: 'Maiale lombo cotto',            kcalPer100g: 242, proteinPer100g: 27.0, carbsPer100g: 0.0, fatPer100g: 14.0, category: 'Carne'),
  FoodItem(name: 'Prosciutto cotto',              kcalPer100g: 145, proteinPer100g: 19.0, carbsPer100g: 1.5, fatPer100g: 7.0, category: 'Carne'),
  FoodItem(name: 'Prosciutto crudo',              kcalPer100g: 268, proteinPer100g: 25.0, carbsPer100g: 0.0, fatPer100g: 18.0, category: 'Carne'),
  FoodItem(name: 'Bresaola',                      kcalPer100g: 151, proteinPer100g: 32.0, carbsPer100g: 0.0, fatPer100g: 2.0, category: 'Carne'),
  FoodItem(name: 'Mortadella',                    kcalPer100g: 311, proteinPer100g: 15.0, carbsPer100g: 1.5, fatPer100g: 27.0, category: 'Carne'),
  FoodItem(name: 'Salame',                        kcalPer100g: 380, proteinPer100g: 22.0, carbsPer100g: 1.0, fatPer100g: 32.0, category: 'Carne'),
  FoodItem(name: 'Speck',                         kcalPer100g: 290, proteinPer100g: 26.0, carbsPer100g: 0.5, fatPer100g: 20.0, category: 'Carne'),
  FoodItem(name: 'Agnello coscia cotta',          kcalPer100g: 258, proteinPer100g: 28.0, carbsPer100g: 0.0, fatPer100g: 16.0, category: 'Carne'),
  FoodItem(name: 'Coniglio cotto',                kcalPer100g: 185, proteinPer100g: 29.0, carbsPer100g: 0.0, fatPer100g: 7.0, category: 'Carne'),
  FoodItem(name: 'Wurstel di pollo',              kcalPer100g: 200, proteinPer100g: 12.0, carbsPer100g: 4.0, fatPer100g: 16.0, category: 'Carne'),

  // Pesce e frutti di mare
  FoodItem(name: 'Salmone cotto',                 kcalPer100g: 208, proteinPer100g: 25.0, carbsPer100g: 0.0, fatPer100g: 12.0, category: 'Pesce'),
  FoodItem(name: 'Salmone affumicato',            kcalPer100g: 142, proteinPer100g: 18.3, carbsPer100g: 0.0, fatPer100g: 4.3, category: 'Pesce'),
  FoodItem(name: 'Tonno al naturale',             kcalPer100g: 116, proteinPer100g: 26.0, carbsPer100g: 0.0, fatPer100g: 1.0, category: 'Pesce'),
  FoodItem(name: 'Tonno sott\'olio sgocciolato',  kcalPer100g: 198, proteinPer100g: 24.0, carbsPer100g: 0.0, fatPer100g: 11.0, category: 'Pesce'),
  FoodItem(name: 'Merluzzo cotto',                kcalPer100g: 105, proteinPer100g: 23.0, carbsPer100g: 0.0, fatPer100g: 0.9, category: 'Pesce'),
  FoodItem(name: 'Orata cotta',                   kcalPer100g: 155, proteinPer100g: 22.0, carbsPer100g: 0.0, fatPer100g: 7.0, category: 'Pesce'),
  FoodItem(name: 'Branzino cotto',                kcalPer100g: 124, proteinPer100g: 22.0, carbsPer100g: 0.0, fatPer100g: 4.0, category: 'Pesce'),
  FoodItem(name: 'Trota cotta',                   kcalPer100g: 168, proteinPer100g: 24.0, carbsPer100g: 0.0, fatPer100g: 7.5, category: 'Pesce'),
  FoodItem(name: 'Sgombro cotto',                 kcalPer100g: 262, proteinPer100g: 19.0, carbsPer100g: 0.0, fatPer100g: 20.0, category: 'Pesce'),
  FoodItem(name: 'Sardine sott\'olio',            kcalPer100g: 208, proteinPer100g: 24.6, carbsPer100g: 0.0, fatPer100g: 11.5, category: 'Pesce'),
  FoodItem(name: 'Gamberetti cotti',              kcalPer100g: 99,  proteinPer100g: 21.0, carbsPer100g: 0.0, fatPer100g: 1.1, category: 'Pesce'),
  FoodItem(name: 'Cozze cotte',                   kcalPer100g: 86,  proteinPer100g: 12.0, carbsPer100g: 3.7, fatPer100g: 2.0, category: 'Pesce'),
  FoodItem(name: 'Vongole cotte',                 kcalPer100g: 74,  proteinPer100g: 11.6, carbsPer100g: 2.6, fatPer100g: 1.0, category: 'Pesce'),
  FoodItem(name: 'Calamari cotti',                kcalPer100g: 92,  proteinPer100g: 15.6, carbsPer100g: 3.1, fatPer100g: 1.4, category: 'Pesce'),
  FoodItem(name: 'Polpo cotto',                   kcalPer100g: 82,  proteinPer100g: 14.9, carbsPer100g: 2.2, fatPer100g: 1.0, category: 'Pesce'),
  FoodItem(name: 'Acciughe sott\'olio',           kcalPer100g: 210, proteinPer100g: 29.0, carbsPer100g: 0.0, fatPer100g: 10.0, category: 'Pesce'),
  FoodItem(name: 'Baccalà cotto',                 kcalPer100g: 105, proteinPer100g: 23.0, carbsPer100g: 0.0, fatPer100g: 0.9, category: 'Pesce'),

  // Proteine vegetali
  FoodItem(name: 'Tofu naturale',                 kcalPer100g: 76,  proteinPer100g: 8.1, carbsPer100g: 1.9, fatPer100g: 4.2, category: 'Proteine'),
  FoodItem(name: 'Tofu alla piastra',             kcalPer100g: 100, proteinPer100g: 9.5, carbsPer100g: 2.5, fatPer100g: 5.5, category: 'Proteine'),
  FoodItem(name: 'Tempeh',                        kcalPer100g: 193, proteinPer100g: 20.0, carbsPer100g: 9.4, fatPer100g: 10.8, category: 'Proteine'),
  FoodItem(name: 'Seitan',                        kcalPer100g: 125, proteinPer100g: 25.0, carbsPer100g: 4.0, fatPer100g: 1.9, category: 'Proteine'),
  FoodItem(name: 'Proteine del siero (whey)',     kcalPer100g: 370, proteinPer100g: 80.0, carbsPer100g: 5.0, fatPer100g: 5.0, category: 'Proteine'),

  // Uova
  FoodItem(name: 'Uovo intero',                   kcalPer100g: 143, proteinPer100g: 12.6, carbsPer100g: 0.7, fatPer100g: 9.9, category: 'Uova'),
  FoodItem(name: 'Albume d\'uovo',                kcalPer100g: 52,  proteinPer100g: 10.9, carbsPer100g: 0.7, fatPer100g: 0.2, category: 'Uova'),
  FoodItem(name: 'Uovo sodo',                     kcalPer100g: 155, proteinPer100g: 13.0, carbsPer100g: 1.1, fatPer100g: 10.6, category: 'Uova'),
  FoodItem(name: 'Frittata',                      kcalPer100g: 175, proteinPer100g: 12.0, carbsPer100g: 1.0, fatPer100g: 13.5, category: 'Uova'),

  // Latticini
  FoodItem(name: 'Latte intero',                  kcalPer100g: 61,  proteinPer100g: 3.2, carbsPer100g: 4.7, fatPer100g: 3.3, category: 'Latticini'),
  FoodItem(name: 'Latte parzialmente scremato',   kcalPer100g: 46,  proteinPer100g: 3.4, carbsPer100g: 4.9, fatPer100g: 1.5, category: 'Latticini'),
  FoodItem(name: 'Latte scremato',                kcalPer100g: 34,  proteinPer100g: 3.5, carbsPer100g: 5.0, fatPer100g: 0.1, category: 'Latticini'),
  FoodItem(name: 'Yogurt greco 0%',               kcalPer100g: 57,  proteinPer100g: 10.0, carbsPer100g: 3.6, fatPer100g: 0.4, category: 'Latticini'),
  FoodItem(name: 'Yogurt greco intero',           kcalPer100g: 97,  proteinPer100g: 9.0, carbsPer100g: 3.6, fatPer100g: 5.0, category: 'Latticini'),
  FoodItem(name: 'Yogurt naturale intero',        kcalPer100g: 61,  proteinPer100g: 3.5, carbsPer100g: 4.7, fatPer100g: 3.3, category: 'Latticini'),
  FoodItem(name: 'Yogurt naturale magro',         kcalPer100g: 40,  proteinPer100g: 4.0, carbsPer100g: 5.0, fatPer100g: 0.4, category: 'Latticini'),
  FoodItem(name: 'Ricotta vaccina',               kcalPer100g: 146, proteinPer100g: 11.0, carbsPer100g: 3.0, fatPer100g: 10.0, category: 'Latticini'),
  FoodItem(name: 'Ricotta di pecora',             kcalPer100g: 157, proteinPer100g: 9.5, carbsPer100g: 3.0, fatPer100g: 12.0, category: 'Latticini'),
  FoodItem(name: 'Fiocchi di latte (cottage)',    kcalPer100g: 98,  proteinPer100g: 11.1, carbsPer100g: 3.4, fatPer100g: 4.3, category: 'Latticini'),
  FoodItem(name: 'Latte di mandorla',             kcalPer100g: 24,  proteinPer100g: 0.5, carbsPer100g: 3.0, fatPer100g: 1.1, category: 'Latticini'),
  FoodItem(name: 'Latte di avena',                kcalPer100g: 45,  proteinPer100g: 1.0, carbsPer100g: 6.5, fatPer100g: 1.5, category: 'Latticini'),
  FoodItem(name: 'Latte di riso',                 kcalPer100g: 47,  proteinPer100g: 0.3, carbsPer100g: 9.2, fatPer100g: 1.0, category: 'Latticini'),

  // Soia
  FoodItem(name: 'Latte di soia',                 kcalPer100g: 33,  proteinPer100g: 3.3, carbsPer100g: 1.8, fatPer100g: 1.8, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia naturale',       kcalPer100g: 57,  proteinPer100g: 3.8, carbsPer100g: 5.4, fatPer100g: 1.9, category: 'Soia'),
  FoodItem(name: 'Yogurt di soia con frutta',     kcalPer100g: 72,  proteinPer100g: 3.0, carbsPer100g: 9.5, fatPer100g: 1.7, category: 'Soia'),

  // Verdure
  FoodItem(name: 'Spinaci crudi',                 kcalPer100g: 23,  proteinPer100g: 2.9, carbsPer100g: 3.6, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Spinaci cotti',                 kcalPer100g: 31,  proteinPer100g: 3.5, carbsPer100g: 3.8, fatPer100g: 0.5, category: 'Verdure'),
  FoodItem(name: 'Broccoli cotti',                kcalPer100g: 35,  proteinPer100g: 2.4, carbsPer100g: 7.2, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Zucchine cotte',                kcalPer100g: 17,  proteinPer100g: 1.3, carbsPer100g: 3.5, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Zucchine crude',                kcalPer100g: 17,  proteinPer100g: 1.2, carbsPer100g: 3.1, fatPer100g: 0.3, category: 'Verdure'),
  FoodItem(name: 'Carote crude',                  kcalPer100g: 35,  proteinPer100g: 0.9, carbsPer100g: 8.2, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Carote cotte',                  kcalPer100g: 31,  proteinPer100g: 0.8, carbsPer100g: 7.3, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Peperoni crudi',                kcalPer100g: 27,  proteinPer100g: 1.0, carbsPer100g: 6.3, fatPer100g: 0.3, category: 'Verdure'),
  FoodItem(name: 'Peperoni cotti',                kcalPer100g: 30,  proteinPer100g: 1.0, carbsPer100g: 7.0, fatPer100g: 0.3, category: 'Verdure'),
  FoodItem(name: 'Pomodori',                      kcalPer100g: 18,  proteinPer100g: 0.9, carbsPer100g: 3.9, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Pomodorini ciliegia',           kcalPer100g: 18,  proteinPer100g: 0.9, carbsPer100g: 3.9, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Insalata mista',                kcalPer100g: 15,  proteinPer100g: 1.3, carbsPer100g: 2.5, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Lattuga',                       kcalPer100g: 14,  proteinPer100g: 1.4, carbsPer100g: 2.2, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Rucola',                        kcalPer100g: 25,  proteinPer100g: 2.6, carbsPer100g: 3.7, fatPer100g: 0.7, category: 'Verdure'),
  FoodItem(name: 'Cetriolo',                      kcalPer100g: 12,  proteinPer100g: 0.7, carbsPer100g: 2.2, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Cipolla',                       kcalPer100g: 32,  proteinPer100g: 1.1, carbsPer100g: 7.6, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Cipolla rossa',                 kcalPer100g: 40,  proteinPer100g: 1.1, carbsPer100g: 9.3, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Aglio',                         kcalPer100g: 111, proteinPer100g: 4.5, carbsPer100g: 23.2, fatPer100g: 0.5, category: 'Verdure'),
  FoodItem(name: 'Patate lesse',                  kcalPer100g: 86,  proteinPer100g: 1.9, carbsPer100g: 20.1, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Patate dolci cotte',            kcalPer100g: 90,  proteinPer100g: 2.0, carbsPer100g: 20.7, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Melanzane cotte',               kcalPer100g: 25,  proteinPer100g: 1.0, carbsPer100g: 5.0, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Funghi cotti',                  kcalPer100g: 26,  proteinPer100g: 2.5, carbsPer100g: 4.0, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Funghi crudi',                  kcalPer100g: 22,  proteinPer100g: 3.1, carbsPer100g: 3.3, fatPer100g: 0.3, category: 'Verdure'),
  FoodItem(name: 'Cavolo cappuccio crudo',        kcalPer100g: 25,  proteinPer100g: 1.3, carbsPer100g: 5.8, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Cavoletti di Bruxelles cotti',  kcalPer100g: 36,  proteinPer100g: 2.5, carbsPer100g: 7.1, fatPer100g: 0.5, category: 'Verdure'),
  FoodItem(name: 'Cavolfiore cotto',              kcalPer100g: 23,  proteinPer100g: 1.9, carbsPer100g: 4.5, fatPer100g: 0.1, category: 'Verdure'),
  FoodItem(name: 'Asparagi cotti',                kcalPer100g: 20,  proteinPer100g: 2.2, carbsPer100g: 3.9, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Carciofi cotti',                kcalPer100g: 35,  proteinPer100g: 2.4, carbsPer100g: 7.4, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Finocchi crudi',                kcalPer100g: 23,  proteinPer100g: 1.2, carbsPer100g: 5.0, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Sedano',                        kcalPer100g: 14,  proteinPer100g: 0.7, carbsPer100g: 2.9, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Rapa rossa cotta',              kcalPer100g: 43,  proteinPer100g: 1.6, carbsPer100g: 9.6, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Mais cotto',                    kcalPer100g: 86,  proteinPer100g: 3.2, carbsPer100g: 19.0, fatPer100g: 1.2, category: 'Verdure'),
  FoodItem(name: 'Piselli surgelati cotti',       kcalPer100g: 77,  proteinPer100g: 5.0, carbsPer100g: 13.0, fatPer100g: 0.4, category: 'Verdure'),
  FoodItem(name: 'Porri cotti',                   kcalPer100g: 31,  proteinPer100g: 1.5, carbsPer100g: 7.0, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Indivia riccia',                kcalPer100g: 17,  proteinPer100g: 1.3, carbsPer100g: 3.4, fatPer100g: 0.2, category: 'Verdure'),
  FoodItem(name: 'Radicchio',                     kcalPer100g: 23,  proteinPer100g: 1.4, carbsPer100g: 4.5, fatPer100g: 0.3, category: 'Verdure'),

  // Frutta
  FoodItem(name: 'Mela',                          kcalPer100g: 52,  proteinPer100g: 0.3, carbsPer100g: 13.8, fatPer100g: 0.2, category: 'Frutta'),
  FoodItem(name: 'Banana',                        kcalPer100g: 89,  proteinPer100g: 1.1, carbsPer100g: 22.8, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Pera',                          kcalPer100g: 57,  proteinPer100g: 0.4, carbsPer100g: 15.2, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Kiwi',                          kcalPer100g: 61,  proteinPer100g: 1.1, carbsPer100g: 14.7, fatPer100g: 0.5, category: 'Frutta'),
  FoodItem(name: 'Arancia',                       kcalPer100g: 47,  proteinPer100g: 0.9, carbsPer100g: 11.8, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Mandarino',                     kcalPer100g: 53,  proteinPer100g: 0.8, carbsPer100g: 13.3, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Limone',                        kcalPer100g: 29,  proteinPer100g: 1.1, carbsPer100g: 9.3, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Pompelmo',                      kcalPer100g: 42,  proteinPer100g: 0.8, carbsPer100g: 10.7, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Frutti di bosco misti',         kcalPer100g: 45,  proteinPer100g: 0.7, carbsPer100g: 10.5, fatPer100g: 0.5, category: 'Frutta'),
  FoodItem(name: 'Avocado',                       kcalPer100g: 160, proteinPer100g: 2.0, carbsPer100g: 8.5, fatPer100g: 14.7, category: 'Frutta'),
  FoodItem(name: 'Fragole',                       kcalPer100g: 33,  proteinPer100g: 0.7, carbsPer100g: 7.7, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Uva',                           kcalPer100g: 67,  proteinPer100g: 0.6, carbsPer100g: 17.2, fatPer100g: 0.4, category: 'Frutta'),
  FoodItem(name: 'Pesche',                        kcalPer100g: 39,  proteinPer100g: 0.9, carbsPer100g: 9.5, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Albicocche',                    kcalPer100g: 48,  proteinPer100g: 1.4, carbsPer100g: 11.1, fatPer100g: 0.4, category: 'Frutta'),
  FoodItem(name: 'Ciliegie',                      kcalPer100g: 63,  proteinPer100g: 1.1, carbsPer100g: 16.0, fatPer100g: 0.2, category: 'Frutta'),
  FoodItem(name: 'Ananas',                        kcalPer100g: 50,  proteinPer100g: 0.5, carbsPer100g: 13.1, fatPer100g: 0.1, category: 'Frutta'),
  FoodItem(name: 'Mango',                         kcalPer100g: 60,  proteinPer100g: 0.8, carbsPer100g: 15.0, fatPer100g: 0.4, category: 'Frutta'),
  FoodItem(name: 'Papaya',                        kcalPer100g: 43,  proteinPer100g: 0.5, carbsPer100g: 10.8, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Melone',                        kcalPer100g: 34,  proteinPer100g: 0.8, carbsPer100g: 8.2, fatPer100g: 0.2, category: 'Frutta'),
  FoodItem(name: 'Anguria',                       kcalPer100g: 30,  proteinPer100g: 0.6, carbsPer100g: 7.6, fatPer100g: 0.2, category: 'Frutta'),
  FoodItem(name: 'Mirtilli',                      kcalPer100g: 57,  proteinPer100g: 0.7, carbsPer100g: 14.5, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Lamponi',                       kcalPer100g: 52,  proteinPer100g: 1.2, carbsPer100g: 11.9, fatPer100g: 0.7, category: 'Frutta'),
  FoodItem(name: 'Prugne',                        kcalPer100g: 46,  proteinPer100g: 0.7, carbsPer100g: 11.4, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Fichi freschi',                 kcalPer100g: 74,  proteinPer100g: 0.7, carbsPer100g: 19.2, fatPer100g: 0.3, category: 'Frutta'),
  FoodItem(name: 'Melagrana',                     kcalPer100g: 83,  proteinPer100g: 1.7, carbsPer100g: 18.7, fatPer100g: 1.2, category: 'Frutta'),

  // Condimenti e grassi
  FoodItem(name: 'Olio EVO',                      kcalPer100g: 884, proteinPer100g: 0.0, carbsPer100g: 0.0, fatPer100g: 100.0, category: 'Condimenti'),
  FoodItem(name: 'Olio di cocco',                 kcalPer100g: 862, proteinPer100g: 0.0, carbsPer100g: 0.0, fatPer100g: 100.0, category: 'Condimenti'),
  FoodItem(name: 'Burro',                         kcalPer100g: 717, proteinPer100g: 0.9, carbsPer100g: 0.1, fatPer100g: 81.0, category: 'Condimenti'),
  FoodItem(name: 'Burro di arachidi',             kcalPer100g: 588, proteinPer100g: 25.0, carbsPer100g: 20.0, fatPer100g: 50.0, category: 'Condimenti'),
  FoodItem(name: 'Burro di mandorle',             kcalPer100g: 614, proteinPer100g: 21.0, carbsPer100g: 20.0, fatPer100g: 55.0, category: 'Condimenti'),
  FoodItem(name: 'Pesto genovese',                kcalPer100g: 454, proteinPer100g: 6.0, carbsPer100g: 5.0, fatPer100g: 46.0, category: 'Condimenti'),
  FoodItem(name: 'Salsa di pomodoro',             kcalPer100g: 29,  proteinPer100g: 1.6, carbsPer100g: 5.8, fatPer100g: 0.2, category: 'Condimenti'),
  FoodItem(name: 'Concentrato di pomodoro',       kcalPer100g: 82,  proteinPer100g: 4.0, carbsPer100g: 18.0, fatPer100g: 0.5, category: 'Condimenti'),
  FoodItem(name: 'Salsa di soia',                 kcalPer100g: 60,  proteinPer100g: 5.6, carbsPer100g: 5.6, fatPer100g: 0.0, category: 'Condimenti'),
  FoodItem(name: 'Aceto balsamico',               kcalPer100g: 88,  proteinPer100g: 0.5, carbsPer100g: 17.0, fatPer100g: 0.0, category: 'Condimenti'),
  FoodItem(name: 'Aceto di mele',                 kcalPer100g: 22,  proteinPer100g: 0.0, carbsPer100g: 0.9, fatPer100g: 0.0, category: 'Condimenti'),
  FoodItem(name: 'Senape',                        kcalPer100g: 67,  proteinPer100g: 3.7, carbsPer100g: 5.8, fatPer100g: 4.0, category: 'Condimenti'),
  FoodItem(name: 'Miele',                         kcalPer100g: 304, proteinPer100g: 0.3, carbsPer100g: 82.4, fatPer100g: 0.0, category: 'Condimenti'),
  FoodItem(name: 'Sciroppo d\'acero',             kcalPer100g: 260, proteinPer100g: 0.0, carbsPer100g: 67.0, fatPer100g: 0.3, category: 'Condimenti'),
  FoodItem(name: 'Tahini (crema di sesamo)',      kcalPer100g: 595, proteinPer100g: 17.0, carbsPer100g: 26.0, fatPer100g: 53.0, category: 'Condimenti'),
  FoodItem(name: 'Maionese',                      kcalPer100g: 680, proteinPer100g: 1.4, carbsPer100g: 1.0, fatPer100g: 75.0, category: 'Condimenti'),
  FoodItem(name: 'Ketchup',                       kcalPer100g: 100, proteinPer100g: 1.7, carbsPer100g: 25.0, fatPer100g: 0.1, category: 'Condimenti'),
  FoodItem(name: 'Yogurt come condimento',        kcalPer100g: 59,  proteinPer100g: 3.5, carbsPer100g: 4.7, fatPer100g: 2.4, category: 'Condimenti'),

  // Frutta secca e semi
  FoodItem(name: 'Mandorle',                      kcalPer100g: 579, proteinPer100g: 21.0, carbsPer100g: 22.0, fatPer100g: 50.0, category: 'Frutta secca'),
  FoodItem(name: 'Noci',                          kcalPer100g: 654, proteinPer100g: 15.0, carbsPer100g: 14.0, fatPer100g: 65.0, category: 'Frutta secca'),
  FoodItem(name: 'Nocciole',                      kcalPer100g: 628, proteinPer100g: 15.0, carbsPer100g: 17.0, fatPer100g: 61.0, category: 'Frutta secca'),
  FoodItem(name: 'Anacardi',                      kcalPer100g: 553, proteinPer100g: 18.0, carbsPer100g: 30.0, fatPer100g: 44.0, category: 'Frutta secca'),
  FoodItem(name: 'Pistacchi',                     kcalPer100g: 560, proteinPer100g: 20.0, carbsPer100g: 28.0, fatPer100g: 45.0, category: 'Frutta secca'),
  FoodItem(name: 'Arachidi',                      kcalPer100g: 567, proteinPer100g: 26.0, carbsPer100g: 16.0, fatPer100g: 49.0, category: 'Frutta secca'),
  FoodItem(name: 'Semi di chia',                  kcalPer100g: 486, proteinPer100g: 17.0, carbsPer100g: 42.0, fatPer100g: 31.0, category: 'Frutta secca'),
  FoodItem(name: 'Semi di lino',                  kcalPer100g: 534, proteinPer100g: 18.0, carbsPer100g: 29.0, fatPer100g: 42.0, category: 'Frutta secca'),
  FoodItem(name: 'Semi di girasole',              kcalPer100g: 584, proteinPer100g: 21.0, carbsPer100g: 20.0, fatPer100g: 51.0, category: 'Frutta secca'),
  FoodItem(name: 'Semi di zucca',                 kcalPer100g: 559, proteinPer100g: 30.0, carbsPer100g: 11.0, fatPer100g: 49.0, category: 'Frutta secca'),
  FoodItem(name: 'Semi di sesamo',                kcalPer100g: 573, proteinPer100g: 18.0, carbsPer100g: 23.0, fatPer100g: 50.0, category: 'Frutta secca'),
  FoodItem(name: 'Noci di macadamia',             kcalPer100g: 718, proteinPer100g: 8.0, carbsPer100g: 14.0, fatPer100g: 76.0, category: 'Frutta secca'),
  FoodItem(name: 'Pinoli',                        kcalPer100g: 673, proteinPer100g: 14.0, carbsPer100g: 13.0, fatPer100g: 68.0, category: 'Frutta secca'),
  FoodItem(name: 'Noci pecan',                    kcalPer100g: 691, proteinPer100g: 9.0, carbsPer100g: 14.0, fatPer100g: 72.0, category: 'Frutta secca'),

  // Formaggi
  FoodItem(name: 'Mozzarella fior di latte',      kcalPer100g: 253, proteinPer100g: 18.0, carbsPer100g: 2.7, fatPer100g: 19.5, category: 'Formaggi'),
  FoodItem(name: 'Parmigiano grattugiato',        kcalPer100g: 392, proteinPer100g: 33.0, carbsPer100g: 0.0, fatPer100g: 28.0, category: 'Formaggi'),
  FoodItem(name: 'Grana Padano',                  kcalPer100g: 384, proteinPer100g: 32.0, carbsPer100g: 0.0, fatPer100g: 28.0, category: 'Formaggi'),
  FoodItem(name: 'Pecorino romano',               kcalPer100g: 357, proteinPer100g: 25.0, carbsPer100g: 0.5, fatPer100g: 28.0, category: 'Formaggi'),
  FoodItem(name: 'Gorgonzola',                    kcalPer100g: 357, proteinPer100g: 19.0, carbsPer100g: 0.0, fatPer100g: 31.0, category: 'Formaggi'),
  FoodItem(name: 'Brie',                          kcalPer100g: 334, proteinPer100g: 20.0, carbsPer100g: 0.5, fatPer100g: 28.0, category: 'Formaggi'),
  FoodItem(name: 'Scamorza',                      kcalPer100g: 334, proteinPer100g: 25.0, carbsPer100g: 0.5, fatPer100g: 25.0, category: 'Formaggi'),
  FoodItem(name: 'Fontina',                       kcalPer100g: 343, proteinPer100g: 25.0, carbsPer100g: 1.6, fatPer100g: 26.0, category: 'Formaggi'),
  FoodItem(name: 'Emmental',                      kcalPer100g: 380, proteinPer100g: 28.0, carbsPer100g: 0.0, fatPer100g: 30.0, category: 'Formaggi'),
  FoodItem(name: 'Asiago',                        kcalPer100g: 343, proteinPer100g: 25.0, carbsPer100g: 0.5, fatPer100g: 27.0, category: 'Formaggi'),
  FoodItem(name: 'Stracchino',                    kcalPer100g: 300, proteinPer100g: 17.0, carbsPer100g: 0.5, fatPer100g: 25.0, category: 'Formaggi'),
  FoodItem(name: 'Crescenza',                     kcalPer100g: 260, proteinPer100g: 14.0, carbsPer100g: 0.8, fatPer100g: 22.0, category: 'Formaggi'),
  FoodItem(name: 'Mascarpone',                    kcalPer100g: 429, proteinPer100g: 7.0, carbsPer100g: 4.0, fatPer100g: 44.0, category: 'Formaggi'),
  FoodItem(name: 'Philadelphia (formaggio spalmabile)', kcalPer100g: 253, proteinPer100g: 6.0, carbsPer100g: 4.0, fatPer100g: 23.0, category: 'Formaggi'),

  // Dolci e snack
  FoodItem(name: 'Cioccolato fondente 70%',       kcalPer100g: 546, proteinPer100g: 5.0, carbsPer100g: 60.0, fatPer100g: 32.0, category: 'Dolci'),
  FoodItem(name: 'Cioccolato al latte',           kcalPer100g: 535, proteinPer100g: 7.0, carbsPer100g: 60.0, fatPer100g: 30.0, category: 'Dolci'),
  FoodItem(name: 'Marmellata',                    kcalPer100g: 250, proteinPer100g: 0.5, carbsPer100g: 65.0, fatPer100g: 0.1, category: 'Dolci'),
  FoodItem(name: 'Nutella',                       kcalPer100g: 539, proteinPer100g: 6.0, carbsPer100g: 57.5, fatPer100g: 30.9, category: 'Dolci'),
  FoodItem(name: 'Biscotti secchi',               kcalPer100g: 422, proteinPer100g: 7.5, carbsPer100g: 75.0, fatPer100g: 10.0, category: 'Dolci'),
  FoodItem(name: 'Torta di mele',                 kcalPer100g: 265, proteinPer100g: 3.5, carbsPer100g: 42.0, fatPer100g: 9.0, category: 'Dolci'),
  FoodItem(name: 'Gelato alla crema',             kcalPer100g: 207, proteinPer100g: 3.7, carbsPer100g: 24.0, fatPer100g: 11.0, category: 'Dolci'),
  FoodItem(name: 'Sorbetto alla frutta',          kcalPer100g: 100, proteinPer100g: 0.5, carbsPer100g: 25.0, fatPer100g: 0.0, category: 'Dolci'),

  // Bevande
  FoodItem(name: 'Acqua',                         kcalPer100g: 0,   proteinPer100g: 0.0, carbsPer100g: 0.0, fatPer100g: 0.0, category: 'Bevande'),
  FoodItem(name: 'Caffè espresso',                kcalPer100g: 2,   proteinPer100g: 0.1, carbsPer100g: 0.0, fatPer100g: 0.0, category: 'Bevande'),
  FoodItem(name: 'Tè verde',                      kcalPer100g: 1,   proteinPer100g: 0.0, carbsPer100g: 0.2, fatPer100g: 0.0, category: 'Bevande'),
  FoodItem(name: 'Tè nero',                       kcalPer100g: 1,   proteinPer100g: 0.0, carbsPer100g: 0.2, fatPer100g: 0.0, category: 'Bevande'),
  FoodItem(name: 'Succo d\'arancia',              kcalPer100g: 45,  proteinPer100g: 0.7, carbsPer100g: 10.4, fatPer100g: 0.2, category: 'Bevande'),
  FoodItem(name: 'Succo di mela',                 kcalPer100g: 46,  proteinPer100g: 0.1, carbsPer100g: 11.4, fatPer100g: 0.1, category: 'Bevande'),
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
