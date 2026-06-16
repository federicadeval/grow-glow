import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/calorie_provider.dart';

// ─── Modello intervallo ───────────────────────────────────────
enum IntervalType { warmup, run, walk, cooldown }

class C25KInterval {
  final IntervalType type;
  final int seconds;
  const C25KInterval(this.type, this.seconds);
}

extension on IntervalType {
  String get label {
    switch (this) {
      case IntervalType.warmup: return 'Riscaldamento';
      case IntervalType.run: return 'CORRI!';
      case IntervalType.walk: return 'Cammina';
      case IntervalType.cooldown: return 'Defaticamento';
    }
  }

  IconData get icon {
    switch (this) {
      case IntervalType.warmup: return Icons.directions_walk_rounded;
      case IntervalType.run: return Icons.directions_run_rounded;
      case IntervalType.walk: return Icons.directions_walk_rounded;
      case IntervalType.cooldown: return Icons.self_improvement_rounded;
    }
  }

  Color get color {
    switch (this) {
      case IntervalType.warmup: return AppColors.mintDark;
      case IntervalType.run: return AppColors.peachDark;
      case IntervalType.walk: return AppColors.mintDark;
      case IntervalType.cooldown: return AppColors.lavenderDark;
    }
  }

  Color get bgColor {
    switch (this) {
      case IntervalType.warmup: return AppColors.mint;
      case IntervalType.run: return AppColors.fitness;
      case IntervalType.walk: return AppColors.mint;
      case IntervalType.cooldown: return AppColors.lavender;
    }
  }
}

// ─── Programma C25K — 9 settimane × sessione tipo ────────────
// Ogni settimana ha 3 sessioni identiche (o quasi)
// Struttura: riscaldamento 5 min + intervalli + defaticamento 5 min
List<C25KInterval> _buildSession(int weekIndex) {
  final intervals = <C25KInterval>[];
  // Riscaldamento camminata 5 min
  intervals.add(const C25KInterval(IntervalType.warmup, 5 * 60));

  switch (weekIndex) {
    case 0: // W1: 60s corsa / 90s camminata × 8
      for (int i = 0; i < 8; i++) {
        intervals.add(const C25KInterval(IntervalType.run, 60));
        if (i < 7) intervals.add(const C25KInterval(IntervalType.walk, 90));
      }
    case 1: // W2: 90s corsa / 2min camminata × 6
      for (int i = 0; i < 6; i++) {
        intervals.add(const C25KInterval(IntervalType.run, 90));
        if (i < 5) intervals.add(const C25KInterval(IntervalType.walk, 2 * 60));
      }
    case 2: // W3: 90s + 3min + 90s + 3min corsa
      intervals.add(const C25KInterval(IntervalType.run, 90));
      intervals.add(const C25KInterval(IntervalType.walk, 90));
      intervals.add(const C25KInterval(IntervalType.run, 3 * 60));
      intervals.add(const C25KInterval(IntervalType.walk, 3 * 60));
      intervals.add(const C25KInterval(IntervalType.run, 90));
      intervals.add(const C25KInterval(IntervalType.walk, 90));
      intervals.add(const C25KInterval(IntervalType.run, 3 * 60));
    case 3: // W4: 3min + 5min + 3min + 5min
      intervals.add(const C25KInterval(IntervalType.run, 3 * 60));
      intervals.add(const C25KInterval(IntervalType.walk, 90));
      intervals.add(const C25KInterval(IntervalType.run, 5 * 60));
      intervals.add(const C25KInterval(IntervalType.walk, 150));
      intervals.add(const C25KInterval(IntervalType.run, 3 * 60));
      intervals.add(const C25KInterval(IntervalType.walk, 90));
      intervals.add(const C25KInterval(IntervalType.run, 5 * 60));
    case 4: // W5 Sess A: 5+8+5 / Sess C: 20 min continui (usiamo 20 min)
      intervals.add(const C25KInterval(IntervalType.run, 20 * 60));
    case 5: // W6: 25 min continui
      intervals.add(const C25KInterval(IntervalType.run, 25 * 60));
    case 6: // W7: 25-28 min
      intervals.add(const C25KInterval(IntervalType.run, 28 * 60));
    case 7: // W8: 28-30 min
      intervals.add(const C25KInterval(IntervalType.run, 30 * 60));
    case 8: // W9: 30 min = 5K
      intervals.add(const C25KInterval(IntervalType.run, 30 * 60));
  }

  // Defaticamento camminata 5 min
  intervals.add(const C25KInterval(IntervalType.cooldown, 5 * 60));
  return intervals;
}

// ─── Schermata sessione C25K ──────────────────────────────────
class C25KSessionScreen extends ConsumerStatefulWidget {
  final int weekIndex;
  final String weekLabel;

  const C25KSessionScreen({
    super.key,
    required this.weekIndex,
    required this.weekLabel,
  });

  @override
  ConsumerState<C25KSessionScreen> createState() => _C25KSessionScreenState();
}

