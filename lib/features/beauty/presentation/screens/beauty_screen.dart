import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import 'routine_detail_screen.dart';
import 'skin_questionnaire_screen.dart';
import 'skin_photos_screen.dart';
import 'products_list_screen.dart';

// ─── Helpers ─────────────────────────────────────────────────
String dateStr(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _monthLabel(DateTime d) {
  const months = [
    '', 'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
    'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
  ];
  return '${months[d.month]} ${d.year}';
}

// ─── Modello routine ──────────────────────────────────────────
class RoutineStep {
  final String name;
  final String description;
  final String emoji;
  final String? productId;

  const RoutineStep({
    required this.name,
    required this.description,
    required this.emoji,
    this.productId,
  });
}

enum RoutineId {
  morningStandard,
  morningSaturday,
  eveningRetinal,
  eveningBuenosAires,
  eveningSunday,
}

extension RoutineIdData on RoutineId {
  String get label {
    switch (this) {
      case RoutineId.morningStandard: return 'Routine Mattina ☀️';
      case RoutineId.morningSaturday: return 'Routine Mattina (Sabato) ☀️';
      case RoutineId.eveningRetinal: return 'Routine Sera 🌙';
      case RoutineId.eveningBuenosAires: return 'Routine Sera (Mercoledì) 🌙';
      case RoutineId.eveningSunday: return 'Routine Sera (Domenica) 🌙';
    }
  }

  String get urlSegment {
    switch (this) {
      case RoutineId.morningStandard: return 'morning_standard';
      case RoutineId.morningSaturday: return 'morning_saturday';
      case RoutineId.eveningRetinal: return 'evening_retinal';
      case RoutineId.eveningBuenosAires: return 'evening_buenos_aires';
      case RoutineId.eveningSunday: return 'evening_sunday';
    }
  }

  List<RoutineStep> get steps {
    switch (this) {
      case RoutineId.morningStandard: return _morningStandard;
      case RoutineId.morningSaturday: return _morningSaturday;
      case RoutineId.eveningRetinal: return _eveningRetinal;
      case RoutineId.eveningBuenosAires: return _eveningBuenosAires;
      case RoutineId.eveningSunday: return _eveningSunday;
    }
  }
}

// ─── Step lists ───────────────────────────────────────────────
const _morningStandard = [
  RoutineStep(name: 'CeraVe', description: 'Detergente idratante — massaggia sul viso bagnato, risciacqua.', emoji: '🫧', productId: 'cerave_cleanser'),
  RoutineStep(name: 'Vitamina C', description: 'Siero antiossidante — 2-3 gocce su viso e collo, tampona delicatamente.', emoji: '🌿', productId: 'vitamina_c'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema anti-age L\'Oréal — stendi su tutto il viso.', emoji: '✨', productId: 'revitalift'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — morbido strato su viso e collo.', emoji: '💜', productId: 'lancome'),
  RoutineStep(name: 'SPF', description: 'Protezione solare — ultimo step, applica generosamente. Non saltare mai!', emoji: '☀️', productId: 'spf'),
];

const _morningSaturday = [
  RoutineStep(name: 'CeraVe', description: 'Detergente idratante — massaggia sul viso bagnato, risciacqua.', emoji: '🫧', productId: 'cerave_cleanser'),
  RoutineStep(name: 'Bahia Blanca', description: 'Peeling/scrub — applica sul viso asciutto, massaggia delicatamente, risciacqua.', emoji: '🌟', productId: 'bahia_blanca'),
  RoutineStep(name: 'Vitamina C', description: 'Siero antiossidante — 2-3 gocce su viso e collo, tampona delicatamente.', emoji: '🌿', productId: 'vitamina_c'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema anti-age L\'Oréal — stendi su tutto il viso.', emoji: '✨', productId: 'revitalift'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — morbido strato su viso e collo.', emoji: '💜', productId: 'lancome'),
  RoutineStep(name: 'SPF', description: 'Protezione solare — ultimo step, applica generosamente. Non saltare mai!', emoji: '☀️', productId: 'spf'),
];

const _eveningRetinal = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹', productId: 'cerave_foaming'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido per massimizzare l\'assorbimento.', emoji: '💧', productId: 'acido_ialuronico'),
  RoutineStep(name: 'Retinal', description: 'Retinaldeide — applica uno strato sottile su tutto il viso. Evita contorno occhi. Inizia 2-3 volte a settimana.', emoji: '🌙', productId: 'retinal'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema L\'Oréal — stendi su tutto il viso per nutrire.', emoji: '✨', productId: 'revitalift'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer. Morbido strato su viso e collo.', emoji: '💜', productId: 'lancome'),
];

const _eveningBuenosAires = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹', productId: 'cerave_foaming'),
  RoutineStep(name: 'Buenos Aires', description: 'Acido esfoliante (BHA/AHA) — applica su viso asciutto. Non usare insieme al Retinal.', emoji: '🧪', productId: 'buenos_aires'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido.', emoji: '💧', productId: 'acido_ialuronico'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema L\'Oréal — stendi su tutto il viso.', emoji: '✨', productId: 'revitalift'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer.', emoji: '💜', productId: 'lancome'),
];

const _eveningSunday = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹', productId: 'cerave_foaming'),
  RoutineStep(name: 'Bogotà', description: 'Applica il prodotto sul viso come da indicazioni. Lascia agire il tempo necessario, poi risciacqua se richiesto.', emoji: '🌿', productId: 'bogota'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido per massimizzare l\'assorbimento.', emoji: '💧', productId: 'acido_ialuronico'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer. Morbido strato su viso e collo.', emoji: '💜', productId: 'lancome'),
];

// ─── Mappa giorno → routine ───────────────────────────────────
// weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
RoutineId morningRoutineFor(int weekday) {
  return weekday == 6 ? RoutineId.morningSaturday : RoutineId.morningStandard;
}

RoutineId eveningRoutineFor(int weekday) {
  if (weekday == 7) return RoutineId.eveningSunday;
  if (weekday == 3) return RoutineId.eveningBuenosAires;
  return RoutineId.eveningRetinal;
}

String dayLabel(int weekday) {
  const labels = ['', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];
  return labels[weekday];
}

String shortDayLabel(int weekday) {
  const labels = ['', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  return labels[weekday];
}

// ─── Completion model ─────────────────────────────────────────
class _DayCompletion {
  final bool morningDone;
  final bool eveningDone;
  final bool morningStarted;
  final bool eveningStarted;

  const _DayCompletion({
    required this.morningDone,
    required this.eveningDone,
    required this.morningStarted,
    required this.eveningStarted,
  });
}

// ─── BeautyScreen ─────────────────────────────────────────────
class BeautyScreen extends StatefulWidget {
  const BeautyScreen({super.key});

  @override
  State<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  late DateTime _today;
  late DateTime _selectedDate;
  Map<String, _DayCompletion> _completionCache = {};

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _selectedDate = _today;
    _loadCompletionCache();
  }

  Future<void> _loadCompletionCache() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _today.year;
    final month = _today.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final Map<String, _DayCompletion> cache = {};
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final ds = dateStr(date);
      final weekday = date.weekday;

      final morningId = morningRoutineFor(weekday);
      final eveningId = eveningRoutineFor(weekday);

      final morningData = prefs.getString('routine_completion_${morningId.urlSegment}_$ds');
      final eveningData = prefs.getString('routine_completion_${eveningId.urlSegment}_$ds');

      cache[ds] = _DayCompletion(
        morningDone: morningData != null && morningData.isNotEmpty && !morningData.contains('0'),
        eveningDone: eveningData != null && eveningData.isNotEmpty && !eveningData.contains('0'),
        morningStarted: morningData != null && morningData.contains('1'),
        eveningStarted: eveningData != null && eveningData.contains('1'),
      );
    }

    if (mounted) setState(() => _completionCache = cache);
  }

  void _openRoutine(RoutineId id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineDetailScreen(
          routineId: id.urlSegment,
          date: _selectedDate,
        ),
      ),
    ).then((_) => _loadCompletionCache());
  }

  @override
  Widget build(BuildContext context) {
    final morningId = morningRoutineFor(_selectedDate.weekday);
    final eveningId = eveningRoutineFor(_selectedDate.weekday);
    final ds = dateStr(_selectedDate);
    final isToday = ds == dateStr(_today);

    return Scaffold(
      appBar: AppBar(title: const Text('Beauty ✨')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StreakBanner(),
            const SizedBox(height: 24),

            Text(_monthLabel(_today),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _CalendarStrip(
              selectedDate: _selectedDate,
              today: _today,
              completionCache: _completionCache,
              onSelect: (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Text(dayLabel(_selectedDate.weekday),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 6),
                Text('${_selectedDate.day}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.beautyDark,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.beautyDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('oggi',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            _RoutineCard(
              timeLabel: 'Mattina ☀️',
              steps: morningId.steps.length,
              specialNote: _selectedDate.weekday == 6 ? 'Bahia Blanca' : null,
              isDone: _completionCache[ds]?.morningDone ?? false,
              onTap: () => _openRoutine(morningId),
            ),
            const SizedBox(height: 10),
            _RoutineCard(
              timeLabel: 'Sera 🌙',
              steps: eveningId.steps.length,
              specialNote: _selectedDate.weekday == 7
                  ? 'Bogotà'
                  : _selectedDate.weekday == 3
                      ? 'Buenos Aires (no Retinal)'
                      : 'Retinal',
              isDone: _completionCache[ds]?.eveningDone ?? false,
              onTap: () => _openRoutine(eveningId),
            ),
            const SizedBox(height: 28),

            Text('I miei prodotti',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _ProgressCard(
              emoji: '🧴',
              title: 'Tutti i prodotti',
              subtitle: 'Schede dettagliate di ogni prodotto nella tua routine',
              color: AppColors.mintDark,
              bgColor: AppColors.mint,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductsListScreen()),
              ),
            ),
            const SizedBox(height: 28),

            Text('Monitora i progressi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _ProgressCard(
              emoji: '🔍',
              title: 'Check-up pelle',
              subtitle: 'Questionario su idratazione, luminosità e imperfezioni',
              color: AppColors.lavenderDark,
              bgColor: AppColors.lavender,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkinQuestionnaireScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _ProgressCard(
              emoji: '📸',
              title: 'Foto progressi',
              subtitle: 'Documenta il percorso della tua pelle nel tempo',
              color: AppColors.beautyDark,
              bgColor: AppColors.beauty,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkinPhotosScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _StreakBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.beauty, AppColors.blush],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('La tua routine ✨',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.beautyDark,
                ),
              ),
              Text('Skincare personalizzata giorno per giorno',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.beautyDark.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }
}

class _CalendarStrip extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime today;
  final Map<String, _DayCompletion> completionCache;
  final ValueChanged<DateTime> onSelect;

  const _CalendarStrip({
    required this.selectedDate,
    required this.today,
    required this.completionCache,
    required this.onSelect,
  });

  @override
  State<_CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends State<_CalendarStrip> {
  final _scrollController = ScrollController();
  static const double _itemWidth = 50.0;
  static const double _itemGap = 8.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToDay(widget.selectedDate.day));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDay(int day) {
    if (!_scrollController.hasClients) return;
    final offset = (day - 1) * (_itemWidth + _itemGap) -
        MediaQuery.of(context).size.width / 2 +
        _itemWidth / 2 +
        20; // compensate page padding
    _scrollController.jumpTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = widget.today.year;
    final month = widget.today.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final todayMidnight = DateTime(widget.today.year, widget.today.month, widget.today.day);

    return SizedBox(
      height: 76,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        itemBuilder: (context, i) {
          final date = DateTime(year, month, i + 1);
          final ds = dateStr(date);
          final isToday = date.day == widget.today.day;
          final isSelected = date.day == widget.selectedDate.day;
          final isFuture = date.isAfter(todayMidnight);
          final completion = widget.completionCache[ds];

          return GestureDetector(
            onTap: () => widget.onSelect(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: _itemWidth,
              margin: const EdgeInsets.only(right: _itemGap),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.beautyDark
                    : isToday
                        ? AppColors.beauty
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: isToday && !isSelected
                    ? Border.all(color: AppColors.beautyDark, width: 1.5)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(shortDayLabel(date.weekday),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : isFuture
                              ? AppColors.textSecondary.withValues(alpha: 0.35)
                              : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isFuture)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CompletionDot(
                          done: completion?.morningDone ?? false,
                          started: completion?.morningStarted ?? false,
                          isSelected: isSelected,
                        ),
                        const SizedBox(width: 3),
                        _CompletionDot(
                          done: completion?.eveningDone ?? false,
                          started: completion?.eveningStarted ?? false,
                          isSelected: isSelected,
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CompletionDot extends StatelessWidget {
  final bool done;
  final bool started;
  final bool isSelected;

  const _CompletionDot({
    required this.done,
    required this.started,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (done) {
      color = isSelected ? Colors.white : AppColors.beautyDark;
    } else if (started) {
      color = isSelected
          ? Colors.white.withValues(alpha: 0.6)
          : AppColors.beautyDark.withValues(alpha: 0.45);
    } else {
      color = isSelected
          ? Colors.white.withValues(alpha: 0.3)
          : AppColors.beauty.withValues(alpha: 0.7);
    }
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final String timeLabel;
  final int steps;
  final String? specialNote;
  final bool isDone;
  final VoidCallback onTap;

  const _RoutineCard({
    required this.timeLabel,
    required this.steps,
    required this.onTap,
    required this.isDone,
    this.specialNote,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.beauty.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.beautyDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.format_list_numbered_rounded, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$steps step',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      if (specialNote != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.beauty,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(specialNote!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.beautyDark,
                            ),
                          ),
                        ),
                      ],
                      if (isDone) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.beautyDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Fatto ✓',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.beauty,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.beautyDark, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ProgressCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
