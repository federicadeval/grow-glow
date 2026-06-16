import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import '../../../../core/theme/app_theme.dart';
import '../../../../features/profile/data/profile_provider.dart';
import '../../data/calorie_provider.dart';
import '../../data/meal_plan_provider.dart';
import '../../domain/models/meal_plan_model.dart';
import '../../domain/food_database.dart';
import '../../data/open_food_facts_service.dart';

class DietScreen extends ConsumerStatefulWidget {
  const DietScreen({super.key});

  @override
  ConsumerState<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends ConsumerState<DietScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // 0=Mon … 6=Sun

  static const _dayLabels = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
  static const _dayNames = ['Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];

  bool get _isToday => _selectedDay == DateTime.now().weekday - 1;

  @override
  Widget build(BuildContext context) {
    final planState = ref.watch(mealPlanProvider);
    final dayMeals = planState.plan.day(_selectedDay);
    final profile = ref.watch(profileProvider);
    final calories = ref.watch(calorieProvider);
    final targetKcal = profile?.suggestedKcal ?? 2000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dieta'),
        actions: [
          TextButton.icon(
            onPressed: () => _confirmGenerate(context, ref),
            icon: const Icon(Icons.auto_awesome_rounded, size: 16),
            label: const Text('Genera', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Kcal summary strip
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _KcalPill(Icons.flag_rounded, 'Obiettivo', '$targetKcal'),
                _KcalPill(Icons.restaurant_rounded, 'Consumate', '${calories.consumedKcal}'),
                _KcalPill(Icons.fitness_center_rounded, 'Bruciate', '${calories.burnedKcal}'),
                _KcalPill(Icons.check_circle_rounded, 'Rimanenti',
                  '${(targetKcal - calories.consumedKcal + calories.burnedKcal).clamp(0, 99999)}'),
              ],
            ),
          ),

          // Day selector
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: List.generate(7, (i) {
                final isSelected = i == _selectedDay;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.mintDark : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _dayLabels[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Day label
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _dayNames[_selectedDay],
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                if (dayMeals.totalKcal > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${dayMeals.totalKcal} kcal totali',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mintDark),
                    ),
                  ),
              ],
            ),
          ),

          // Meal cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: MealType.values.map((type) {
                final meal = dayMeals.getByType(type);
                return _MealCard(
                  type: type,
                  meal: meal,
                  isToday: _isToday,
                  onEdit: () => _openEditDialog(type, meal),
                  onClear: meal.isEmpty ? null : () => ref.read(mealPlanProvider.notifier).clearMeal(_selectedDay, type),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmGenerate(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Genera piano settimanale'),
        content: const Text(
          'Verrà generato un piano vegetariano per tutta la settimana. '
          'I pasti esistenti verranno sostituiti. Puoi modificarli in qualsiasi momento.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(mealPlanProvider.notifier).generatePlan();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Piano settimanale generato ✓')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
            child: const Text('Genera'),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(MealType type, MealEntry current) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MealEditSheet(
        type: type,
        current: current,
        onSave: (entry) {
          ref.read(mealPlanProvider.notifier).setMeal(_selectedDay, type, entry);
          if (_isToday && !current.isEmpty) {
            ref.read(calorieProvider.notifier).removeConsumed(current.kcal);
          }
          if (_isToday && !entry.isEmpty) {
            ref.read(calorieProvider.notifier).addConsumed(entry.kcal);
          }
        },
      ),
    );
  }
}

class _KcalPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _KcalPill(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.mintDark),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MealCard extends StatefulWidget {
  final MealType type;
  final MealEntry meal;
  final bool isToday;
  final VoidCallback onEdit;
  final VoidCallback? onClear;

  const _MealCard({
    required this.type,
    required this.meal,
    required this.isToday,
    required this.onEdit,
    this.onClear,
  });

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final isEmpty = meal.isEmpty;
    final hasIngredients = meal.ingredients.isNotEmpty;

