import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'routine_detail_screen.dart';
import 'skin_questionnaire_screen.dart';
import 'skin_photos_screen.dart';

// ─── Modello routine ──────────────────────────────────────────
class RoutineStep {
  final String name;
  final String description;
  final String emoji;

  const RoutineStep({
    required this.name,
    required this.description,
    required this.emoji,
  });
}

// ID routine per ogni combinazione giorno/momento
enum RoutineId {
  morningStandard,
  morningSaturday,
  eveningRetinal,
  eveningBuenosAires,
  eveningSunday,
}

extension RoutineIdData on RoutineId {
  String get label {
    switch (this) {
      case RoutineId.morningStandard: return 'Routine Mattina ☀️';
      case RoutineId.morningSaturday: return 'Routine Mattina (Sabato) ☀️';
      case RoutineId.eveningRetinal: return 'Routine Sera 🌙';
      case RoutineId.eveningBuenosAires: return 'Routine Sera (Mercoledì) 🌙';
      case RoutineId.eveningSunday: return 'Routine Sera (Domenica) 🌙';
    }
  }

  String get urlSegment {
    switch (this) {
      case RoutineId.morningStandard: return 'morning_standard';
      case RoutineId.morningSaturday: return 'morning_saturday';
      case RoutineId.eveningRetinal: return 'evening_retinal';
      case RoutineId.eveningBuenosAires: return 'evening_buenos_aires';
      case RoutineId.eveningSunday: return 'evening_sunday';
    }
  }

  List<RoutineStep> get steps {
    switch (this) {
      case RoutineId.morningStandard:
        return _morningStandard;
      case RoutineId.morningSaturday:
        return _morningSaturday;
      case RoutineId.eveningRetinal:
        return _eveningRetinal;
      case RoutineId.eveningBuenosAires:
        return _eveningBuenosAires;
      case RoutineId.eveningSunday:
        return _eveningSunday;
    }
  }
}

