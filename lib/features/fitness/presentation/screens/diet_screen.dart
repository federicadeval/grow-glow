import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/profile/data/profile_provider.dart';
import '../../data/calorie_provider.dart';
import '../../data/meal_plan_provider.dart';
import '../../domain/models/meal_plan_model.dart';

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
        title: const Text('Dieta 🥗'),
        actions: [
          TextButton.icon(
            onPressed: () => _confirmGenerate(context, ref),
            icon: const Text('✨', style: TextStyle(fontSize: 16)),
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
                _KcalPill('🎯', 'Obiettivo', '$targetKcal'),
                _KcalPill('🍽️', 'Consumate', '${calories.consumedKcal}'),
                _KcalPill('🏋️', 'Bruciate', '${calories.burnedKcal}'),
                _KcalPill('✅', 'Rimanenti',
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
        title: const Text('✨ Genera piano settimanale'),
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
  final String emoji;
  final String label;
  final String value;
  const _KcalPill(this.emoji, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$emoji $value', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isEmpty = meal.isEmpty;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEmpty ? AppColors.mint.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: isEmpty
              ? Border.all(color: AppColors.mintDark.withValues(alpha: 0.25), style: BorderStyle.solid)
              : null,
        ),
        child: Row(
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(type.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      if (meal.isEatingOut) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE0B2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('🍽️ fuori', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFFE65100))),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (isEmpty)
                    Text('Tocca per aggiungere', style: TextStyle(fontSize: 13, color: AppColors.mintDark.withValues(alpha: 0.7)))
                  else ...[
                    Text(meal.name, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    if (meal.notes.isNotEmpty)
                      Text(meal.notes, style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withValues(alpha: 0.7))),
                    const SizedBox(height: 4),
                    Text('${meal.kcal} kcal',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.mintDark)),
                  ],
                ],
              ),
            ),
            if (!isEmpty && onClear != null)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MealEditSheet extends StatefulWidget {
  final MealType type;
  final MealEntry current;
  final void Function(MealEntry) onSave;

  const _MealEditSheet({required this.type, required this.current, required this.onSave});

  @override
  State<_MealEditSheet> createState() => _MealEditSheetState();
}

class _MealEditSheetState extends State<_MealEditSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _kcalCtrl;
  late final TextEditingController _notesCtrl;
  late bool _isEatingOut;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.current.name);
    _kcalCtrl = TextEditingController(text: widget.current.kcal > 0 ? '${widget.current.kcal}' : '');
    _notesCtrl = TextEditingController(text: widget.current.notes);
    _isEatingOut = widget.current.isEatingOut;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final kcal = int.tryParse(_kcalCtrl.text) ?? 0;
    widget.onSave(MealEntry(
      name: name,
      kcal: kcal,
      notes: _notesCtrl.text.trim(),
      isEatingOut: _isEatingOut,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.type.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(widget.type.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Cosa mangi?', hintText: 'Es. Pasta al pomodoro'),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _kcalCtrl,
            decoration: const InputDecoration(labelText: 'Kcal (opzionale)', suffixText: 'kcal'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            decoration: const InputDecoration(labelText: 'Note (opzionale)', hintText: 'Es. senza sale, con olio EVO'),
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
                border: Border.all(
                  color: _isEatingOut ? const Color(0xFFE65100) : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  const Text('🍽️', style: TextStyle(fontSize: 20)),
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
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mintDark),
              child: const Text('Salva'),
            ),
          ),
        ],
      ),
    );
  }
}
