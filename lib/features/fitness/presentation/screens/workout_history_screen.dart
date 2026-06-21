import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/workout_history_provider.dart';
import '../../domain/models/workout_session_model.dart';

// ─── Helpers ──────────────────────────────────────────────────

const _weekdays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
const _months = [
  'gen', 'feb', 'mar', 'apr', 'mag', 'giu',
  'lug', 'ago', 'set', 'ott', 'nov', 'dic'
];

String _formatDate(DateTime d) =>
    '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]}';

String _formatShortDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String _fatigueStars(int fatigue) =>
    '${'★' * fatigue}${'☆' * (5 - fatigue)}';

String _moodEmoji(String mood) {
  switch (mood) {
    case 'bad':
      return '😞';
    case 'neutral':
      return '😐';
    case 'good':
      return '🙂';
    case 'great':
      return '😄';
    default:
      return '😐';
  }
}

String _loadFeelLabel(String loadFeel) {
  switch (loadFeel) {
    case 'tooLight':
      return 'Carico leggero';
    case 'justRight':
      return 'Carico ok';
    case 'tooHeavy':
      return 'Carico pesante';
    default:
      return loadFeel;
  }
}

IconData _workoutIcon(String workoutId) {
  switch (workoutId) {
    case 'full_body_a':
      return Icons.fitness_center_rounded;
    case 'full_body_b':
      return Icons.local_fire_department_rounded;
    case 'full_body_c':
      return Icons.spa_rounded;
    default:
      return Icons.fitness_center_rounded;
  }
}

/// Parse a weight string to a numeric double.
/// For ranges like "15-20 kg" or "4-5 kg/lato" takes the last (upper) number.
double? _parseWeightValue(String weight) {
  final matches = RegExp(r'(\d+(?:\.\d+)?)').allMatches(weight).toList();
  if (matches.isEmpty) return null;
  return double.tryParse(matches.last.group(1)!);
}

