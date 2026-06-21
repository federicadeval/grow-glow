import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_banner.dart';
import '../../data/beauty_product_provider.dart';
import '../../data/products_database.dart';
import '../../data/weekly_routine_provider.dart';
import '../../domain/product.dart';
import '../../domain/weekly_routine.dart';
import 'routine_detail_screen.dart';
import 'skin_questionnaire_screen.dart';
import 'skin_photos_screen.dart';
import 'products_list_screen.dart';
import 'weekly_routine_builder_screen.dart';

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

// ─── RoutineStep & RoutineId (legacy, kept for RoutineDetailScreen) ──────
class RoutineStep {
  final String name;
  final String description;
  final IconData icon;
  final String? productId;

  const RoutineStep({
    required this.name,
    required this.description,
    required this.icon,
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
      case RoutineId.morningStandard:    return 'Routine Mattina';
      case RoutineId.morningSaturday:    return 'Routine Mattina (Sabato)';
      case RoutineId.eveningRetinal:     return 'Routine Sera';
      case RoutineId.eveningBuenosAires: return 'Routine Sera (Mercoledì)';
      case RoutineId.eveningSunday:      return 'Routine Sera (Domenica)';
    }
  }

  String get urlSegment {
    switch (this) {
      case RoutineId.morningStandard:    return 'morning_standard';
      case RoutineId.morningSaturday:    return 'morning_saturday';
      case RoutineId.eveningRetinal:     return 'evening_retinal';
      case RoutineId.eveningBuenosAires: return 'evening_buenos_aires';
      case RoutineId.eveningSunday:      return 'evening_sunday';
    }
  }

  List<RoutineStep> get steps => const [];
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

// ─── Step builder from product ────────────────────────────────
RoutineStep _stepFromProduct(Product p) => RoutineStep(
      name: p.shortName,
      description: p.howToUse,
      icon: p.icon,
      productId: p.id,
    );

List<RoutineStep> _stepsFromIds(List<String> ids) =>
    ids.map((id) => kProducts[id]).whereType<Product>().map(_stepFromProduct).toList();

String? _specialNote(List<String> ids) {
  for (final id in ids) {
    final cat = kProducts[id]?.category;
    if (cat == ProductCategory.retinoid) return kProducts[id]!.shortName;
  }
  for (final id in ids) {
    final cat = kProducts[id]?.category;
    if (cat == ProductCategory.exfoliant) return kProducts[id]!.shortName;
  }
  return null;
}

// ─── BeautyScreen ─────────────────────────────────────────────
class BeautyScreen extends ConsumerStatefulWidget {
  const BeautyScreen({super.key});

  @override
  ConsumerState<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends ConsumerState<BeautyScreen> {
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

  String _morningKey(int weekday, String ds) =>
      'routine_completion_day${weekday}_morning_$ds';
  String _eveningKey(int weekday, String ds) =>
      'routine_completion_day${weekday}_evening_$ds';

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

      final morningData = prefs.getString(_morningKey(weekday, ds));
      final eveningData = prefs.getString(_eveningKey(weekday, ds));

      cache[ds] = _DayCompletion(
        morningDone: morningData != null &&
            morningData.isNotEmpty &&
            !morningData.contains('0'),
        eveningDone: eveningData != null &&
            eveningData.isNotEmpty &&
            !eveningData.contains('0'),
        morningStarted: morningData != null && morningData.contains('1'),
        eveningStarted: eveningData != null && eveningData.contains('1'),
      );
    }

    if (mounted) setState(() => _completionCache = cache);
  }

