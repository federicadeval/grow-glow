import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/workout_model.dart';
import 'workout_session_screen.dart';
import 'c25k_session_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palestra'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.peachDark,
          labelColor: AppColors.peachDark,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center_rounded), text: 'Pesi'),
            Tab(icon: Icon(Icons.directions_run_rounded), text: 'Corsa'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PesiTab(),
          _CorsaTab(),
        ],
      ),
    );
  }
}

// ─── TAB PESI ────────────────────────────────────────────────
class _PesiTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Le tue schede',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text('Tap su una scheda per avviare la sessione',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ...builtinWorkouts.map((w) => _WorkoutCard(
          workout: w,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutSessionScreen(workout: w),
            ),
          ),
        )),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutPlan workout;
  final VoidCallback onTap;

  const _WorkoutCard({required this.workout, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.peach.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text(workout.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workout.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.peachDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _Badge(
                              icon: Icons.timer_outlined,
                              label: workout.duration,
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              icon: Icons.local_fire_department_rounded,
                              label: '~${workout.estimatedKcal} kcal',
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              icon: Icons.fitness_center_rounded,
                              label: '${workout.exercises.length} esercizi',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Lista esercizi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: workout.exercises.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.peach,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${e.key + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.peachDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.value.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Text('${e.value.sets}x${e.value.reps}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.peachDark,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            // Bottone
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.peachDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Inizia sessione'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.peachDark),
        const SizedBox(width: 3),
        Text(label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.peachDark,
          ),
        ),
      ],
    );
  }
}

// ─── TAB CORSA / COUCH TO 5K ─────────────────────────────────
class _CorsaTab extends StatefulWidget {
  @override
  State<_CorsaTab> createState() => _CorsaTabState();
}

class _CorsaTabState extends State<_CorsaTab> {
  int _currentWeek = 0; // settimana selezionata per dettaglio

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.mint, AppColors.sky],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🏃‍♀️', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text('Couch to 5K',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.mintDark,
                ),
              ),
              Text('9 settimane · 3 sessioni/settimana · da 0 a 5 km',
                style: TextStyle(fontSize: 13, color: AppColors.mintDark.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('Il programma',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        ..._c25kWeeks.asMap().entries.map((e) => _WeekCard(
          week: e.value,
          weekNumber: e.key + 1,
          isExpanded: _currentWeek == e.key,
          onTap: () => setState(() =>
            _currentWeek = _currentWeek == e.key ? -1 : e.key,
          ),
        )),
      ],
    );
  }
}

class _C25KWeek {
  final String session;
  final String description;
  final int totalMinutes;
  final int estimatedKcal;
  const _C25KWeek({
    required this.session,
    required this.description,
    required this.totalMinutes,
    required this.estimatedKcal,
  });
}

const _c25kWeeks = [
  _C25KWeek(
    session: '60 sec corsa · 90 sec camminata × 8',
    description: 'Alterna 60 secondi di corsa leggera con 90 secondi di camminata. Ripeti 8 volte.',
    totalMinutes: 20,
    estimatedKcal: 120,
  ),
  _C25KWeek(
    session: '90 sec corsa · 2 min camminata × 6',
    description: 'Aumenta la corsa a 90 secondi, recupero di 2 minuti. Ripeti 6 volte.',
    totalMinutes: 21,
    estimatedKcal: 130,
  ),
  _C25KWeek(
    session: '90 sec · 3 min · 90 sec · 3 min corsa',
    description: 'Sessione A: 2×(90 sec + 90 sec). Sessione B/C: 3 min + 90 sec + 3 min + 90 sec.',
    totalMinutes: 22,
    estimatedKcal: 145,
  ),
  _C25KWeek(
    session: '3 min · 5 min · 3 min · 5 min corsa',
    description: 'Corsa 3 min, cammina 90 sec, corsa 5 min, cammina 2.5 min, ripeti.',
    totalMinutes: 25,
    estimatedKcal: 165,
  ),
  _C25KWeek(
    session: '5 min · 8 min · 5 min / 20 min continui',
    description: 'Sessione A: 5+8+5 min. Sessione B: 8+8 min. Sessione C: 20 min continui!',
    totalMinutes: 28,
    estimatedKcal: 185,
  ),
  _C25KWeek(
    session: '25 min di corsa continua',
    description: 'Tre sessioni da 25 minuti di corsa continua. Ritmo lento ma costante.',
    totalMinutes: 35,
    estimatedKcal: 200,
  ),
  _C25KWeek(
    session: '25 min → 28 min di corsa continua',
    description: 'Aumenti progressivi: 25, 25, 28 minuti. Stai andando alla grande!',
    totalMinutes: 38,
    estimatedKcal: 215,
  ),
  _C25KWeek(
    session: '28 min → 30 min di corsa continua',
    description: 'Quasi al traguardo: 28, 28, 30 minuti. Puoi farcela!',
    totalMinutes: 40,
    estimatedKcal: 230,
  ),
  _C25KWeek(
    session: '30 min di corsa continua = ~5 km 🎉',
    description: 'Ce l\'hai fatta! Tre sessioni da 30 minuti. Sei una runner!',
    totalMinutes: 40,
    estimatedKcal: 240,
  ),
];

class _WeekCard extends StatelessWidget {
  final _C25KWeek week;
  final int weekNumber;
  final bool isExpanded;
  final VoidCallback onTap;

  const _WeekCard({
    required this.week,
    required this.weekNumber,
    required this.isExpanded,
    required this.onTap,
  });

  void _startSession(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => C25KSessionScreen(
          weekIndex: weekNumber - 1,
          weekLabel: 'Settimana $weekNumber',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = weekNumber == 9;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isExpanded ? AppColors.mint : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.mint.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isLast ? AppColors.mintDark : AppColors.todo,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isLast
                          ? const Text('🏅', style: TextStyle(fontSize: 18))
                          : Text('$weekNumber',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.mintDark,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Settimana $weekNumber',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.mintDark,
                          ),
                        ),
                        Text('${week.totalMinutes} min · ~${week.estimatedKcal} kcal · 3 sessioni',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.mintDark,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Text(week.session,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.mintDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(week.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startSession(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mintDark,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Inizia sessione'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
