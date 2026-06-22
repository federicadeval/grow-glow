import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/beauty_product_provider.dart';
import '../../data/products_database.dart';
import '../../data/weekly_routine_provider.dart';
import '../../domain/product.dart';
import '../../domain/weekly_routine.dart';

// Category order priority for routine steps
const _categoryOrder = [
  ProductCategory.cleanser,
  ProductCategory.exfoliant,
  ProductCategory.serum,
  ProductCategory.treatment,
  ProductCategory.retinoid,
  ProductCategory.moisturizer,
  ProductCategory.spf,
];

int _categoryPriority(ProductCategory c) {
  final idx = _categoryOrder.indexOf(c);
  return idx == -1 ? 99 : idx;
}

const _dayNames = [
  '', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì',
  'Venerdì', 'Sabato', 'Domenica',
];

const _dayShort = [
  '', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom',
];

// ─── Suggestion model ─────────────────────────────────────────
class _Suggestion {
  final IconData icon;
  final Color color;
  final String text;
  final bool isWarning;

  const _Suggestion({
    required this.icon,
    required this.color,
    required this.text,
    this.isWarning = false,
  });
}

List<_Suggestion> _computeSuggestions(Map<int, DayRoutineConfig> routine) {
  final suggestions = <_Suggestion>[];
  final seen = <String>{};

  void addOnce(String key, _Suggestion s) {
    if (!seen.contains(key)) {
      seen.add(key);
      suggestions.add(s);
    }
  }

  for (final day in routine.values) {
    final allIds = [...day.morningProductIds, ...day.eveningProductIds];

    final hasRetinoid = allIds
        .any((id) => kProducts[id]?.category == ProductCategory.retinoid);
    final hasExfoliant = allIds
        .any((id) => kProducts[id]?.category == ProductCategory.exfoliant);
    if (hasRetinoid && hasExfoliant) {
      addOnce(
        'retinoid_exfoliant_${day.weekday}',
        _Suggestion(
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFE07000),
          isWarning: true,
          text:
              '${_dayNames[day.weekday]}: evita retinoide e acido esfoliante nello stesso giorno per non irritare la pelle.',
        ),
      );
    }

    // SPF missing in morning
    if (day.morningProductIds.isNotEmpty) {
      final hasSpf = day.morningProductIds
          .any((id) => kProducts[id]?.category == ProductCategory.spf);
      if (!hasSpf) {
        addOnce(
          'spf_missing',
          const _Suggestion(
            icon: Icons.wb_sunny_rounded,
            color: Color(0xFFC07000),
            text:
                'Includi sempre l\'SPF nelle routine del mattino — è il passo anti-invecchiamento più efficace.',
          ),
        );
      }
    }
  }

  // Retinoid frequency
  final retinoidDays = routine.values.where((d) {
    final allIds = [...d.morningProductIds, ...d.eveningProductIds];
    return allIds
        .any((id) => kProducts[id]?.category == ProductCategory.retinoid);
  }).length;
  if (retinoidDays > 4) {
    addOnce(
      'retinoid_freq',
      _Suggestion(
        icon: Icons.info_outline_rounded,
        color: AppColors.beautyDark,
        text:
            'Stai usando il retinoide $retinoidDays giorni su 7. Inizia con 2-3 volte a settimana e aumenta gradualmente.',
      ),
    );
  }

  // Exfoliant frequency
  final exfoliantDays = routine.values.where((d) {
    final allIds = [...d.morningProductIds, ...d.eveningProductIds];
    return allIds
        .any((id) => kProducts[id]?.category == ProductCategory.exfoliant);
  }).length;
  if (exfoliantDays > 3) {
    addOnce(
      'exfoliant_freq',
      _Suggestion(
        icon: Icons.info_outline_rounded,
        color: AppColors.beautyDark,
        text:
            'Gli acidi esfolianti dovrebbero essere usati max 2-3 volte a settimana per evitare irritazioni.',
      ),
    );
  }

  // Vitamin C in evening
  for (final day in routine.values) {
    final morningOnlyInEvening = day.eveningProductIds.any(
      (id) => kProducts[id]?.timing == ProductTiming.morning,
    );
    if (morningOnlyInEvening) {
      addOnce(
        'morning_product_in_evening',
        const _Suggestion(
          icon: Icons.lightbulb_outline_rounded,
          color: AppColors.beautyDark,
          text:
              'Alcuni prodotti (come la Vitamina C) sono formulati per il mattino e danno risultati migliori di giorno.',
        ),
      );
      break;
    }
  }

  return suggestions;
}

// ─── Screen ───────────────────────────────────────────────────
class WeeklyRoutineBuilderScreen extends ConsumerStatefulWidget {
  const WeeklyRoutineBuilderScreen({super.key});

  @override
  ConsumerState<WeeklyRoutineBuilderScreen> createState() =>
      _WeeklyRoutineBuilderScreenState();
}

