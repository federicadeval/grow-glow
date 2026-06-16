import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ExerciseData {
  final String name;
  final int sets;
  final int reps;
  final double? weightKg;
  ExerciseData({
    required this.name,
    required this.sets,
    required this.reps,
    this.weightKg,
  });
}

class WorkoutDetailScreen extends StatefulWidget {
  final String name;
  final IconData icon;

  const WorkoutDetailScreen({
    super.key,
    required this.name,
    required this.icon,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final List<ExerciseData> _exercises = [];

  void _addExercise() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddExerciseSheet(
        onAdd: (ex) => setState(() => _exercises.add(ex)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.icon, size: 22, color: AppColors.peachDark),
            const SizedBox(width: 8),
            Text(widget.name),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        backgroundColor: AppColors.peachDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Aggiungi esercizio'),
      ),
      body: _exercises.isEmpty
          ? _EmptyState(onAdd: _addExercise)
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: _exercises.length,
              itemBuilder: (context, i) => Dismissible(
                key: ValueKey('${_exercises[i].name}_$i'),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => setState(() => _exercises.removeAt(i)),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.blushDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                ),
                child: _ExerciseCard(exercise: _exercises[i], index: i + 1),
              ),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fitness_center_rounded, size: 56, color: AppColors.peachDark),
          const SizedBox(height: 16),
          Text('Nessun esercizio ancora',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Aggiungi il primo esercizio alla scheda',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.peachDark),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Aggiungi esercizio'),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseData exercise;
  final int index;
  const _ExerciseCard({required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.peach.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.peach,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$index',
                style: const TextStyle(
                  color: AppColors.peachDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(exercise.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            children: [
              _StatBadge(label: '${exercise.sets} serie'),
              const SizedBox(width: 6),
              _StatBadge(label: '${exercise.reps} rip'),
              if (exercise.weightKg != null) ...[
                const SizedBox(width: 6),
                _StatBadge(label: '${exercise.weightKg!.toStringAsFixed(1)} kg'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  const _StatBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.peachDark,
        ),
      ),
    );
  }
}

class _AddExerciseSheet extends StatefulWidget {
  final Function(ExerciseData) onAdd;
  const _AddExerciseSheet({required this.onAdd});

  @override
  State<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<_AddExerciseSheet> {
  final _nameCtrl = TextEditingController();
  final _setsCtrl = TextEditingController(text: '3');
  final _repsCtrl = TextEditingController(text: '10');
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Nuovo esercizio',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nome esercizio',
              hintText: 'es. Panca piana',
              prefixIcon: Icon(Icons.fitness_center_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _setsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Serie',
                    prefixIcon: Icon(Icons.repeat_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _repsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Ripetizioni',
                    prefixIcon: Icon(Icons.loop_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Kg (opz.)',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.trim().isEmpty) return;
                widget.onAdd(ExerciseData(
                  name: _nameCtrl.text.trim(),
                  sets: int.tryParse(_setsCtrl.text) ?? 3,
                  reps: int.tryParse(_repsCtrl.text) ?? 10,
                  weightKg: double.tryParse(_weightCtrl.text),
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.peachDark),
              child: const Text('Aggiungi'),
            ),
          ),
        ],
      ),
    );
  }
}
