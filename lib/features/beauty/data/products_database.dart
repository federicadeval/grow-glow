import '../domain/product.dart';

const kProducts = <String, Product>{
  // ─── Detergenti ───────────────────────────────────────────────
  'cerave_cleanser': Product(
    id: 'cerave_cleanser',
    fullName: 'CeraVe Hydrating Facial Cleanser',
    brand: 'CeraVe',
    shortName: 'CeraVe',
    category: ProductCategory.cleanser,
    description:
        'Detergente idratante con ceramidi e acido ialuronico. Rispetta la barriera cutanea e non lascia la pelle tesa.',
    howToUse:
        'Applica sul viso bagnato, massaggia con movimenti circolari delicati, risciacqua abbondantemente.',
    keyIngredients: ['Ceramidi (1, 3, 6-II)', 'Acido ialuronico', 'Niacinamide'],
    emoji: '🫧',
    timing: ProductTiming.both,
  ),

  'cerave_foaming': Product(
    id: 'cerave_foaming',
    fullName: 'CeraVe Foaming Facial Cleanser',
    brand: 'CeraVe',
    shortName: 'CeraVe schiuma',
    category: ProductCategory.cleanser,
    description:
        'Detergente schiumogeno per una pulizia più profonda. Ideale come secondo step della doppia detersione serale per rimuovere i residui dopo l\'olio/micellare.',
    howToUse:
        'Secondo step della doppia detersione: dopo aver rimosso trucco e SPF con olio o micellare, applica sul viso bagnato, crea schiuma e massaggia. Risciacqua.',
    keyIngredients: ['Ceramidi', 'Niacinamide', 'Acido ialuronico'],
    emoji: '🧹',
    timing: ProductTiming.evening,
  ),

  'micellare': Product(
    id: 'micellare',
    fullName: 'Acqua Micellare / Olio Struccante',
    brand: '',
    shortName: 'Micellare/Olio',
    category: ProductCategory.cleanser,
    description:
        'Primo step della doppia detersione. Rimuove trucco, SPF e impurità superficiali senza strofinare né irritare.',
    howToUse:
        'Applica su dischetti di cotone e tampona delicatamente su tutto il viso finché non rimane residuo di trucco sul dischetto.',
    keyIngredients: ['Agenti micellari', 'Glicerina'],
    emoji: '🧴',
    timing: ProductTiming.evening,
  ),

  // ─── Sieri ────────────────────────────────────────────────────
  'vitamina_c': Product(
    id: 'vitamina_c',
    fullName: 'Siero Vitamina C',
    brand: '',
    shortName: 'Vitamina C',
    category: ProductCategory.serum,
    description:
        'Siero antiossidante che illumina, uniforma il tono e protegge dai radicali liberi e dai danni da inquinamento e UV.',
    howToUse:
        '2-3 gocce su viso e collo, tampona delicatamente. Applica dopo il detergente e prima della crema, sempre al mattino.',
    keyIngredients: ['Vitamina C (L-ascorbico)', 'Vitamina E', 'Acido ferulico'],
    emoji: '🌿',
    timing: ProductTiming.morning,
    warnings: 'Può causare un lieve pizzicore iniziale. Non applicare su pelle irritata o rossa.',
  ),

  'acido_ialuronico': Product(
    id: 'acido_ialuronico',
    fullName: 'Siero Acido Ialuronico',
    brand: '',
    shortName: 'Acido ialuronico',
    category: ProductCategory.serum,
    description:
        'Siero idratante con acido ialuronico multi-peso. Riempie e trattiene l\'acqua negli strati della pelle per un effetto plumping immediato.',
    howToUse:
        'Applica sul viso leggermente umido (es. dopo aver spruzzato un po\' d\'acqua o toner) per massimizzare l\'assorbimento. Tampona delicatamente.',
    keyIngredients: ['Acido ialuronico alto peso molecolare', 'Acido ialuronico basso peso molecolare', 'Panthenolo'],
    emoji: '💧',
    timing: ProductTiming.both,
  ),

  'revitalift': Product(
    id: 'revitalift',
    fullName: "L'Oréal Paris Revitalift",
    brand: "L'Oréal Paris",
    shortName: 'Revitalift',
    category: ProductCategory.serum,
    description:
        "Siero/crema anti-age con pro-retinolo A e centella asiatica. Riduce visibilmente le rughe e migliora compattezza e luminosità.",
    howToUse:
        'Stendi su tutto il viso con movimenti ascendenti. Applica dopo i sieri acquosi e prima della crema idratante.',
    keyIngredients: ['Pro-Retinolo A', 'Centella Asiatica', 'Vitamina CG'],
    emoji: '✨',
    timing: ProductTiming.both,
  ),

  // ─── Idratanti ────────────────────────────────────────────────
  'lancome': Product(
    id: 'lancome',
    fullName: 'Lancôme Crema Idratante',
    brand: 'Lancôme',
    shortName: 'Lancôme',
    category: ProductCategory.moisturizer,
    description:
        'Crema idratante ricca che sigilla tutti i layer precedenti e nutre la pelle in profondità con un effetto setoso.',
    howToUse:
        'Ultimo step della routine (prima dell\'SPF al mattino). Morbido strato su viso e collo con movimenti ascendenti e delicato massaggio.',
    keyIngredients: ['Ceramidi', 'Acido ialuronico', 'Rosa Centifolia'],
    emoji: '💜',
    timing: ProductTiming.both,
  ),

  // ─── SPF ──────────────────────────────────────────────────────
  'spf': Product(
    id: 'spf',
    fullName: 'Protezione Solare SPF 50+',
    brand: '',
    shortName: 'SPF',
    category: ProductCategory.spf,
    description:
        'Protezione solare ad ampio spettro UVA/UVB. Indispensabile ogni mattina per prevenire fotoinvecchiamento, macchie e danni al DNA cellulare.',
    howToUse:
        'Ultimo step della routine mattutina, dopo la crema idratante. Applica generosamente su viso, collo e décolleté. Riapplica ogni 2 ore se esposta al sole.',
    keyIngredients: ['Filtri UV ad ampio spettro'],
    emoji: '☀️',
    timing: ProductTiming.morning,
    warnings: 'Non saltare MAI, nemmeno in giorni nuvolosi o al chiuso. Fondamentale se usi retinoidi o acidi.',
  ),

  // ─── Esfolianti ───────────────────────────────────────────────
  'bahia_blanca': Product(
    id: 'bahia_blanca',
    fullName: 'Bahia Blanca — Scrub/Peeling',
    brand: '',
    shortName: 'Bahia Blanca',
    category: ProductCategory.exfoliant,
    description:
        'Esfoliante fisico (scrub/peeling) per rimuovere le cellule morte, levigare la texture e preparare la pelle ad assorbire meglio i prodotti successivi.',
    howToUse:
        'Applica sul viso asciutto o leggermente umido. Massaggia con movimenti circolari delicati per 1-2 minuti, poi risciacqua abbondantemente.',
    keyIngredients: [],
    emoji: '🌟',
    timing: ProductTiming.morning,
    warnings: 'Solo 1 volta a settimana (sabato). Non usare su pelle irritata, arrossata o con lesioni attive.',
  ),

  'buenos_aires': Product(
    id: 'buenos_aires',
    fullName: 'Buenos Aires — Acido Esfoliante',
    brand: '',
    shortName: 'Buenos Aires',
    category: ProductCategory.exfoliant,
    description:
        'Esfoliante chimico con acidi BHA/AHA. Affina i pori, migliora la texture, uniforma il tono e previene i comedoni senza esfoliazione meccanica.',
    howToUse:
        'Applica su viso pulito e asciutto dopo la detersione. Tampona delicatamente. Non risciacquare. Non usare nella stessa sera del Retinal.',
    keyIngredients: ['BHA (Acido salicilico)', 'AHA (Acido glicolico o lattico)'],
    emoji: '🧪',
    timing: ProductTiming.evening,
    warnings: 'Non combinare con Retinal nella stessa sera. Usa SPF 50+ il mattino seguente. Inizia 1 volta a settimana e aumenta gradualmente.',
  ),

  // ─── Retinoidi ────────────────────────────────────────────────
  'retinal': Product(
    id: 'retinal',
    fullName: 'Retinaldeide (Retinal)',
    brand: '',
    shortName: 'Retinal',
    category: ProductCategory.retinoid,
    description:
        'Retinaldeide — forma di vitamina A più potente del retinolo ma più tollerabile dell\'acido retinoico. Stimola il collagene, accelera il turnover cellulare, riduce rughe fini e macchie.',
    howToUse:
        'Uno strato sottile su tutto il viso pulito e asciutto, evitando il contorno occhi e le narici. Inizia 2-3 sere a settimana, poi aumenta gradualmente la frequenza.',
    keyIngredients: ['Retinaldeide 0.05–0.1%', 'Emollienti lenitivi (es. squalane, ceramidi)'],
    emoji: '🌙',
    timing: ProductTiming.evening,
    warnings:
        'Non usare nella stessa sera degli acidi esfolianti. Non usare in gravidanza o allattamento. Usa SEMPRE SPF 50+ il mattino dopo. Può causare irritazione, rossore e desquamazione iniziale (skin purging) — è normale.',
  ),

  // ─── Trattamenti ──────────────────────────────────────────────
  'bogota': Product(
    id: 'bogota',
    fullName: 'Bogotà — Trattamento domenicale',
    brand: '',
    shortName: 'Bogotà',
    category: ProductCategory.treatment,
    description:
        'Trattamento speciale riservato alla domenica sera. Prodotto per un\'azione più intensa una volta a settimana.',
    howToUse:
        'Applica il prodotto sul viso come da indicazioni del packaging. Lascia agire il tempo necessario, poi risciacqua se richiesto.',
    keyIngredients: [],
    emoji: '🌿',
    timing: ProductTiming.evening,
  ),
};
