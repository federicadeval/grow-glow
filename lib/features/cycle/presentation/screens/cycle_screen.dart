import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_banner.dart';
import '../../data/cycle_provider.dart';
import '../../data/symptom_provider.dart';
import '../../domain/cycle_entry.dart';
import '../../domain/symptom.dart';

class CycleScreen extends ConsumerWidget {
  const CycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycle = ref.watch(cycleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBanner(
                icon: Icons.water_drop_rounded,
                title: 'Ciclo',
                subtitle: 'Fasi, previsioni e calendario mensile',
                bgColor: Color(0xFFF2C4CE),
                fgColor: Color(0xFF8B2040),
              ),
              const SizedBox(height: 24),

              if (cycle.lastPeriodDate == null)
                _EmptyState()
              else ...[
                _PhaseStatusCard(cycle: cycle),
                const SizedBox(height: 14),
                _InfoRow(cycle: cycle),
                const SizedBox(height: 14),
                _PhaseBar(cycle: cycle),
                const SizedBox(height: 14),
                _MonthCalendar(cycle: cycle),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF2C4CE).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF2C4CE)),
      ),
      child: Column(
        children: [
          const Text('🌸', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          const Text('Nessun dato ancora',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Vai al Profilo e inserisci la data\ndell\'ultima mestruazione per iniziare.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B2040),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Vai al Profilo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Phase status card ─────────────────────────────────────────

class _PhaseStatusCard extends StatelessWidget {
  final CycleState cycle;
  const _PhaseStatusCard({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final phase = cycle.currentPhase!;
    final day = cycle.currentCycleDay!;
    final daysLeft = cycle.daysToNextPeriod!;
    final next = cycle.nextPeriodDate!;
    const mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu',
                   'lug', 'ago', 'set', 'ott', 'nov', 'dic'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: phase.color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: phase.color),
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: phase.color, shape: BoxShape.circle),
            child: Center(child: Text(phase.emoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phase.label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: phase.darkColor),
                ),
                Text('Giorno $day del ciclo',
                  style: TextStyle(fontSize: 13, color: phase.darkColor.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 3),
                Text(phase.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$daysLeft gg',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: phase.darkColor),
              ),
              Text('al prossimo', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
              Text('${next.day} ${mesi[next.month - 1]}',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: phase.darkColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Info row (fertile + ovulation) ───────────────────────────

class _InfoRow extends StatelessWidget {
  final CycleState cycle;
  const _InfoRow({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final fertile = cycle.isInFertileWindow;
    final ovulation = cycle.ovulationDate;
    const mesi = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu',
                   'lug', 'ago', 'set', 'ott', 'nov', 'dic'];

    return Row(
      children: [
        Expanded(
          child: _InfoChip(
            icon: Icons.favorite_rounded,
            label: 'Finestra fertile',
            value: fertile ? 'Questa settimana' : 'Non ora',
            color: fertile ? const Color(0xFFE8B4BC) : AppColors.divider,
            darkColor: fertile ? const Color(0xFF8B2040) : AppColors.textSecondary,
          ),
        ),
        if (ovulation != null) ...[
          const SizedBox(width: 10),
          Expanded(
            child: _InfoChip(
              icon: Icons.star_rounded,
              label: 'Ovulazione',
              value: '${ovulation.day} ${mesi[ovulation.month - 1]}',
              color: const Color(0xFFFFE08A),
              darkColor: const Color(0xFF7A5A00),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color darkColor;
  const _InfoChip({
    required this.icon, required this.label, required this.value,
    required this.color, required this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: darkColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: TextStyle(fontSize: 10, color: darkColor.withValues(alpha: 0.7)),
                ),
                Text(value,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: darkColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Phase bar ─────────────────────────────────────────────────

class _PhaseBar extends StatelessWidget {
  final CycleState cycle;
  const _PhaseBar({required this.cycle});

  @override
  Widget build(BuildContext context) {
    final currentDay = cycle.currentCycleDay!;
    final total = cycle.cycleLength;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: CyclePhase.values.map((phase) {
              final days = phase.daysCount(cycle.cycleLength, cycle.periodLength);
              return Expanded(
                flex: days,
                child: Container(height: 14, color: phase.color),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        LayoutBuilder(builder: (context, constraints) {
          final x = ((currentDay - 1) / total) * constraints.maxWidth;
          return Stack(
            children: [
              const SizedBox(height: 8, width: double.infinity),
              Positioned(
                left: x.clamp(0, constraints.maxWidth - 2),
                child: Container(
                  width: 2, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 4),
        Row(
          children: CyclePhase.values.map((phase) {
            final days = phase.daysCount(cycle.cycleLength, cycle.periodLength);
            return Expanded(
              flex: days,
              child: Text(phase.label,
                style: TextStyle(fontSize: 10, color: phase.darkColor, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Month calendar (navigable, tappable for symptoms) ─────────

class _MonthCalendar extends ConsumerStatefulWidget {
  final CycleState cycle;
  const _MonthCalendar({required this.cycle});

  @override
  ConsumerState<_MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends ConsumerState<_MonthCalendar> {
  late DateTime _month;

  static const _headers = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
  static const _mesiLong = [
    'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
    'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _prevMonth() => setState(
      () => _month = DateTime(_month.year, _month.month - 1));

  void _nextMonth() => setState(
      () => _month = DateTime(_month.year, _month.month + 1));

  void _openSymptomSheet(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SymptomSheet(date: date, cycle: widget.cycle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symptoms = ref.watch(symptomProvider);
    final now = DateTime.now();
    final firstDay = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final startWeekday = firstDay.weekday;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_left_rounded,
                      size: 22, color: AppColors.textSecondary),
                ),
              ),
              Text(
                '${_mesiLong[_month.month - 1]} ${_month.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_right_rounded,
                      size: 22, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            children: _headers.map((h) => Expanded(
              child: Center(
                child: Text(h,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Day grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: daysInMonth + (startWeekday - 1),
            itemBuilder: (context, i) {
              if (i < startWeekday - 1) return const SizedBox.shrink();
              final day = i - (startWeekday - 1) + 1;
              final date = DateTime(_month.year, _month.month, day);
              final phase = widget.cycle.phaseForDate(date);
              final isToday = date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              final dateKey =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              final hasSymptoms = (symptoms[dateKey] ?? {}).isNotEmpty;

              return GestureDetector(
                onTap: () => _openSymptomSheet(context, date),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: phase?.color.withValues(alpha: 0.6) ??
                            Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(
                                color: AppColors.textPrimary, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isToday
                                ? FontWeight.w800
                                : FontWeight.normal,
                            color: phase != null
                                ? phase.darkColor
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasSymptoms
                            ? (phase?.darkColor ?? const Color(0xFF8B2040))
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Phase legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: CyclePhase.values.map((p) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10, height: 10,
                  decoration:
                      BoxDecoration(color: p.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(p.label,
                  style:
                      const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Symptom bottom sheet ──────────────────────────────────────

class _SymptomSheet extends ConsumerWidget {
  final DateTime date;
  final CycleState cycle;

  const _SymptomSheet({required this.date, required this.cycle});

  static const _mesi = [
    'gen', 'feb', 'mar', 'apr', 'mag', 'giu',
    'lug', 'ago', 'set', 'ott', 'nov', 'dic',
  ];

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symptoms = ref.watch(symptomProvider);
    final selected = symptoms[_dateKey(date)] ?? {};
    final phase = cycle.phaseForDate(date);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header row: date + phase pill
          Row(
            children: [
              Text(
                '${date.day} ${_mesi[date.month - 1]}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              if (phase != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: phase.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${phase.emoji} ${phase.label}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: phase.darkColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Come stai? Seleziona i sintomi',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          // Symptom grid — 3 columns
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.15,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: CycleSymptom.values.length,
            itemBuilder: (context, i) {
              final symptom = CycleSymptom.values[i];
              final isSelected = selected.contains(symptom);
              return GestureDetector(
                onTap: () =>
                    ref.read(symptomProvider.notifier).toggle(date, symptom),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF2C4CE)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF8B2040)
                          : AppColors.divider,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(symptom.emoji,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(
                        symptom.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF8B2040)
                              : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