class _WeeklyRoutineBuilderScreenState
    extends ConsumerState<WeeklyRoutineBuilderScreen> {
  int _selectedDay = 1; // 1=Mon

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().weekday;
  }

  @override
  Widget build(BuildContext context) {
    final routine = ref.watch(weeklyRoutineProvider);
    final beautyState = ref.watch(beautyProductProvider);
    final activeProducts = kProducts.values
        .where((p) => beautyState.activeIds.contains(p.id))
        .toList();

    final dayConfig =
        routine[_selectedDay] ?? DayRoutineConfig(weekday: _selectedDay);
    final suggestions = _computeSuggestions(routine);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Routine Settimanale'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _showTipsDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Day tabs
          _DayTabBar(
            selectedDay: _selectedDay,
            routine: routine,
            onSelect: (d) => setState(() => _selectedDay = d),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Suggestions
                  if (suggestions.isNotEmpty) ...[
                    _SuggestionsCard(suggestions: suggestions),
                    const SizedBox(height: 20),
                  ],

                  if (activeProducts.isEmpty) ...[
                    const _EmptyActiveProducts(),
                    const SizedBox(height: 20),
                  ],

                  // Morning section
                  _SessionSection(
                    title: 'Mattina',
                    icon: Icons.wb_sunny_outlined,
                    productIds: dayConfig.morningProductIds,
                    activeProducts: activeProducts,
                    allDayIds: [
                      ...dayConfig.morningProductIds,
                      ...dayConfig.eveningProductIds
                    ],
                    onChanged: (ids) => ref
                        .read(weeklyRoutineProvider.notifier)
                        .setDayProducts(_selectedDay, true, ids),
                  ),
                  const SizedBox(height: 16),

                  // Evening section
                  _SessionSection(
                    title: 'Sera',
                    icon: Icons.nightlight_outlined,
                    productIds: dayConfig.eveningProductIds,
                    activeProducts: activeProducts,
                    allDayIds: [
                      ...dayConfig.morningProductIds,
                      ...dayConfig.eveningProductIds
                    ],
                    onChanged: (ids) => ref
                        .read(weeklyRoutineProvider.notifier)
                        .setDayProducts(_selectedDay, false, ids),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Consigli per la tua routine',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TipItem(
                icon: Icons.layers_rounded,
                text:
                    'Ordine base: Detergente → Siero → Idratante → SPF (mattina)',
              ),
              _TipItem(
                icon: Icons.wb_sunny_rounded,
                text: 'L\'SPF va applicato ogni mattina come ultimo step.',
              ),
              _TipItem(
                icon: Icons.nightlight_rounded,
                text:
                    'Il retinoide si usa la sera: inizia 2-3 volte/settimana e aumenta gradualmente.',
              ),
              _TipItem(
                icon: Icons.science_rounded,
                text:
                    'Non usare acidi esfolianti e retinoide la stessa sera — rischieresti irritazioni.',
              ),
              _TipItem(
                icon: Icons.eco_rounded,
                text:
                    'La Vitamina C funziona meglio al mattino: potenzia l\'effetto dell\'SPF.',
              ),
              _TipItem(
                icon: Icons.repeat_rounded,
                text:
                    'Gli esfolianti acidi: max 2-3 volte a settimana, sera e su pelle asciutta.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi',
                style: TextStyle(color: AppColors.beautyDark)),
          ),
        ],
      ),
    );
  }
}

// ─── Day tab bar ──────────────────────────────────────────────
class _DayTabBar extends StatelessWidget {
  final int selectedDay;
  final Map<int, DayRoutineConfig> routine;
  final ValueChanged<int> onSelect;

