import '../domain/product.dart';

const kProducts = <String, Product>{
  // ─── Detergenti ───────────────────────────────────────────────
  'cerave_cleanser': Product(
    id: 'cerave_cleanser',
    fullName: 'CeraVe Detergente Crema-Schiuma Idratante',
    brand: 'CeraVe',
    shortName: 'CeraVe',
    category: ProductCategory.cleanser,
    description:
        'Detergente idratante a texture crema che si trasforma in schiuma delicata. Formulato con 3 ceramidi essenziali, acido ialuronico e tecnologia MVE a rilascio controllato. Non altera la barriera cutanea, ideale per pelli normali-secche.',
    howToUse:
        'Applica sul viso bagnato, massaggia con movimenti circolari delicati per circa 30 secondi, risciacqua abbondantemente con acqua tiepida.',
    keyIngredients: ['Ceramidi (1, 3, 6-II)', 'Acido ialuronico', 'Niacinamide', 'Tecnologia MVE'],
    emoji: '🫧',
    timing: ProductTiming.both,
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2018254?\$promoMedFace\$',
  ),

  'cerave_foaming': Product(
    id: 'cerave_foaming',
    fullName: 'CeraVe Detergente Schiumogeno',
    brand: 'CeraVe',
    shortName: 'CeraVe schiuma',
    category: ProductCategory.cleanser,
    description:
        'Detergente schiumogeno per una pulizia più profonda, ideale per pelli normali-grasse. Rimuove i residui di sebo e prodotti che il micellare non riesce a eliminare del tutto. Contiene ceramidi per non alterare la barriera cutanea.',
    howToUse:
        '2° step della doppia detersione serale: dopo aver rimosso trucco e SPF con olio/micellare, applica sul viso bagnato, crea schiuma con le dita e massaggia per 30 secondi. Risciacqua.',
    keyIngredients: ['Ceramidi (1, 3, 6-II)', 'Niacinamide', 'Acido ialuronico', 'PCA idrometile'],
    emoji: '🧹',
    timing: ProductTiming.evening,
    imageUrl: 'https://media.ulta.com/i/ulta/xlsImpprod5140065?\$promoMedFace\$',
  ),

  'micellare': Product(
    id: 'micellare',
    fullName: 'Acqua Micellare / Olio Struccante',
    brand: '',
    shortName: 'Micellare/Olio',
    category: ProductCategory.cleanser,
    description:
        '1° step della doppia detersione. Dissolve e rimuove trucco, SPF e impurità superficiali senza strofinare né irritare la pelle.',
    howToUse:
        'Applica su dischetti di cotone e tampona delicatamente su tutto il viso, occhi compresi, finché non rimane residuo di makeup sul dischetto. Non risciacquare prima del secondo step.',
    keyIngredients: ['Agenti micellari', 'Glicerina'],
    emoji: '🧴',
    timing: ProductTiming.evening,
  ),

  // ─── Sieri ────────────────────────────────────────────────────
  'vitamina_c': Product(
    id: 'vitamina_c',
    fullName: 'Florence Bio Cosmesi Siero Viso BIO Vitamina C',
    brand: 'Florence Bio Cosmesi',
    shortName: 'Vitamina C',
    category: ProductCategory.serum,
    description:
        'Siero viso biologico certificato AIAB con Vitamina C (Sodium Ascorbyl Phosphate) stabilizzata, Vitamina E, Acido Ialuronico multi-peso e Aloe Vera organica. Formula BIO antiossidante che illumina, uniforma il tono e stimola la produzione di collagene.',
    howToUse:
        '2-3 gocce su viso e collo, tampona delicatamente dal centro verso l\'esterno. Applica dopo il detergente, prima di qualsiasi crema. Solo routine mattutina.',
    keyIngredients: [
      'Sodium Ascorbyl Phosphate (Vitamina C stabilizzata)',
      'Tocopheryl Acetate (Vitamina E)',
      'Acido Ialuronico idrolizzato multi-peso',
      'Aloe Barbadensis Leaf Juice (organica)',
      'Acido Ferulico (antiossidante)',
      'Centella Asiatica Extract',
    ],
    emoji: '🌿',
    timing: ProductTiming.morning,
    warnings: 'Usa SPF obbligatoriamente dopo. Conservare al fresco e al riparo dalla luce. Formula BIO: agitare prima dell\'uso.',
  ),

  'acido_ialuronico': Product(
    id: 'acido_ialuronico',
    fullName: 'The Inkey List Hyaluronic Acid Serum',
    brand: 'The Inkey List',
    shortName: 'Inkey List HA',
    category: ProductCategory.serum,
    description:
        'Siero idratante con 2% di Acido Ialuronico puro in tre pesi molecolari (alto, medio, basso) per un\'idratazione profonda a ogni strato della pelle. Formula leggera e non appiccicosa, arricchita con Matrixyl 3000™ per ridurre visibilmente le rughe sottili.',
    howToUse:
        'Applica sul viso leggermente umido dopo la detersione, prima degli altri sieri e della crema. Una quantità grande quanto un pisello basta per viso e collo. Mattina e sera.',
    keyIngredients: [
      'Acido Ialuronico 2% (3 pesi molecolari)',
      'Matrixyl 3000™ (Palmitoyl Tripeptide-1 + Palmitoyl Tetrapeptide-7)',
      'Leuconostoc/Radish Root Ferment Filtrate (prebiotico)',
    ],
    emoji: '💧',
    timing: ProductTiming.both,
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2052111?\$promoMedFace\$',
  ),

  'revitalift': Product(
    id: 'revitalift',
    fullName: 'L\'Oréal Revitalift Filler 1,5% Puro Acido Ialuronico',
    brand: 'L\'Oréal Paris',
    shortName: 'Revitalift',
    category: ProductCategory.serum,
    description:
        'Siero anti-rughe altamente concentrato con 1,5% di puro acido ialuronico in 3 pesi molecolari diversi. Effetto rimpolpante e levigante visibile. Formula senza profumo aggiunto sul principio attivo.',
    howToUse:
        'Applica dopo i sieri acquosi (vitamina C), prima della crema idratante. Stendi su tutto il viso con movimenti ascendenti. Usare mattina e sera.',
    keyIngredients: [
      'Acido ialuronico macro (0,5%) — leviga le rughe in superficie',
      'Acido micro ialuronico (1%) — rimpolpa e migliora elasticità',
      'Peptide Dipeptide-1',
    ],
    emoji: '✨',
    timing: ProductTiming.both,
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2001763?\$promoMedFace\$',
  ),

  // ─── Idratanti ────────────────────────────────────────────────
  'lancome': Product(
    id: 'lancome',
    fullName: 'Lancôme Absolue Longevity The Soft Cream',
    brand: 'Lancôme',
    shortName: 'Lancôme Absolue',
    category: ProductCategory.moisturizer,
    description:
        'Crema anti-età di lusso con idratazione 24h. Formula con Absolue PDRN (frammenti di DNA di rosa brevettati), Pro-Xylane e Estratto di Rosa Perpetua coltivata nel Sud della Francia. Visibilmente più soda e levigata in una settimana.',
    howToUse:
        'Ultimo step prima dell\'SPF (mattina) o ultimo step serale. Applica un morbido strato su viso e collo con movimenti ascendenti e leggero massaggio lifting.',
    keyIngredients: [
      'Absolue PDRN (frammenti di DNA di Rosa)',
      'Pro-Xylane (elasticità e idratazione)',
      'Estratto di Rosa Perpetua Lancôme',
      'Glicerina',
    ],
    emoji: '💜',
    timing: ProductTiming.both,
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2054541?\$promoMedFace\$',
  ),

  // ─── SPF ──────────────────────────────────────────────────────
  'spf': Product(
    id: 'spf',
    fullName: 'd\'alba Piedmont Waterfull Essence Sunscreen SPF 50+ PA++++',
    brand: 'd\'alba Piedmont',
    shortName: 'd\'alba SPF',
    category: ProductCategory.spf,
    description:
        'Solare coreano-italiano con texture essence leggera (non lascia bianco residuo). SPF 50+ PA++++ con Trufferol™ (Tartufo Bianco + Vitamina E brevettato) antiossidante. Idrata, leviga e protegge dai raggi UVA/UVB in un unico step.',
    howToUse:
        'Ultimo step assoluto della routine mattutina, dopo la crema idratante. Applica una quantità generosa (regola: ¼ di cucchiaino per il viso) su viso, collo e décolleté. Riapplica ogni 2 ore in caso di esposizione al sole.',
    keyIngredients: [
      'Trufferol™ (Tartufo Bianco + Vitamina E) — antiossidante brevettato',
      'Niacinamide (Vitamina B3)',
      'Centella Asiatica Extract',
      'Portulaca Oleracea Extract',
      'Filtri UV chimici (SPF 50+ PA++++)',
    ],
    emoji: '☀️',
    timing: ProductTiming.morning,
    warnings:
        'Non saltare MAI, nemmeno in giorni nuvolosi, in inverno o al chiuso. Fondamentale se usi Retinal, acidi esfolianti o Vitamina C: senza SPF questi prodotti possono causare iperpigmentazione.',
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2056385?\$promoMedFace\$',
  ),

  // ─── Esfolianti ───────────────────────────────────────────────
  'bahia_blanca': Product(
    id: 'bahia_blanca',
    fullName: 'Guapa! Bahia Blanca — Maschera Scrub al Cacao',
    brand: 'Guapa!',
    shortName: 'Bahia Blanca',
    category: ProductCategory.exfoliant,
    description:
        'Esfoliante fisico (scrub/peeling) per rimuovere le cellule morte, levigare la texture cutanea e preparare la pelle ad assorbire meglio i prodotti successivi.',
    howToUse:
        'Applica sul viso asciutto o leggermente umido. Massaggia con movimenti circolari delicati per 1-2 minuti evitando il contorno occhi, poi risciacqua abbondantemente.',
    keyIngredients: [],
    emoji: '🌟',
    timing: ProductTiming.morning,
    warnings: 'Solo 1 volta a settimana (sabato). Non usare su pelle irritata, arrossata o con lesioni attive. Non combinare con acidi nella stessa routine.',
  ),

  'buenos_aires': Product(
    id: 'buenos_aires',
    fullName: 'Guapa! Buenos Aires — Esfoliante Acidi BHA/AHA',
    brand: 'Guapa!',
    shortName: 'Buenos Aires',
    category: ProductCategory.exfoliant,
    description:
        'Esfoliante chimico con acidi BHA/AHA in formula leave-on. Affina i pori, migliora la texture, uniforma il tono e previene comedoni e imperfezioni senza esfoliazione meccanica.',
    howToUse:
        'Applica su viso pulito e asciutto dopo la detersione. Tampona con le dita o con dischetto. Non risciacquare. Non usare nella stessa sera del Retinal.',
    keyIngredients: ['BHA (Acido Salicilico 2%)', 'AHA (Acido Glicolico o Lattico)'],
    emoji: '🧪',
    timing: ProductTiming.evening,
    warnings:
        'Non combinare con Retinal nella stessa sera — rischio di irritazione. Usa SPF 50+ obbligatoriamente il mattino seguente. Inizia 1 volta a settimana e aumenta gradualmente la frequenza.',
  ),

  // ─── Retinoidi ────────────────────────────────────────────────
  'retinal': Product(
    id: 'retinal',
    fullName: 'Avène RetrinAL 0.1% Crema Intensiva Multi-Correttrice',
    brand: 'Eau Thermale Avène',
    shortName: 'Retinal',
    category: ProductCategory.retinoid,
    description:
        'Crema notte con Retinaldeide 0.1% — il retinoide senza prescrizione più potente sul mercato, 3× più efficace del retinolo. Formulato con Acqua Termale Avène per massima tollerabilità anche su pelli sensibili. Riduce rughe, macchie e migliora la texture.',
    howToUse:
        'Uno strato sottile su tutto il viso pulito e completamente asciutto, evitando il contorno occhi e le ali del naso. Inizia 2-3 sere a settimana, poi aumenta gradualmente fino all\'uso quotidiano.',
    keyIngredients: [
      'Retinaldeide 0.1% (vitamina A)',
      'Acqua Termale Avène (lenitiva)',
      'Niacinamide (vitamina B3)',
      'Sodio Ialuronato',
      'Squalane',
      'Tocoferolo (vitamina E)',
    ],
    emoji: '🌙',
    timing: ProductTiming.evening,
    warnings:
        'Non usare nella stessa sera degli acidi esfolianti (Buenos Aires). Non usare in gravidanza o allattamento. SPF 50+ il mattino OBBLIGATORIO. Possibile skin purging iniziale (arrossamento, desquamazione) — è normale e temporaneo.',
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2049602?\$promoMedFace\$',
  ),

  // ─── Trattamenti ──────────────────────────────────────────────
  'bogota': Product(
    id: 'bogota',
    fullName: 'Guapa! Bogotà — Trattamento Domenicale',
    brand: 'Guapa!',
    shortName: 'Bogotà',
    category: ProductCategory.treatment,
    description:
        'Trattamento speciale riservato alla domenica sera per un\'azione intensiva una volta a settimana.',
    howToUse:
        'Applica il prodotto sul viso come da indicazioni del packaging. Lascia agire il tempo necessario, poi risciacqua se richiesto.',
    keyIngredients: [],
    emoji: '🌿',
    timing: ProductTiming.evening,
  ),
};