  void _openRoutine(bool isMorning, DayRoutineConfig config) {
    final ids =
        isMorning ? config.morningProductIds : config.eveningProductIds;
    if (ids.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const WeeklyRoutineBuilderScreen()),
      ).then((_) => _loadCompletionCache());
      return;
    }

    final steps = _stepsFromIds(ids);
    final weekday = _selectedDate.weekday;
    final prefsKey =
        isMorning ? 'day${weekday}_morning' : 'day${weekday}_evening';
    final title = isMorning ? 'Routine Mattina' : 'Routine Sera';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineDetailScreen(
          dynamicSteps: steps,
          customPrefsKey: prefsKey,
          customTitle: title,
          date: _selectedDate,
        ),
      ),
    ).then((_) => _loadCompletionCache());
  }

  @override
  Widget build(BuildContext context) {
    final routine = ref.watch(weeklyRoutineProvider);
    final beautyState = ref.watch(beautyProductProvider);
    final activeCount = beautyState.activeIds.length;

    final weekday = _selectedDate.weekday;
    final dayConfig = routine[weekday] ?? DayRoutineConfig(weekday: weekday);
    final ds = dateStr(_selectedDate);
    final isToday = ds == dateStr(_today);

    final morningIds = dayConfig.morningProductIds;
    final eveningIds = dayConfig.eveningProductIds;

    return Scaffold(
      appBar: null,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBanner(
                icon: Icons.auto_awesome_rounded,
                title: 'Beauty',
                subtitle: 'Skincare personalizzata giorno per giorno',
                bgColor: AppColors.beauty,
                fgColor: AppColors.beautyDark,
              ),
              const SizedBox(height: 24),

              Text(_monthLabel(_today),
                  style: Theme.of(context).textTheme.titleLarge),
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
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 6),
                  Text('${_selectedDate.day}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.beautyDark,
                          )),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.beautyDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('oggi',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              _RoutineCard(
                timeLabel: 'Mattina',
                steps: morningIds.length,
                specialNote: _specialNote(morningIds),
                isDone: _completionCache[ds]?.morningDone ?? false,
                isEmpty: morningIds.isEmpty,
                onTap: () => _openRoutine(true, dayConfig),
              ),
              const SizedBox(height: 10),
              _RoutineCard(
                timeLabel: 'Sera',
                steps: eveningIds.length,
                specialNote: _specialNote(eveningIds),
                isDone: _completionCache[ds]?.eveningDone ?? false,
                isEmpty: eveningIds.isEmpty,
                onTap: () => _openRoutine(false, dayConfig),
              ),
              const SizedBox(height: 28),

              Text('I miei prodotti',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              _ProgressCard(
                icon: Icons.spa_rounded,
                title: 'Catalogo prodotti',
                subtitle: activeCount > 0
                    ? '$activeCount prodotti attivi — tocca per gestire il tuo arsenale'
                    : 'Attiva i prodotti che possiedi per costruire la tua routine',
                color: AppColors.mintDark,
                bgColor: AppColors.mint,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProductsListScreen()),
                ).then((_) => setState(() {})),
              ),
              const SizedBox(height: 10),

              _ProgressCard(
                icon: Icons.calendar_month_rounded,
                title: 'Routine settimanale',
                subtitle: 'Costruisci la tua routine giorno per giorno',
                color: AppColors.beautyDark,
                bgColor: AppColors.beauty,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const WeeklyRoutineBuilderScreen()),
                ).then((_) => _loadCompletionCache()),
              ),
              const SizedBox(height: 28),

              Text('Monitora i progressi',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _ProgressCard(
                icon: Icons.manage_search_rounded,
                title: 'Check-up pelle',
                subtitle: 'Questionario su idratazione, luminosità e imperfezioni',
                color: AppColors.lavenderDark,
                bgColor: AppColors.lavender,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SkinQuestionnaireScreen()),
                ),
              ),
              const SizedBox(height: 10),
              _ProgressCard(
                icon: Icons.photo_camera_rounded,
                title: 'Foto progressi',
                subtitle: 'Documenta il percorso della tua pelle nel tempo',
                color: AppColors.beautyDark,
                bgColor: AppColors.beauty,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SkinPhotosScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToDay(widget.selectedDate.day));
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
        20;
    _scrollController.jumpTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = widget.today.year;
    final month = widget.today.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final todayMidnight =
        DateTime(widget.today.year, widget.today.month, widget.today.day);

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
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      )),
                  const SizedBox(height: 2),
                  Text('${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : isFuture
                                ? AppColors.textSecondary
                                    .withValues(alpha: 0.35)
                                : AppColors.textPrimary,
                      )),
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
  final bool isEmpty;
  final VoidCallback onTap;

  const _RoutineCard({
    required this.timeLabel,
    required this.steps,
    required this.onTap,
    required this.isDone,
    required this.isEmpty,
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
                          )),
                  const SizedBox(height: 4),
                  if (isEmpty)
                    const Text(
                      'Tocca per configurare la routine',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.format_list_numbered_rounded,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('$steps step',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary)),
                        if (specialNote != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.beauty,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(specialNote!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.beautyDark,
                                )),
                          ),
                        ],
                        if (isDone) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.beautyDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Fatto ✓',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
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
                color: isEmpty
                    ? AppColors.divider
                    : AppColors.beauty,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isEmpty
                    ? Icons.add_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: isEmpty
                    ? AppColors.textSecondary
                    : AppColors.beautyDark,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ProgressCard({
    required this.icon,
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
              child: Center(child: Icon(icon, size: 26, color: color)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: color)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.3)),
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