  const _DayTabBar({
    required this.selectedDay,
    required this.routine,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(7, (i) {
          final day = i + 1;
          final isSelected = day == selectedDay;
          final config = routine[day];
          final hasMorning =
              config != null && config.morningProductIds.isNotEmpty;
          final hasEvening =
              config != null && config.eveningProductIds.isNotEmpty;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.beautyDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.beautyDark : AppColors.divider,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _dayShort[day],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MiniDot(
                            filled: hasMorning, isSelected: isSelected),
                        const SizedBox(width: 2),
                        _MiniDot(
                            filled: hasEvening, isSelected: isSelected),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  final bool filled;
  final bool isSelected;
  const _MiniDot({required this.filled, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = filled
        ? (isSelected ? Colors.white : AppColors.beautyDark)
        : (isSelected
            ? Colors.white.withValues(alpha: 0.3)
            : AppColors.divider);
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ─── Suggestions card ─────────────────────────────────────────
class _SuggestionsCard extends StatefulWidget {
  final List<_Suggestion> suggestions;
  const _SuggestionsCard({required this.suggestions});

  @override
  State<_SuggestionsCard> createState() => _SuggestionsCardState();
}

class _SuggestionsCardState extends State<_SuggestionsCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.beauty.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beauty),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded,
                      size: 16, color: AppColors.beautyDark),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Suggerimenti (${widget.suggestions.length})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.beautyDark,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: AppColors.beautyDark,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    children: [
                      const Divider(height: 1, color: AppColors.beauty),
                      ...widget.suggestions.map(
                        (s) => Padding(
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(s.icon, size: 15, color: s.color),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.text,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: s.isWarning
                                        ? s.color
                                        : AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Empty active products ────────────────────────────────────
class _EmptyActiveProducts extends StatelessWidget {
  const _EmptyActiveProducts();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 18, color: AppColors.textSecondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Attiva prima i prodotti che possiedi dal catalogo per aggiungerli alla routine.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Session section ──────────────────────────────────────────
class _SessionSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> productIds;
  final List<Product> activeProducts;
  final List<String> allDayIds;
  final ValueChanged<List<String>> onChanged;

  const _SessionSection({
    required this.title,
    required this.icon,
    required this.productIds,
    required this.activeProducts,
    required this.allDayIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final products = productIds
        .map((id) => kProducts[id])
        .whereType<Product>()
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.beauty.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.beauty,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.beautyDark),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.beautyDark,
                    )),
                const Spacer(),
                Text('${products.length} step',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),

          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Nessun prodotto. Premi + per aggiungere.',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ),

          if (products.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.divider),
            ...products.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return _ProductRow(
                product: p,
                index: i + 1,
                onRemove: () {
                  final updated = List<String>.from(productIds)..remove(p.id);
                  onChanged(updated);
                },
              );
            }),
          ],

          // Add button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: GestureDetector(
              onTap: () => _showAddSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.beauty, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded,
                        size: 18, color: AppColors.beautyDark),
                    SizedBox(width: 6),
                    Text('Aggiungi prodotto',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.beautyDark,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => _AddProductSheet(
        sessionTitle: title,
        activeProducts: activeProducts,
        initialSelectedIds: productIds,
        onChanged: onChanged,
      ),
    );
  }
}

// ─── Product row in session ───────────────────────────────────
class _ProductRow extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onRemove;

  const _ProductRow({
    required this.product,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cat = product.category;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: cat.bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: cat.fgColor,
                  )),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cat.bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(product.icon, size: 16, color: cat.fgColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.shortName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    )),
                Text(cat.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    )),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.remove_circle_outline_rounded,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add product bottom sheet ─────────────────────────────────
class _AddProductSheet extends StatefulWidget {
  final String sessionTitle;
  final List<Product> activeProducts;
  final List<String> initialSelectedIds;
  final ValueChanged<List<String>> onChanged;

  const _AddProductSheet({
    required this.sessionTitle,
    required this.activeProducts,
    required this.initialSelectedIds,
    required this.onChanged,
  });

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  late List<String> _currentIds;

  @override
  void initState() {
    super.initState();
    _currentIds = List.from(widget.initialSelectedIds);
  }

  void _toggle(String id) {
    setState(() {
      if (_currentIds.contains(id)) {
        _currentIds.remove(id);
      } else {
        _currentIds.add(id);
        _currentIds.sort((a, b) {
          final ca = kProducts[a]?.category ?? ProductCategory.cleanser;
          final cb = kProducts[b]?.category ?? ProductCategory.cleanser;
          return _categoryPriority(ca).compareTo(_categoryPriority(cb));
        });
      }
    });
    widget.onChanged(List.from(_currentIds));
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <ProductCategory, List<Product>>{};
    for (final p in widget.activeProducts) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    final categories = ProductCategory.values
        .where((c) => grouped.containsKey(c))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Aggiungi a ${widget.sessionTitle}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      )),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fatto',
                      style: TextStyle(
                        color: AppColors.beautyDark,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: widget.activeProducts.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Nessun prodotto attivo. Attiva prima i prodotti dal catalogo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ),
                  )
                : ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    children: [
                      for (final cat in categories) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: cat.bgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(cat.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: cat.fgColor,
                                )),
                          ),
                        ),
                        ...grouped[cat]!.map((p) {
                          final isSelected = _currentIds.contains(p.id);
                          return GestureDetector(
                            onTap: () => _toggle(p.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? cat.bgColor.withValues(alpha: 0.2)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? cat.bgColor
                                      : AppColors.divider,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: cat.bgColor,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Icon(p.icon,
                                        size: 18, color: cat.fgColor),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(p.shortName,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            )),
                                        if (p.brand.isNotEmpty)
                                          Text(p.brand,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                              )),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? cat.fgColor
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? cat.fgColor
                                            : AppColors.divider,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check_rounded,
                                            size: 14, color: Colors.white)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Tip item ─────────────────────────────────────────────────
class _TipItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TipItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.beautyDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                  height: 1.4,
                )),
          ),
        ],
      ),
    );
  }
}