    return GestureDetector(
      onTap: isEmpty ? widget.onEdit : () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isEmpty ? AppColors.mint.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: isEmpty
              ? Border.all(color: AppColors.mintDark.withValues(alpha: 0.25))
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(widget.type.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.type.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            if (meal.isEatingOut) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xFFFFE0B2), borderRadius: BorderRadius.circular(8)),
                                child: const Text('fuori', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFE65100))),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (isEmpty)
                          Text('Tocca per aggiungere', style: TextStyle(fontSize: 13, color: AppColors.mintDark.withValues(alpha: 0.7)))
                        else ...[
                          Text(meal.name, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _MacroPill('${meal.effectiveKcal} kcal', AppColors.fitnessDark, AppColors.fitness),
                              if (hasIngredients) ...[
                                const SizedBox(width: 6),
                                _MacroPill('P ${meal.totalProtein.round()}g', AppColors.peachDark, AppColors.peach),
                                const SizedBox(width: 6),
                                _MacroPill('C ${meal.totalCarbs.round()}g', AppColors.mintDark, AppColors.mint),
                                const SizedBox(width: 6),
                                _MacroPill('G ${meal.totalFat.round()}g', AppColors.lavenderDark, AppColors.lavender),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isEmpty) ...[
                    Column(
                      children: [
                        IconButton(
                          onPressed: widget.onEdit,
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          color: AppColors.textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        if (widget.onClear != null) ...[
                          const SizedBox(height: 8),
                          IconButton(
                            onPressed: widget.onClear,
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: AppColors.textSecondary,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ],
                    ),
                    if (hasIngredients) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ],
              ),
            ),

            // Expanded ingredient list
            if (_expanded && hasIngredients)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Text('Ingredienti', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    ...meal.ingredients.map((ing) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Expanded(child: Text(ing.name, style: const TextStyle(fontSize: 12))),
                          Text('${ing.grams.round()}g', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 52,
                            child: Text('${ing.kcal} kcal',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.mintDark)),
                          ),
                        ],
                      ),
                    )),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MacroDetail('Prot.', '${meal.totalProtein.round()}g'),
                        _MacroDetail('Carb.', '${meal.totalCarbs.round()}g'),
                        _MacroDetail('Grassi', '${meal.totalFat.round()}g'),
                        _MacroDetail('Kcal', '${meal.effectiveKcal}'),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;
  const _MacroPill(this.text, this.color, this.bg);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
  );
}

class _MacroDetail extends StatelessWidget {
  final String label;
  final String value;
  const _MacroDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
    ],
  );
}

class _MealEditSheet extends StatefulWidget {
  final MealType type;
  final MealEntry current;
  final void Function(MealEntry) onSave;

  const _MealEditSheet({required this.type, required this.current, required this.onSave});

  @override
  State<_MealEditSheet> createState() => _MealEditSheetState();
}

