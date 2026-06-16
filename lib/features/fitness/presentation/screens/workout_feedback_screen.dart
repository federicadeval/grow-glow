import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/workout_model.dart';

class WorkoutFeedbackScreen extends StatefulWidget {
  final WorkoutPlan workout;
  const WorkoutFeedbackScreen({super.key, required this.workout});

  @override
  State<WorkoutFeedbackScreen> createState() => _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends State<WorkoutFeedbackScreen> {
  // Q1 — fatica generale (1-5)
  int? _fatigue;

  // Q2 — quanto pesante il carico
  _LoadFeel? _loadFeel;

  // Q3 — dolori articolari
  bool? _jointPain;

  // Q4 — esercizi difficili (multi-select)
  final Set<int> _hardExercises = {};

  // Q5 — umore
  _Mood? _mood;

  bool get _canSubmit =>
      _fatigue != null &&
      _loadFeel != null &&
      _jointPain != null &&
      _mood != null;

  void _submit() {
    final suggestions = _buildSuggestions();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _SuggestionsScreen(
          workout: widget.workout,
          suggestions: suggestions,
          fatigue: _fatigue!,
        ),
      ),
    );
  }

  List<_Suggestion> _buildSuggestions() {
    final suggestions = <_Suggestion>[];

    // Basato su fatica
    if (_fatigue! <= 2) {
      suggestions.add(_Suggestion(
        icon: Icons.trending_up_rounded,
        title: 'Aumenta il carico',
        body: 'Ti sei sentita poco affaticata — è il momento di aggiungere 2-2.5 kg agli esercizi principali (squat, panca, stacco).',
        type: _SuggestionType.increase,
      ));
    } else if (_fatigue! == 5) {
      suggestions.add(_Suggestion(
        icon: Icons.trending_down_rounded,
        title: 'Riduci leggermente il carico',
        body: 'Fatica molto alta: prova a ridurre il peso del 10-15% nella prossima sessione e concentrati sulla tecnica.',
        type: _SuggestionType.decrease,
      ));
      suggestions.add(_Suggestion(
        icon: Icons.bedtime_rounded,
        title: 'Priorità al recupero',
        body: 'Dormi almeno 7-8 ore stanotte e assicurati di mangiare abbastanza proteine (1.6g per kg di peso corporeo).',
        type: _SuggestionType.rest,
      ));
    }

    // Basato sul carico
    if (_loadFeel == _LoadFeel.tooLight) {
      suggestions.add(_Suggestion(
        icon: Icons.fitness_center_rounded,
        title: 'Il peso era troppo leggero',
        body: 'Aggiungi 2.5 kg agli esercizi con bilanciere e 1 kg per quelli con manubri nella prossima sessione.',
        type: _SuggestionType.increase,
      ));
    } else if (_loadFeel == _LoadFeel.tooHeavy) {
      suggestions.add(_Suggestion(
        icon: Icons.flag_rounded,
        title: 'Riduci il carico',
        body: 'Se non riesci a mantenere la tecnica corretta, togli 2.5 kg. Meglio meno peso con forma perfetta.',
        type: _SuggestionType.decrease,
      ));
    }

    // Dolori articolari
    if (_jointPain == true) {
      suggestions.add(_Suggestion(
        icon: Icons.warning_rounded,
        title: 'Attenzione ai dolori articolari',
        body: 'Se il dolore persiste, consulta un medico. Nel frattempo evita l\'esercizio che lo causa e sostituiscilo con una variante meno impattante.',
        type: _SuggestionType.warning,
      ));
    }

    // Esercizi difficili — suggerimenti specifici
    for (final i in _hardExercises) {
      final ex = widget.workout.exercises[i];
      final tip = _exerciseTip(ex.name);
      if (tip != null) {
        suggestions.add(_Suggestion(
          icon: Icons.lightbulb_rounded,
          title: '${ex.name} — consiglio',
          body: tip,
          type: _SuggestionType.tip,
        ));
      }
    }

    // Umore
    if (_mood == _Mood.bad) {
      suggestions.add(_Suggestion(
        icon: Icons.favorite_rounded,
        title: 'Hai fatto benissimo lo stesso!',
        body: 'Allenarsi anche quando non si è al massimo è la vera forza. La prossima volta potrebbe andare meglio — e anche se non fosse così, conta lo stesso.',
        type: _SuggestionType.motivation,
      ));
    } else if (_mood == _Mood.great) {
      suggestions.add(_Suggestion(
        icon: Icons.local_fire_department_rounded,
        title: 'Sei in forma!',
        body: 'Ottimo umore = ottima sessione. Considera di aggiungere una serie extra agli esercizi principali la prossima volta.',
        type: _SuggestionType.increase,
      ));
    }

    if (suggestions.isEmpty) {
      suggestions.add(_Suggestion(
        icon: Icons.check_circle_rounded,
        title: 'Tutto nella norma',
        body: 'La sessione è andata bene! Continua così e rivedi i carichi tra 2-3 settimane.',
        type: _SuggestionType.tip,
      ));
    }

    return suggestions;
  }

  String? _exerciseTip(String name) {
    final n = name.toLowerCase();
    if (n.contains('squat')) {
      return 'Per lo squat: piedi larghezza spalle, ginocchia in linea con le punte dei piedi, schiena dritta. Se fai fatica, prova a mettere un piccolo rialzo sotto i talloni.';
    }
    if (n.contains('panca')) {
      return 'Per la panca: scapole retratte e depresse, piedi ben piantati a terra. Abbassa il bilanciere lentamente fino al petto, poi spingi esplosivamente.';
    }
    if (n.contains('stacco') || n.contains('deadlift')) {
      return 'Per lo stacco: schiena sempre neutra, mai curva. Immagina di spingere il pavimento via da te, non di tirare il bilanciere su.';
    }
    if (n.contains('shoulder') || n.contains('press') || n.contains('arnold')) {
      return 'Per l\'overhead press: core contratto, non inarcare la schiena. Se è troppo pesante, riduci il carico — è un esercizio tecnico.';
    }
    if (n.contains('rematore') || n.contains('row')) {
      return 'Per il rematore: busto quasi parallelo al suolo, trascina i gomiti indietro pensando di stringere una matita tra le scapole.';
    }
    if (n.contains('hip thrust')) {
      return 'Per l\'hip thrust: metti un tappetino sotto il bilanciere per comfort. Spingi con i talloni, non con le punte, e contrai i glutei in cima.';
    }
    if (n.contains('curl')) {
      return 'Per il curl: gomiti fermi ai fianchi, non oscillare il busto. Se oscilli, il peso è troppo pesante.';
    }
    return 'Concentrati sulla tecnica prima del carico. Se l\'esercizio è difficile, riduci il peso del 10% e fai più ripetizioni.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Come è andata? 📋')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qualche domanda sulla sessione',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text('Ti aiuterò a migliorare la prossima volta',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Q1 — Fatica
            _QuestionCard(
              number: '1',
              question: 'Quanto ti sei sentita affaticata?',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (i) {
                  final level = i + 1;
                  final fatigueIcons = [Icons.bedtime_rounded, Icons.sentiment_satisfied_rounded, Icons.directions_run_rounded, Icons.sentiment_dissatisfied_rounded, Icons.local_fire_department_rounded];
                  final sublabels = ['Per niente', 'Poco', 'Moderata', 'Molto', 'Esausta'];
                  final isSelected = _fatigue == level;
                  return GestureDetector(
                    onTap: () => setState(() => _fatigue = level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.peach : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.peachDark, width: 2)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(fatigueIcons[i], size: 28, color: isSelected ? AppColors.peachDark : AppColors.textSecondary),
                          const SizedBox(height: 4),
                          Text('$level',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.peachDark : AppColors.textSecondary,
                            ),
                          ),
                          Text(sublabels[i],
                            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Q2 — Carico
            _QuestionCard(
              number: '2',
              question: 'Come ti sembrava il peso usato?',
              child: Column(
                children: _LoadFeel.values.map((l) => GestureDetector(
                  onTap: () => setState(() => _loadFeel = l),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _loadFeel == l ? AppColors.peach : AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: _loadFeel == l
                          ? Border.all(color: AppColors.peachDark, width: 2)
                          : Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(l.icon, size: 22, color: _loadFeel == l ? AppColors.peachDark : AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text(l.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _loadFeel == l ? AppColors.peachDark : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ),

            // Q3 — Dolori
            _QuestionCard(
              number: '3',
              question: 'Hai avuto dolori articolari o muscolari insoliti?',
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _jointPain = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _jointPain == false ? AppColors.mint : AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: _jointPain == false
                              ? Border.all(color: AppColors.mintDark, width: 2)
                              : Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 24, color: AppColors.mintDark),
                            const SizedBox(height: 4),
                            Text('No, tutto ok',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: _jointPain == false ? AppColors.mintDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _jointPain = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _jointPain == true ? AppColors.blush : AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: _jointPain == true
                              ? Border.all(color: AppColors.blushDark, width: 2)
                              : Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.warning_rounded, size: 24, color: AppColors.blushDark),
                            const SizedBox(height: 4),
                            Text('Sì, qualcosa',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: _jointPain == true ? AppColors.blushDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Q4 — Esercizi difficili
            _QuestionCard(
              number: '4',
              question: 'Quali esercizi hai trovato più difficili? (opzionale)',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.workout.exercises.asMap().entries.map((e) {
                  final isSelected = _hardExercises.contains(e.key);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        _hardExercises.remove(e.key);
                      } else {
                        _hardExercises.add(e.key);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.peach : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: isSelected
                            ? Border.all(color: AppColors.peachDark, width: 2)
                            : Border.all(color: AppColors.divider),
                      ),
                      child: Text(e.value.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? AppColors.peachDark : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Q5 — Umore
            _QuestionCard(
              number: '5',
              question: 'Com\'era il tuo umore oggi?',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _Mood.values.map((m) {
                  final isSelected = _mood == m;
                  return GestureDetector(
                    onTap: () => setState(() => _mood = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.lavender : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? Border.all(color: AppColors.lavenderDark, width: 2)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Icon(m.icon, size: 32, color: isSelected ? AppColors.lavenderDark : AppColors.textSecondary),
                          const SizedBox(height: 4),
                          Text(m.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppColors.lavenderDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.peachDark,
                  disabledBackgroundColor: AppColors.divider,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Vedi i miei suggerimenti →',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─── Enums ───────────────────────────────────────────────────
enum _LoadFeel { tooLight, justRight, tooHeavy }

extension on _LoadFeel {
  String get label {
    switch (this) {
      case _LoadFeel.tooLight: return 'Troppo leggero, potevo fare di più';
      case _LoadFeel.justRight: return 'Giusto, mi sono impegnata bene';
      case _LoadFeel.tooHeavy: return 'Troppo pesante, ho faticato con la tecnica';
    }
  }
  IconData get icon {
    switch (this) {
      case _LoadFeel.tooLight: return Icons.arrow_downward_rounded;
      case _LoadFeel.justRight: return Icons.check_circle_rounded;
      case _LoadFeel.tooHeavy: return Icons.fitness_center_rounded;
    }
  }
}

enum _Mood { bad, neutral, good, great }

extension on _Mood {
  IconData get icon {
    switch (this) {
      case _Mood.bad: return Icons.sentiment_very_dissatisfied_rounded;
      case _Mood.neutral: return Icons.sentiment_neutral_rounded;
      case _Mood.good: return Icons.sentiment_satisfied_rounded;
      case _Mood.great: return Icons.sentiment_very_satisfied_rounded;
    }
  }
  String get label {
    switch (this) {
      case _Mood.bad: return 'Male';
      case _Mood.neutral: return 'Normale';
      case _Mood.good: return 'Bene';
      case _Mood.great: return 'Ottimo!';
    }
  }
}

// ─── Suggestion model ────────────────────────────────────────
enum _SuggestionType { increase, decrease, rest, tip, warning, motivation }

class _Suggestion {
  final IconData icon;
  final String title;
  final String body;
  final _SuggestionType type;
  const _Suggestion({
    required this.icon,
    required this.title,
    required this.body,
    required this.type,
  });
}

extension on _SuggestionType {
  Color get color {
    switch (this) {
      case _SuggestionType.increase: return AppColors.mintDark;
      case _SuggestionType.decrease: return AppColors.peachDark;
      case _SuggestionType.rest: return AppColors.lavenderDark;
      case _SuggestionType.tip: return AppColors.todoDark;
      case _SuggestionType.warning: return AppColors.blushDark;
      case _SuggestionType.motivation: return AppColors.beautyDark;
    }
  }
  Color get bgColor {
    switch (this) {
      case _SuggestionType.increase: return AppColors.mint;
      case _SuggestionType.decrease: return AppColors.peach;
      case _SuggestionType.rest: return AppColors.lavender;
      case _SuggestionType.tip: return AppColors.todo;
      case _SuggestionType.warning: return AppColors.blush;
      case _SuggestionType.motivation: return AppColors.beauty;
    }
  }
}

// ─── Schermata suggerimenti ──────────────────────────────────
class _SuggestionsScreen extends StatelessWidget {
  final WorkoutPlan workout;
  final List<_Suggestion> suggestions;
  final int fatigue;

  const _SuggestionsScreen({
    required this.workout,
    required this.suggestions,
    required this.fatigue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I tuoi suggerimenti')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con fatica
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.peach, AppColors.fitness],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(_fatigueIcon, size: 44, color: AppColors.peachDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(workout.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.peachDark,
                          ),
                        ),
                        Text('Fatica percepita: $fatigue/5',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.peachDark.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Cosa ti consiglio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...suggestions.map((s) => _SuggestionCard(suggestion: s)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Torna alla lista schede
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst || route.settings.name == '/fitness',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.peachDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Torna alle schede'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _fatigueIcon {
    switch (fatigue) {
      case 1: return Icons.bedtime_rounded;
      case 2: return Icons.sentiment_satisfied_rounded;
      case 3: return Icons.directions_run_rounded;
      case 4: return Icons.sentiment_dissatisfied_rounded;
      default: return Icons.local_fire_department_rounded;
    }
  }
}

class _SuggestionCard extends StatelessWidget {
  final _Suggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: suggestion.type.bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(suggestion.icon, size: 28, color: suggestion.type.color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: suggestion.type.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(suggestion.body,
                  style: TextStyle(
                    fontSize: 13,
                    color: suggestion.type.color.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget riutilizzabile question card ─────────────────────
class _QuestionCard extends StatelessWidget {
  final String number;
  final String question;
  final Widget child;
  const _QuestionCard({
    required this.number,
    required this.question,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.lavender.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.lavender,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(number,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lavenderDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(question,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