class _C25KSessionScreenState extends ConsumerState<C25KSessionScreen>
    with TickerProviderStateMixin {
  late final List<C25KInterval> _intervals;
  int _currentIndex = 0;
  int _secondsLeft = 0;
  int _totalElapsed = 0;
  double _kcalBurned = 0;
  bool _isPaused = false;

  Timer? _timer;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _intervals = _buildSession(widget.weekIndex);
    _secondsLeft = _intervals[0].seconds;

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  C25KInterval get _current => _intervals[_currentIndex];

  int get _totalSeconds =>
      _intervals.fold(0, (s, i) => s + i.seconds);

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused) return;
      setState(() {
        _totalElapsed++;
        // kcal/sec: corsa ~7/min, camminata/riscaldamento ~3.5/min
        final rate = _current.type == IntervalType.run ? 7.0 / 60 : 3.5 / 60;
        _kcalBurned += rate;
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _advanceInterval();
        }
      });
    });
  }

  void _advanceInterval() {
    if (_currentIndex < _intervals.length - 1) {
      _currentIndex++;
      _secondsLeft = _intervals[_currentIndex].seconds;
      // Cambia animazione pulse solo durante la corsa
      if (_current.type == IntervalType.run) {
        _pulseCtrl.repeat(reverse: true);
      } else {
        _pulseCtrl.stop();
        _pulseCtrl.value = 0;
      }
    } else {
      _timer?.cancel();
      _showCompletionDialog();
    }
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
  }

  void _skipInterval() {
    setState(() => _advanceInterval());
  }

  void _confirmQuit() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Interrompere la sessione?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (!_isPaused) _startTimer();
            },
            child: const Text('Continua'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blushDark),
            child: const Text('Esci'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        ref.read(calorieProvider.notifier).addBurned(_kcalBurned.round());
        return _C25KCompletionDialog(
          weekLabel: widget.weekLabel,
          isLastWeek: widget.weekIndex == 8,
          elapsedMinutes: _totalElapsed ~/ 60,
          kcalBurned: _kcalBurned.round(),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _current.seconds == 0
        ? 0.0
        : 1.0 - (_secondsLeft / _current.seconds);
    final globalProgress = _totalSeconds == 0
        ? 0.0
        : _totalElapsed / _totalSeconds;

    final isRunning = _current.type == IntervalType.run;
    final nextInterval = _currentIndex < _intervals.length - 1
        ? _intervals[_currentIndex + 1]
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        backgroundColor: _current.type.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _confirmQuit,
          ),
          title: Text(widget.weekLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_formatTime(_totalElapsed),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: _current.type.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${_kcalBurned.round()} kcal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _current.type.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress bar globale
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_currentIndex + 1} / ${_intervals.length} intervalli',
                        style: TextStyle(fontSize: 12, color: _current.type.color),
                      ),
                      Text('${(globalProgress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _current.type.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: globalProgress.clamp(0.0, 1.0),
                      backgroundColor: _current.type.color.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_current.type.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // Contenuto principale
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji animata durante corsa
                      AnimatedBuilder(
                        animation: _pulseCtrl,
                        builder: (_, __) => Transform.scale(
                          scale: isRunning
                              ? 1.0 + (_pulseCtrl.value * 0.15)
                              : 1.0,
                          child: Icon(_current.type.icon,
                            size: 72,
                            color: _current.type.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Label intervallo
                      Text(_current.type.label,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: _current.type.color,
                          letterSpacing: isRunning ? 2 : 0,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Countdown circolare
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: 1.0 - progress,
                                strokeWidth: 12,
                                backgroundColor:
                                    _current.type.color.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    _current.type.color),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_formatTime(_secondsLeft),
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: _current.type.color,
                                  ),
                                ),
                                if (_isPaused)
                                  Text('IN PAUSA',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: _current.type.color,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Prossimo intervallo
                      if (nextInterval != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(nextInterval.type.icon, size: 18, color: _current.type.color),
                              const SizedBox(width: 8),
                              Text(
                                'Prossimo: ${nextInterval.type.label} · ${_formatTime(nextInterval.seconds)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _current.type.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Controlli
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    // Skip
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _skipInterval,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _current.type.color),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(Icons.skip_next_rounded,
                            color: _current.type.color),
                        label: Text('Salta',
                          style: TextStyle(color: _current.type.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Pausa / Riprendi
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _togglePause,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _current.type.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(_isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded),
                        label: Text(_isPaused ? 'Riprendi' : 'Pausa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dialog completamento C25K ────────────────────────────────
class _C25KCompletionDialog extends StatelessWidget {
  final String weekLabel;
  final bool isLastWeek;
  final int elapsedMinutes;
  final int kcalBurned;

  const _C25KCompletionDialog({
    required this.weekLabel,
    required this.isLastWeek,
    required this.elapsedMinutes,
    required this.kcalBurned,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isLastWeek ? Icons.emoji_events_rounded : Icons.celebration_rounded,
              size: 56,
              color: AppColors.mintDark,
            ),
            const SizedBox(height: 12),
            Text(
              isLastWeek ? 'Hai completato i 5K!' : 'Sessione completata!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.mintDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(weekLabel,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Durata', value: '$elapsedMinutes min', icon: Icons.timer_rounded),
                _StatItem(
                  label: 'Kcal bruciate',
                  value: '~$kcalBurned',
                  icon: Icons.local_fire_department_rounded,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mintDark,
                ),
                child: Text(isLastWeek ? 'Sei una runner!' : 'Ottimo lavoro!'),
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
  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: AppColors.mintDark),
        const SizedBox(height: 4),
        Text(value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.mintDark,
          ),
        ),
        Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