class _MealEditSheetState extends State<_MealEditSheet> with SingleTickerProviderStateMixin {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _kcalCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _searchCtrl;
  late bool _isEatingOut;
  late List<Ingredient> _ingredients;
  late TabController _tabCtrl;
  List<FoodItem> _searchResults = [];
  final TextEditingController _barcodeCtrl = TextEditingController();
  bool _barcodeLoading = false;
  String? _barcodeError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.current.name);
    _kcalCtrl = TextEditingController(text: widget.current.kcal > 0 && widget.current.ingredients.isEmpty ? '${widget.current.kcal}' : '');
    _notesCtrl = TextEditingController(text: widget.current.notes);
    _searchCtrl = TextEditingController();
    _isEatingOut = widget.current.isEatingOut;
    _ingredients = List.from(widget.current.ingredients);
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _notesCtrl.dispose();
    _searchCtrl.dispose();
    _barcodeCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  int get _computedKcal {
    if (_ingredients.isNotEmpty) return _ingredients.fold(0, (s, i) => s + i.kcal);
    return int.tryParse(_kcalCtrl.text) ?? 0;
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    widget.onSave(MealEntry(
      name: name,
      kcal: _ingredients.isEmpty ? (int.tryParse(_kcalCtrl.text) ?? 0) : 0,
      notes: _notesCtrl.text.trim(),
      isEatingOut: _isEatingOut,
      ingredients: List.from(_ingredients),
    ));
    Navigator.pop(context);
  }

  void _addIngredient(FoodItem food) {
    showDialog(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController(text: '100');
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(food.name, style: const TextStyle(fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${food.kcalPer100g.round()} kcal / 100g',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Grammi', suffixText: 'g'),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
            ElevatedButton(
              onPressed: () {
                final g = double.tryParse(ctrl.text) ?? 100;
                setState(() {
                  _ingredients.add(Ingredient(name: food.name, grams: g, kcalPer100g: food.kcalPer100g));
                  _searchCtrl.clear();
                  _searchResults = [];
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                Text(widget.type.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(widget.type.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(12)),
                  child: Text('$_computedKcal kcal',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.mintDark, fontSize: 14)),
                ),
              ],
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabCtrl,
            indicatorColor: AppColors.mintDark,
            labelColor: AppColors.mintDark,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [Tab(text: 'Pasto'), Tab(text: 'Ingredienti'), Tab(text: 'Barcode')],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // ── Tab 1: info pasto ──────────────────────────────
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(labelText: 'Nome del pasto', hintText: 'Es. Pasta al pomodoro'),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      if (_ingredients.isEmpty)
                        TextField(
                          controller: _kcalCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Kcal manuali (se non usi ingredienti)',
                            suffixText: 'kcal',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesCtrl,
                        decoration: const InputDecoration(labelText: 'Note', hintText: 'Es. senza sale, con olio EVO'),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => setState(() => _isEatingOut = !_isEatingOut),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _isEatingOut ? const Color(0xFFFFE0B2) : AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _isEatingOut ? const Color(0xFFE65100) : AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.restaurant_rounded, size: 20, color: Color(0xFFE65100)),
                              const SizedBox(width: 12),
                              const Expanded(child: Text('Mangio fuori', style: TextStyle(fontWeight: FontWeight.w600))),
                              Icon(
                                _isEatingOut ? Icons.check_circle_rounded : Icons.circle_outlined,
                                color: _isEatingOut ? const Color(0xFFE65100) : AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nameCtrl.text.trim().isEmpty ? null : _save,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
                          child: const Text('Salva'),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Tab 2: ingredienti ─────────────────────────────
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Cerca alimento…',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                                  setState(() { _searchCtrl.clear(); _searchResults = []; });
                                })
                              : null,
                        ),
                        onChanged: (q) => setState(() => _searchResults = searchFood(q)),
                      ),
                    ),
                    if (_searchResults.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: _searchResults.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final food = _searchResults[i];
                            return ListTile(
                              dense: true,
                              title: Text(food.name, style: const TextStyle(fontSize: 13)),
                              subtitle: Text('${food.kcalPer100g.round()} kcal/100g · ${food.category}',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              trailing: const Icon(Icons.add_circle_outline, color: AppColors.mintDark),
                              onTap: () => _addIngredient(food),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _ingredients.isEmpty
                          ? Center(
                              child: Text('Cerca e aggiungi ingredienti\nper calcolare le kcal automaticamente',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _ingredients.length,
                              itemBuilder: (_, i) {
                                final ing = _ingredients[i];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.mint.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(ing.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                            Text('${ing.grams.round()}g · ${ing.kcal} kcal',
                                              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close_rounded, size: 18),
                                        color: AppColors.textSecondary,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => setState(() => _ingredients.removeAt(i)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    if (_ingredients.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nameCtrl.text.trim().isEmpty ? null : _save,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
                            child: Text('Salva · $_computedKcal kcal'),
                          ),
                        ),
                      ),
                  ],
                ),

                // ── Tab 3: barcode ─────────────────────────────────
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inserisci il codice a barre del prodotto',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Trovi il barcode sulla confezione del prodotto. '
                        'Cerca su Open Food Facts — database con milioni di prodotti.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _barcodeCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Es. 8076809513388',
                                prefixIcon: const Icon(Icons.barcode_reader),
                                errorText: _barcodeError,
                              ),
                              onSubmitted: (_) => _lookupBarcode(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _barcodeLoading ? null : _lookupBarcode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mintDark,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: _barcodeLoading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.search_rounded, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (kIsWeb)
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _startCameraScanner,
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text('Scansiona con la camera'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.mintDark,
                              side: const BorderSide(color: AppColors.mintDark),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Come trovare il barcode', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            Text('• Le cifre sotto le barre verticali sulla confezione\n'
                                 '• Di solito 8, 12 o 13 cifre\n'
                                 '• Prodotti italiani iniziano spesso con 80',
                                 style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.6)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startCameraScanner() {
    if (!kIsWeb) return;
    js.context.callMethod('startBarcodeScanner', [
      js.allowInterop((String code) {
        if (!mounted) return;
        setState(() => _barcodeCtrl.text = code);
        _lookupBarcode();
      }),
    ]);
  }

  Future<void> _lookupBarcode() async {
    final code = _barcodeCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() { _barcodeLoading = true; _barcodeError = null; });

    final result = await OpenFoodFactsService.lookup(code);
    if (!mounted) return;

    if (result == null) {
      setState(() { _barcodeLoading = false; _barcodeError = 'Prodotto non trovato. Prova con il codice completo.'; });
      return;
    }

    // prefill name if empty
    if (_nameCtrl.text.isEmpty) _nameCtrl.text = result.displayName;

    setState(() { _barcodeLoading = false; _barcodeError = null; });

    // Ask for grams then add
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) {
        final gramsCtrl = TextEditingController(text: '100');
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(result.name, style: const TextStyle(fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.brand.isNotEmpty)
                Text(result.brand, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoChip('${result.kcalPer100g.round()} kcal'),
                  _InfoChip('P ${result.proteinPer100g.round()}g'),
                  _InfoChip('C ${result.carbsPer100g.round()}g'),
                  _InfoChip('G ${result.fatPer100g.round()}g'),
                ],
              ),
              const SizedBox(height: 2),
              Text('per 100g', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              TextField(
                controller: gramsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Grammi da aggiungere', suffixText: 'g'),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla')),
            ElevatedButton(
              onPressed: () {
                final g = double.tryParse(gramsCtrl.text) ?? 100;
                setState(() {
                  _ingredients.add(Ingredient(
                    name: result.displayName,
                    grams: g,
                    kcalPer100g: result.kcalPer100g,
                    proteinPer100g: result.proteinPer100g,
                    carbsPer100g: result.carbsPer100g,
                    fatPer100g: result.fatPer100g,
                  ));
                  _barcodeCtrl.clear();
                });
                Navigator.pop(ctx);
                _tabCtrl.animateTo(1); // go to ingredients tab
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  const _InfoChip(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.mintDark)),
  );
}
