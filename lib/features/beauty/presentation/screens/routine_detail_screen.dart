import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'beauty_screen.dart';

class RoutineDetailScreen extends StatefulWidget {
  final String routineId;
  const RoutineDetailScreen({super.key, required this.routineId});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  late List<bool> _completed;

  RoutineId get _routineId {
    switch (widget.routineId) {
      case 'morning_standard': return RoutineId.morningStandard;
      case 'morning_saturday': return RoutineId.morningSaturday;
      case 'evening_retinal': return RoutineId.eveningRetinal;
      case 'evening_buenos_aires': return RoutineId.eveningBuenosAires;
      case 'evening_sunday': return RoutineId.eveningSunday;
      // legacy IDs
      case 'morning': return RoutineId.morningStandard;
      case 'evening': return RoutineId.eveningRetinal;
      default: return RoutineId.morningStandard;
    }
  }

  List<RoutineStep> get _steps => _routineId.steps;

  bool get _allDone => _completed.isNotEmpty && _completed.every((c) => c);

  @override
  void initState() {
    super.initState();
    _initCompleted();
  }

  @override
  void didUpdateWidget(RoutineDetailScreen old) {
    super.didUpdateWidget(old);
    if (old.routineId != widget.routineId) _initCompleted();
  }

  void _initCompleted() {
    _completed = List<bool>.filled(_steps.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_routineId.label)),
      body: Column(
        children: [
          // Barra progresso
          _ProgressHeader(done: _completed.where((c) => c).length, total: _steps.length),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  if (_allDone) _CompletedBanner(),
                  const SizedBox(height: 4),
                  ...List.generate(_steps.length, (i) => _StepTile(
                    step: _steps[i],
                    index: i + 1,
                    isCompleted: _completed[i],
                    onToggle: () => setState(() => _completed[i] = !_completed[i]),
                  )),
                ],
              ),
            ),
          ),

          if (!_allDone)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      for (int i = 0; i < _completed.length; i++) {
                        _completed[i] = true;
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.beautyDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Segna tutto come fatto ✓',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int done;
  final int total;
  const _ProgressHeader({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? done / total : 0.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$done / $total step completati',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.beautyDark,
                ),
              ),
              Text('${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.beautyDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.beauty.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.beautyDark),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.beauty, AppColors.blush],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text('Routine completata!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.beautyDark,
            ),
          ),
          const SizedBox(height: 4),
          Text('La tua pelle ti ringrazierà ✨',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.beautyDark.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final RoutineStep step;
  final int index;
  final bool isCompleted;
  final VoidCallback onToggle;

  const _StepTile({
    required this.step,
    required this.index,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.beauty : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isCompleted ? null : [
            BoxShadow(
              color: AppColors.lavender.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Numero / check
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.beautyDark : AppColors.beauty,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : Center(
                    child: Text('$index',
                      style: const TextStyle(
                        color: AppColors.beautyDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 12),
            Text(step.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted
                        ? AppColors.beautyDark.withValues(alpha: 0.6)
                        : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(step.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
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
