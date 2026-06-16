import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/workout_model.dart';
import '../../data/calorie_provider.dart';
import 'workout_feedback_screen.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  final WorkoutPlan workout;
  const WorkoutSessionScreen({super.key, required this.workout});

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  int _exerciseIndex = 0;
  int _setIndex = 0;

  // [exerciseIndex][setIndex] = completato
  late List<List<bool>> _completed;

  // Timer riposo
  bool _isResting = false;
  int _restSecondsLeft = 0;
  Timer? _restTimer;

  // Timer sessione
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;

  @override
  void initState() {
    super.initState();
    _completed = widget.workout.exercises
        .map((e) => List<bool>.filled(e.sets, false))
        .toList();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  Exercise get _currentExercise =>
      widget.workout.exercises[_exerciseIndex];

  String get _elapsedFormatted {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _completeSet() {
    setState(() {
      _completed[_exerciseIndex][_setIndex] = true;
    });

    final isLastSet = _setIndex == _currentExercise.sets - 1;
    final isLastExercise = _exerciseIndex == widget.workout.exercises.length - 1;

    if (isLastSet && isLastExercise) {
      // Sessione completata
      _restTimer?.cancel();
      setState(() => _isResting = false);
      _showCompletionDialog();
      return;
    }

    // Avvia timer riposo
    _startRest(_currentExercise.restSeconds, () {
      setState(() {
        if (isLastSet) {
          _exerciseIndex++;
          _setIndex = 0;
        } else {
          _setIndex++;
        }
      });
    });
  }

  void _startRest(int seconds, VoidCallback onComplete) {
    setState(() {
      _isResting = true;
      _restSecondsLeft = seconds;
    });
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _restSecondsLeft--);
      if (_restSecondsLeft <= 0) {
        t.cancel();
        setState(() => _isResting = false);
        onComplete();
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
      final isLastSet = _setIndex == _currentExercise.sets - 1;
      if (isLastSet) {
        _exerciseIndex++;
        _setIndex = 0;
      } else {
        _setIndex++;
      }
    });
  }

  void _showCompletionDialog() {
    ref.read(calorieProvider.notifier).addBurned(widget.workout.estimatedKcal);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CompletionDialog(
        workout: widget.workout,
        elapsedSeconds: _elapsedSeconds,
      ),
    );
  }

  void _confirmQuit() {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    final doneSets = _completed.fold(0, (s, sets) => s + sets.where((d) => d).length);
    final totalSets = widget.workout.exercises.fold(0, (s, e) => s + e.sets);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Interrompere la sessione?'),
        content: Text(
          'Hai completato $doneSets set su $totalSets.\nCosa vuoi fare?',
        ),
        actions: [
          // Continua
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // riprendi i timer
              _sessionTimer = Timer.periodic(
                const Duration(seconds: 1),
                (_) => setState(() => _elapsedSeconds++),
              );
            },
            child: const Text('Continua'),
          ),
          // Termina e vedi riepilogo
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final partialKcal = totalSets > 0
                  ? (widget.workout.estimatedKcal * doneSets / totalSets).round()
                  : 0;
              ref.read(calorieProvider.notifier).addBurned(partialKcal);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => _CompletionDialog(
                  workout: widget.workout,
                  elapsedSeconds: _elapsedSeconds,
                  isPartial: true,
                  doneSets: doneSets,
                  totalSets: totalSets,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.peachDark,
            ),
            child: const Text('Termina sessione'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _currentExercise;
    final totalSets = widget.workout.exercises.fold(0, (s, e) => s + e.sets);
    final doneSets = _completed.fold(0, (s, sets) => s + sets.where((d) => d).length);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _confirmQuit,
          ),
          title: Text(widget.workout.name),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(_elapsedFormatted,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.peachDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress bar globale
            _GlobalProgress(done: doneSets, total: totalSets),

            Expanded(
              child: _isResting
                  ? _RestView(
                      secondsLeft: _restSecondsLeft,
                      totalSeconds: exercise.restSeconds,
                      nextLabel: _setIndex < exercise.sets - 1
                          ? 'Set ${_setIndex + 2} di ${exercise.sets}'
                          : _exerciseIndex < widget.workout.exercises.length - 1
                              ? widget.workout.exercises[_exerciseIndex + 1].name
                              : 'Ultimo esercizio!',
                      onSkip: _skipRest,
                    )
                  : _ExerciseView(
                      exercise: exercise,
                      exerciseIndex: _exerciseIndex,
                      totalExercises: widget.workout.exercises.length,
                      currentSet: _setIndex,
                      completedSets: _completed[_exerciseIndex],
                      onComplete: _completeSet,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Progress bar globale ────────────────────────────────────
class _GlobalProgress extends StatelessWidget {
  final int done;
  final int total;
  const _GlobalProgress({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progresso sessione',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text('$done / $total set',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.peachDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              backgroundColor: AppColors.peach.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.peachDark),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vista esercizio ─────────────────────────────────────────
class _ExerciseView extends StatelessWidget {
  final Exercise exercise;
  final int exerciseIndex;
  final int totalExercises;
  final int currentSet;
  final List<bool> completedSets;
  final VoidCallback onComplete;

  const _ExerciseView({
    required this.exercise,
    required this.exerciseIndex,
    required this.totalExercises,
    required this.currentSet,
    required this.completedSets,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Indicatore esercizio
          Text('Esercizio ${exerciseIndex + 1} di $totalExercises',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(exercise.name,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: AppColors.peachDark,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Info esercizio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoChip(icon: Icons.repeat_rounded, label: '${exercise.reps} rip'),
              _InfoChip(icon: Icons.monitor_weight_outlined, label: exercise.weight),
              _InfoChip(
                icon: Icons.timer_outlined,
                label: '${exercise.restSeconds ~/ 60}:${(exercise.restSeconds % 60).toString().padLeft(2, '0')} riposo',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Set tracker
          Text('Set ${currentSet + 1} di ${exercise.sets}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(exercise.sets, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: completedSets[i]
                    ? AppColors.peachDark
                    : i == currentSet
                        ? AppColors.peach
                        : AppColors.divider,
                shape: BoxShape.circle,
                border: i == currentSet && !completedSets[i]
                    ? Border.all(color: AppColors.peachDark, width: 2)
                    : null,
              ),
              child: completedSets[i]
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                  : Center(
                      child: Text('${i + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: i == currentSet
                              ? AppColors.peachDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
            )),
          ),
          const SizedBox(height: 40),

          // Bottone completa set
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.peachDark,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.check_rounded, size: 24),
              label: Text(
                currentSet == exercise.sets - 1 &&
                    exerciseIndex == totalExercises - 1
                    ? 'Completa sessione!'
                    : 'Set completato ✓',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.peachDark, size: 20),
          const SizedBox(height: 4),
          Text(label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.peachDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Vista riposo ─────────────────────────────────────────────
class _RestView extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;
  final String nextLabel;
  final VoidCallback onSkip;

  const _RestView({
    required this.secondsLeft,
    required this.totalSeconds,
    required this.nextLabel,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds == 0 ? 0.0 : secondsLeft / totalSeconds;
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💤', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('Riposo',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Countdown circolare
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: AppColors.peach.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        secondsLeft <= 5 ? AppColors.blushDark : AppColors.peachDark,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: secondsLeft <= 5
                              ? AppColors.blushDark
                              : AppColors.peachDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text('Prossimo: $nextLabel',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: onSkip,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.peachDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Salta riposo',
                style: TextStyle(color: AppColors.peachDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dialog completamento ────────────────────────────────────
class _CompletionDialog extends StatelessWidget {
  final WorkoutPlan workout;
  final int elapsedSeconds;
  final bool isPartial;
  final int? doneSets;
  final int? totalSets;

  const _CompletionDialog({
    required this.workout,
    required this.elapsedSeconds,
    this.isPartial = false,
    this.doneSets,
    this.totalSets,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = elapsedSeconds ~/ 60;
    final kcal = isPartial && totalSets != null && doneSets != null
        ? (workout.estimatedKcal * doneSets! / totalSets!).round()
        : workout.estimatedKcal;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isPartial ? Icons.fitness_center_rounded : Icons.celebration_rounded, size: 56, color: AppColors.peachDark),
            const SizedBox(height: 12),
            Text(isPartial ? 'Sessione terminata!' : 'Sessione completata!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.peachDark,
              ),
              textAlign: TextAlign.center,
            ),
            if (isPartial && doneSets != null && totalSets != null) ...[
              const SizedBox(height: 4),
              Text('$doneSets set su $totalSets completati',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Durata', value: '$minutes min', icon: Icons.timer_rounded),
                _StatItem(
                  label: 'Kcal stimate',
                  value: '~$kcal',
                  icon: Icons.local_fire_department_rounded,
                ),
                _StatItem(
                  label: 'Esercizi',
                  value: '${workout.exercises.length}',
                  icon: Icons.fitness_center_rounded,
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // chiudi dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutFeedbackScreen(workout: workout),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.peachDark,
                ),
                child: const Text('Rispondi al questionario 📋'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Salta e torna alle schede',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.peachDark),
        const SizedBox(height: 4),
        Text(value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.peachDark,
          ),
        ),
        Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