// ─── Main screen ──────────────────────────────────────────────

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(workoutHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Storico allenamenti')),
      body: sessions.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history_rounded, size: 72, color: AppColors.divider),
                    const SizedBox(height: 16),
                    const Text(
                      'Nessuna sessione ancora. Completa il tuo primo allenamento!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sessions.length >= 2) ...[
                    Text('Il tuo andamento',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _WeeklySessionsChart(sessions: sessions),
                    const SizedBox(height: 16),
                    _FatigueChart(sessions: sessions),
                    const SizedBox(height: 16),
                    _WeightProgressChart(sessions: sessions),
                    const SizedBox(height: 28),
                  ],
                  Text('Sessioni (${sessions.length})',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...sessions.reversed.map((s) => _SessionCard(session: s)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ─── Chart: Sessioni settimanali ─────────────────────────────

class _WeeklySessionsChart extends StatelessWidget {
  final List<WorkoutSession> sessions;
  const _WeeklySessionsChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Build last 8 weeks (oldest first)
    final weeks = List.generate(8, (i) {
      final start = now.subtract(Duration(days: (7 - i) * 7 + now.weekday - 1));
      final weekStart = DateTime(start.year, start.month, start.day);
      final weekEnd = weekStart.add(const Duration(days: 7));
      final count = sessions.where((s) {
        final d = DateTime(s.date.year, s.date.month, s.date.day);
        return !d.isBefore(weekStart) && d.isBefore(weekEnd);
      }).length;
      return (weekStart: weekStart, count: count);
    });

    final maxY = (weeks.map((w) => w.count).reduce((a, b) => a > b ? a : b) + 1).toDouble();

    return _ChartCard(
      title: 'Sessioni a settimana',
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            maxY: maxY,
            minY: 0,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                  '${rod.toY.toInt()} sess.',
                  const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    if (value == value.floorToDouble() && value >= 0) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= weeks.length) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _formatShortDate(weeks[i].weekStart),
                        style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.divider,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(weeks.length, (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: weeks[i].count.toDouble(),
                  color: AppColors.peachDark,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

// ─── Chart: Fatica nel tempo ──────────────────────────────────

class _FatigueChart extends StatelessWidget {
  final List<WorkoutSession> sessions;
  const _FatigueChart({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final sorted = [...sessions]..sort((a, b) => a.date.compareTo(b.date));
    final spots = List.generate(
      sorted.length,
      (i) => FlSpot(i.toDouble(), sorted[i].fatigue.toDouble()),
    );

    return _ChartCard(
      title: 'Fatica percepita',
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColors.lavenderDark,
                barWidth: 2.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.lavenderDark,
                    strokeWidth: 0,
                    strokeColor: Colors.transparent,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.lavenderDark.withValues(alpha: 0.08),
                ),
              ),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    if (value == value.floorToDouble() && value >= 1 && value <= 5) {
                      return Text(value.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= sorted.length) return const SizedBox.shrink();
                    // Show only every other label to avoid crowding
                    if (sorted.length > 4 && i % 2 != 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _formatShortDate(sorted[i].date),
                        style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.divider,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}

// ─── Chart: Progressione peso per esercizio ───────────────────

class _WeightProgressChart extends StatefulWidget {
  final List<WorkoutSession> sessions;
  const _WeightProgressChart({required this.sessions});

  @override
  State<_WeightProgressChart> createState() => _WeightProgressChartState();
}

class _WeightProgressChartState extends State<_WeightProgressChart> {
  late String _selectedExercise;
  late List<String> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = _collectExercises();
    _selectedExercise = _exercises.isNotEmpty ? _exercises.first : '';
  }

  List<String> _collectExercises() {
    final names = <String>{};
    for (final s in widget.sessions) {
      names.addAll(s.weights.keys);
    }
    return names.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    if (_exercises.isEmpty) return const SizedBox.shrink();

    final relevant = [...widget.sessions]
        .where((s) => s.weights.containsKey(_selectedExercise))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = <FlSpot>[];
    for (var i = 0; i < relevant.length; i++) {
      final val = _parseWeightValue(relevant[i].weights[_selectedExercise]!);
      if (val != null) spots.add(FlSpot(i.toDouble(), val));
    }

    final maxY = spots.isEmpty
        ? 10.0
        : (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 5).ceilToDouble();

    return _ChartCard(
      title: 'Peso per esercizio',
      headerExtra: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: _selectedExercise,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
          ),
          items: _exercises
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: (v) {
            if (v != null) setState(() => _selectedExercise = v);
          },
        ),
      ),
      child: spots.length < 2
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'Servono almeno 2 sessioni per questo esercizio',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      color: AppColors.mintDark,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.mintDark,
                          strokeWidth: 0,
                          strokeColor: Colors.transparent,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.mintDark.withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          if (value == value.floorToDouble() && value >= 0) {
                            return Text('${value.toInt()} kg',
                                style: const TextStyle(fontSize: 9, color: AppColors.textSecondary));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= relevant.length) return const SizedBox.shrink();
                          if (relevant.length > 4 && i % 2 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _formatShortDate(relevant[i].date),
                              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
    );
  }
}

// ─── Chart card wrapper ───────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? headerExtra;
  const _ChartCard({required this.title, required this.child, this.headerExtra});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.divider.withValues(alpha: 0.6),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          if (headerExtra != null) headerExtra!,
          child,
        ],
      ),
    );
  }
}

// ─── Session card ─────────────────────────────────────────────

class _SessionCard extends StatefulWidget {
  final WorkoutSession session;
  const _SessionCard({required this.session});

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final icon = _workoutIcon(s.workoutId);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.divider.withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.fitness,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 22, color: AppColors.fitnessDark),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.workoutName,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(
                            '${_formatDate(s.date)}  ·  ${_fatigueStars(s.fatigue)}  ·  ${_moodEmoji(s.mood)}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              // Expandable body
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: AppColors.divider, height: 1),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Exercise weights
                                const Text('Esercizi',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary)),
                                const SizedBox(height: 8),
                                ...s.weights.entries.map((e) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(e.key,
                                                style: const TextStyle(
                                                    fontSize: 13, color: AppColors.textPrimary)),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: AppColors.peach,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(e.value,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.peachDark)),
                                          ),
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 12),
                                // Chips row
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _InfoChip(
                                      label: _loadFeelLabel(s.loadFeel),
                                      color: AppColors.lavenderDark,
                                      bgColor: AppColors.lavender,
                                    ),
                                    _InfoChip(
                                      label: '${_moodEmoji(s.mood)} ${_moodLabel(s.mood)}',
                                      color: AppColors.mintDark,
                                      bgColor: AppColors.mint,
                                    ),
                                    _InfoChip(
                                      label: '${s.estimatedKcal} kcal',
                                      color: AppColors.peachDark,
                                      bgColor: AppColors.peach,
                                    ),
                                  ],
                                ),
                                // Joint pain warning
                                if (s.jointPain) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.blush,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.warning_rounded,
                                            size: 16, color: AppColors.blushDark),
                                        SizedBox(width: 6),
                                        Text('Dolori articolari segnalati',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.blushDark,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _moodLabel(String mood) {
    switch (mood) {
      case 'bad':
        return 'Male';
      case 'neutral':
        return 'Normale';
      case 'good':
        return 'Bene';
      case 'great':
        return 'Ottimo';
      default:
        return mood;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  const _InfoChip({required this.label, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