// ─── Step lists ───────────────────────────────────────────────
const _morningStandard = [
  RoutineStep(name: 'CeraVe', description: 'Detergente idratante — massaggia sul viso bagnato, risciacqua.', emoji: '🫧'),
  RoutineStep(name: 'Vitamina C', description: 'Siero antiossidante — 2-3 gocce su viso e collo, tampona delicatamente.', emoji: '🌿'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema anti-age L\'Oréal — stendi su tutto il viso.', emoji: '✨'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — morbido strato su viso e collo.', emoji: '💜'),
  RoutineStep(name: 'SPF', description: 'Protezione solare — ultimo step, applica generosamente. Non saltare mai!', emoji: '☀️'),
];

const _morningSaturday = [
  RoutineStep(name: 'CeraVe', description: 'Detergente idratante — massaggia sul viso bagnato, risciacqua.', emoji: '🫧'),
  RoutineStep(name: 'Bahia Blanca', description: 'Peeling/scrub — applica sul viso asciutto, massaggia delicatamente, risciacqua.', emoji: '🌟'),
  RoutineStep(name: 'Vitamina C', description: 'Siero antiossidante — 2-3 gocce su viso e collo, tampona delicatamente.', emoji: '🌿'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema anti-age L\'Oréal — stendi su tutto il viso.', emoji: '✨'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — morbido strato su viso e collo.', emoji: '💜'),
  RoutineStep(name: 'SPF', description: 'Protezione solare — ultimo step, applica generosamente. Non saltare mai!', emoji: '☀️'),
];

const _eveningRetinal = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido per massimizzare l\'assorbimento.', emoji: '💧'),
  RoutineStep(name: 'Retinal', description: 'Retinaldeide — applica uno strato sottile su tutto il viso. Evita contorno occhi. Inizia 2-3 volte a settimana.', emoji: '🌙'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema L\'Oréal — stendi su tutto il viso per nutrire.', emoji: '✨'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer. Morbido strato su viso e collo.', emoji: '💜'),
];

const _eveningBuenosAires = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹'),
  RoutineStep(name: 'Buenos Aires', description: 'Acido esfoliante (BHA/AHA) — applica su viso asciutto. Non usare insieme al Retinal.', emoji: '🧪'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido.', emoji: '💧'),
  RoutineStep(name: 'Revitalift', description: 'Siero/crema L\'Oréal — stendi su tutto il viso.', emoji: '✨'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer.', emoji: '💜'),
];

const _eveningSunday = [
  RoutineStep(name: 'Detersione doppia', description: 'Step 1: olio/acqua micellare per rimuovere trucco e SPF. Step 2: CeraVe in schiuma per pulizia profonda.', emoji: '🧹'),
  RoutineStep(name: 'Retinal', description: 'Retinaldeide — applica uno strato sottile su tutto il viso. Evita contorno occhi. Inizia 2-3 volte a settimana.', emoji: '🌙'),
  RoutineStep(name: 'Acido ialuronico', description: 'Siero idratante — applica sul viso leggermente umido per massimizzare l\'assorbimento.', emoji: '💧'),
  RoutineStep(name: 'Lancôme', description: 'Crema idratante — sigilla tutti i layer. Morbido strato su viso e collo.', emoji: '💜'),
];

// ─── Mappa giorno → routine ───────────────────────────────────
// weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun
RoutineId morningRoutineFor(int weekday) {
  return weekday == 6 ? RoutineId.morningSaturday : RoutineId.morningStandard;
}

RoutineId eveningRoutineFor(int weekday) {
  if (weekday == 7) return RoutineId.eveningSunday;
  if (weekday == 3) return RoutineId.eveningBuenosAires;
  return RoutineId.eveningRetinal;
}

String dayLabel(int weekday) {
  const labels = ['', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];
  return labels[weekday];
}

String shortDayLabel(int weekday) {
  const labels = ['', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
  return labels[weekday];
}

// ─── BeautyScreen ─────────────────────────────────────────────
class BeautyScreen extends StatefulWidget {
  const BeautyScreen({super.key});

  @override
  State<BeautyScreen> createState() => _BeautyScreenState();
}

class _BeautyScreenState extends State<BeautyScreen> {
  late int _selectedWeekday;

  @override
  void initState() {
    super.initState();
    _selectedWeekday = DateTime.now().weekday; // 1=Mon..7=Sun
  }

  void _openRoutine(RoutineId id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutineDetailScreen(routineId: id.urlSegment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday;
    final morningId = morningRoutineFor(_selectedWeekday);
    final eveningId = eveningRoutineFor(_selectedWeekday);

    return Scaffold(
      appBar: AppBar(title: const Text('Beauty ✨')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StreakBanner(),
            const SizedBox(height: 24),

            // Selezione giorno
            Text('Seleziona giorno',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _DaySelector(
              selectedWeekday: _selectedWeekday,
              today: today,
              onSelect: (d) => setState(() => _selectedWeekday = d),
            ),
            const SizedBox(height: 24),

            // Routine del giorno selezionato
            Row(
              children: [
                Text(dayLabel(_selectedWeekday),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (_selectedWeekday == today) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.beautyDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('oggi',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            _RoutineCard(
              timeLabel: 'Mattina ☀️',
              steps: morningId.steps.length,
              specialNote: _selectedWeekday == 6 ? 'Bahia Blanca' : null,
              onTap: () => _openRoutine(morningId),
            ),
            const SizedBox(height: 10),
            _RoutineCard(
              timeLabel: 'Sera 🌙',
              steps: eveningId.steps.length,
              specialNote: _selectedWeekday == 7
                  ? 'Retinal'
                  : _selectedWeekday == 3
                      ? 'Buenos Aires (no Retinal)'
                      : 'Retinal',
              onTap: () => _openRoutine(eveningId),
            ),
            const SizedBox(height: 28),

            // Monitora progressi
            Text('Monitora i progressi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _ProgressCard(
              emoji: '🔍',
              title: 'Check-up pelle',
              subtitle: 'Questionario su idratazione, luminosità e imperfezioni',
              color: AppColors.lavenderDark,
              bgColor: AppColors.lavender,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkinQuestionnaireScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _ProgressCard(
              emoji: '📸',
              title: 'Foto progressi',
              subtitle: 'Documenta il percorso della tua pelle nel tempo',
              color: AppColors.beautyDark,
              bgColor: AppColors.beauty,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SkinPhotosScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _StreakBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.beauty, AppColors.blush],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('La tua routine ✨',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.beautyDark,
                ),
              ),
              Text('Skincare personalizzata giorno per giorno',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.beautyDark.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final int selectedWeekday;
  final int today;
  final ValueChanged<int> onSelect;

  const _DaySelector({
    required this.selectedWeekday,
    required this.today,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final day = i + 1; // 1=Mon..7=Sun (but Sun = 7)
        final isToday = day == today;
        final isSelected = day == selectedWeekday;
        return GestureDetector(
          onTap: () => onSelect(day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.beautyDark : isToday ? AppColors.beauty : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.beautyDark, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(shortDayLabel(day),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                if (day == 6)
                  Text('🌟', style: const TextStyle(fontSize: 14))
                else if (day == 7)
                  Text('🌿', style: const TextStyle(fontSize: 14))
                else if (day == 3)
                  Text('🧪', style: const TextStyle(fontSize: 14))
                else
                  Text('🌙', style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final String timeLabel;
  final int steps;
  final String? specialNote;
  final VoidCallback onTap;

  const _RoutineCard({
    required this.timeLabel,
    required this.steps,
    required this.onTap,
    this.specialNote,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.beauty.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timeLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.beautyDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.format_list_numbered_rounded, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('$steps step',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      if (specialNote != null) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.beauty,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(specialNote!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.beautyDark,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.beauty,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.beautyDark, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _ProgressCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
