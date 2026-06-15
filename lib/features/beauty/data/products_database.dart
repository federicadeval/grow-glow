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
    fullName: 'L\'Oréal Revitalift Clinical Siero 12% Pura Vitamina C',
    brand: 'L\'Oréal Paris',
    shortName: 'Vitamina C',
    category: ProductCategory.serum,
    description:
        'Siero antiossidante con 12% di Vitamina C pura (acido L-ascorbico) + Vitamina E + Acido Salicilico. Formula la più concentrata di L\'Oréal, visibilmente più luminosa in 8 settimane, pori ridotti, discromie attenuate.',
    howToUse:
        '2-3 gocce su viso e collo, tampona delicatamente dal centro verso l\'esterno. Applica dopo il detergente, prima di qualsiasi crema. Solo routine mattutina.',
    keyIngredients: ['Acido L-Ascorbico 12%', 'Vitamina E (Tocoferolo)', 'Acido Salicilico', 'Sodio Ialuronato'],
    emoji: '🌿',
    timing: ProductTiming.morning,
    warnings: 'Può causare un lieve pizzicore iniziale — normale. Conservare in luogo fresco e al riparo dalla luce. Non applicare su pelle irritata. Usa SPF obbligatoriamente dopo.',
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2034716?\$promoMedFace\$',
  ),

  'acido_ialuronico': Product(
    id: 'acido_ialuronico',
    fullName: 'Siero Acido Ialuronico',
    brand: '',
    shortName: 'Acido ialuronico',
    category: ProductCategory.serum,
    description:
        'Siero idratante con acido ialuronico multi-peso che agisce sia in superficie sia in profondità nell\'epidermide per un\'idratazione immediata e duratura.',
    howToUse:
        'Applica sul viso leggermente umido (spruzza un po\' d\'acqua o usa dopo il toner) per massimizzare l\'assorbimento. Tampona delicatamente su viso e collo.',
    keyIngredients: [
      'Acido ialuronico alto peso molecolare (idratazione superficiale)',
      'Acido ialuronico basso peso molecolare (rimpolpamento in profondità)',
      'Panthenolo (Pro-vitamina B5)',
    ],
    emoji: '💧',
    timing: ProductTiming.both,
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
    fullName: 'Lancôme Hydra Zen Crema Giorno Anti-Stress',
    brand: 'Lancôme',
    shortName: 'Lancôme',
    category: ProductCategory.moisturizer,
    description:
        'Crema idratante anti-stress Lancôme con idratazione 48h. Arricchita con Rosa di Francia, Peonia Suffruticosa e Moringa per lenire, nutrire e proteggere la pelle da stress ossidativi e ambientali.',
    howToUse:
        'Ultimo step prima dell\'SPF (mattina) o ultimo step serale. Morbido strato su viso e collo con movimenti ascendenti e leggero massaggio.',
    keyIngredients: [
      'Estratto di Rosa di Francia',
      'Peonia Suffruticosa (Mu Dan Pi)',
      'Estratto di Moringa',
      'Glicerina',
      'Acqua termale',
    ],
    emoji: '💜',
    timing: ProductTiming.both,
    imageUrl: 'https://media.ulta.com/i/ulta/pimprod2048816?\$promoMedFace\$',
  ),

  // ─── SPF ──────────────────────────────────────────────────────
  'spf': Product(
    id: 'spf',
    fullName: 'Protezione Solare SPF 50+',
    brand: '',
    shortName: 'SPF',
    category: ProductCategory.spf,
    description:
        'Protezione solare ad ampio spettro UVA/UVB obbligatoria ogni mattina. Previene fotoinvecchiamento, macchie, danni al DNA cellulare e potenzia i risultati di tutti gli altri prodotti della routine.',
    howToUse:
        'Ultimo step assoluto della routine mattutina, dopo la crema idratante. Applica una quantità generosa (regola: ¼ di cucchiaino per il viso) su viso, collo e décolleté. Riapplica ogni 2 ore in caso di esposizione diretta al sole.',
    keyIngredients: ['Filtri UV ad ampio spettro (minerali e/o chimici)'],
    emoji: '☀️',
    timing: ProductTiming.morning,
    warnings:
        'Non saltare MAI, nemmeno in giorni nuvolosi, in inverno o al chiuso. Fondamentale se usi Retinal, acidi esfolianti o Vitamina C: senza SPF questi prodotti possono causare iperpigmentazione.',
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
