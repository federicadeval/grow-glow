import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/section_banner.dart';
import '../../data/cycle_provider.dart';
import '../../domain/cycle_entry.dart';

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

// ── Month calendar ────────────────────────────────────────────

class _MonthCalendar extends StatelessWidget {
  final CycleState cycle;
  const _MonthCalendar({required this.cycle});

  static const _headers = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];
  static const _mesiLong = [
    'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
    'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
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
          Text('${_mesiLong[now.month - 1]} ${now.year}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: daysInMonth + (startWeekday - 1),
            itemBuilder: (context, i) {
              if (i < startWeekday - 1) return const SizedBox.shrink();
              final day = i - (startWeekday - 1) + 1;
              final date = DateTime(now.year, now.month, day);
              final phase = cycle.phaseForDate(date);
              final isToday = day == now.day;
              return Container(
                decoration: BoxDecoration(
                  color: phase?.color.withValues(alpha: 0.6) ?? Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday
                      ? Border.all(color: AppColors.textPrimary, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text('$day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.normal,
                      color: phase != null ? phase.darkColor : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: CyclePhase.values.map((p) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                Text(p.label,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}
