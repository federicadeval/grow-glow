import '../domain/supplement.dart';

const kSupplements = <Supplement>[
  // ── FITNESS ──────────────────────────────────────────────────
  Supplement(
    id: 'creatina',
    name: 'Creatina monoidrato',
    dosage: '5g al giorno',
    category: SupplementCategory.fitness,
    timing: [SupplementTiming.postWorkout],
    benefit: 'Aumenta forza, potenza e massa muscolare. Uno degli integratori più studiati in assoluto.',
    note: 'Il timing conta poco — può essere presa in qualsiasi momento della giornata.',
  ),
  Supplement(
    id: 'proteine',
    name: 'Proteine (Whey / Plant)',
    dosage: '25–30g per porzione',
    category: SupplementCategory.fitness,
    timing: [SupplementTiming.postWorkout],
    benefit: 'Supporta la sintesi proteica e il recupero muscolare quando l\'apporto da dieta è insufficiente.',
    note: 'Utili solo se non riesci a raggiungere il fabbisogno proteico giornaliero con i pasti.',
  ),

  // ── SALUTE ───────────────────────────────────────────────────
  Supplement(
    id: 'vitamina_d3',
    name: 'Vitamina D3',
    dosage: '1.000–2.000 UI al giorno',
    category: SupplementCategory.salute,
    timing: [SupplementTiming.mattina],
    benefit: 'Ossa, immunità, umore ed energia. Carenza molto diffusa, specie nei mesi invernali.',
    note: 'Assumere con un pasto contenente grassi per migliorare l\'assorbimento.',
  ),
  Supplement(
    id: 'omega3',
    name: 'Omega-3 (EPA/DHA) da alghe',
    dosage: '250–500mg EPA+DHA al giorno',
    category: SupplementCategory.salute,
    timing: [SupplementTiming.pasto],
    benefit: 'Anti-infiammatorio, salute cardiovascolare e cerebrale. Fonte vegetale diretta di EPA/DHA.',
    note: 'Consigliato da alghe per chi non mangia pesce — identico al fish oil.',
  ),
  Supplement(
    id: 'magnesio',
    name: 'Magnesio',
    dosage: '200–400mg al giorno',
    category: SupplementCategory.salute,
    timing: [SupplementTiming.sera],
    benefit: 'Migliora la qualità del sonno, riduce crampi e stress. Carenza comune nella dieta occidentale.',
    note: 'Preferire glicinato o malato per una miglior tollerabilità gastrica.',
  ),
  Supplement(
    id: 'b12',
    name: 'Vitamina B12',
    dosage: '500–1.000mcg a settimana',
    category: SupplementCategory.salute,
    timing: [SupplementTiming.mattina],
    benefit: 'Essenziale per sistema nervoso e produzione di globuli rossi. Carente nelle diete plant-based.',
    note: 'Anche i vegetariani possono sviluppare carenza nel tempo — vale la pena monitorarla.',
  ),
  Supplement(
    id: 'ferro',
    name: 'Ferro',
    dosage: 'Secondo prescrizione medica',
    category: SupplementCategory.salute,
    timing: [SupplementTiming.mattina],
    benefit: 'Previene anemia e stanchezza cronica. Particolarmente importante per le donne.',
    note: 'Da assumere solo con emocromo che confirmi la carenza. Lontano da calcio e caffè.',
  ),

  // ── BEAUTY ───────────────────────────────────────────────────
  Supplement(
    id: 'vitamina_c',
    name: 'Vitamina C',
    dosage: '500–1.000mg al giorno',
    category: SupplementCategory.beauty,
    timing: [SupplementTiming.mattina],
    benefit: 'Antiossidante, stimola la sintesi del collagene e protegge la pelle dai radicali liberi.',
    note: 'Assumere con il pasto per ridurre fastidi gastrici a dosi elevate.',
  ),
  Supplement(
    id: 'collagene',
    name: 'Collagene idrolizzato',
    dosage: '5–10g al giorno',
    category: SupplementCategory.beauty,
    timing: [SupplementTiming.mattina],
    benefit: 'Migliora elasticità e idratazione della pelle. Diversi RCT mostrano risultati positivi.',
    note: 'Assumere insieme alla vitamina C per ottimizzare la sintesi del collagene.',
  ),
];
