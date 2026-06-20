import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Modello risposta ─────────────────────────────────────────
class SkinCheckEntry {
  final DateTime date;
  final int hydration;     // 1-5
  final int glow;          // 1-5
  final int blemishes;     // 1=nessuna, 2=qualcuna, 3=molte
  final int sensitivity;   // 1=nessuna, 2=lieve, 3=forte
  final int texture;       // 1=liscia, 2=normale, 3=ruvida
  final String notes;

  const SkinCheckEntry({
    required this.date,
    required this.hydration,
    required this.glow,
    required this.blemishes,
    required this.sensitivity,
    required this.texture,
    required this.notes,
  });

  int get overallScore => ((hydration + glow + (4 - blemishes) + (4 - sensitivity) + (4 - texture)) / 5 * 20).round().clamp(0, 100);

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'hydration': hydration,
    'glow': glow,
    'blemishes': blemishes,
    'sensitivity': sensitivity,
    'texture': texture,
    'notes': notes,
  };

  factory SkinCheckEntry.fromJson(Map<String, dynamic> j) => SkinCheckEntry(
    date: DateTime.parse(j['date'] as String),
    hydration: j['hydration'] as int,
    glow: j['glow'] as int,
    blemishes: j['blemishes'] as int,
    sensitivity: j['sensitivity'] as int,
    texture: j['texture'] as int,
    notes: j['notes'] as String,
  );
}

const _kChecksKey = 'skin_checks';

Future<List<SkinCheckEntry>> loadSkinChecks() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_kChecksKey) ?? [];
  return raw.map((s) => SkinCheckEntry.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
}

Future<void> saveSkinCheck(SkinCheckEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_kChecksKey) ?? [];
  raw.add(jsonEncode(entry.toJson()));
  await prefs.setStringList(_kChecksKey, raw);
}

// ─── Screen principale ─────────────────────────────────────────
class SkinQuestionnaireScreen extends StatefulWidget {
  const SkinQuestionnaireScreen({super.key});

  @override
  State<SkinQuestionnaireScreen> createState() => _SkinQuestionnaireScreenState();
}

class _SkinQuestionnaireScreenState extends State<SkinQuestionnaireScreen> {
  List<SkinCheckEntry> _history = [];
  bool _loadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final checks = await loadSkinChecks();
    setState(() {
      _history = checks.reversed.toList();
      _loadingHistory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-up pelle')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final entry = await Navigator.push<SkinCheckEntry>(
            context,
            MaterialPageRoute(builder: (_) => const _NewCheckScreen()),
          );
          if (entry != null) {
            await saveSkinCheck(entry);
            _loadHistory();
          }
        },
        backgroundColor: AppColors.beautyDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuovo check'),
      ),
      body: _loadingHistory
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _EmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_history.length >= 2)
                        _TrendCard(history: _history),
                      const SizedBox(height: 20),
                      Text('Storico check-up',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ..._history.map((e) => _CheckCard(entry: e)),
                    ],
                  ),
                ),
    );
  }
}

// ─── Schermata nuovo check ─────────────────────────────────────
class _NewCheckScreen extends StatefulWidget {
  const _NewCheckScreen();

  @override
  State<_NewCheckScreen> createState() => _NewCheckScreenState();
}

class _NewCheckScreenState extends State<_NewCheckScreen> {
  int _hydration = 3;
  int _glow = 3;
  int _blemishes = 1;
  int _sensitivity = 1;
  int _texture = 1;
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Come sta la tua pelle oggi?'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Salva', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QuestionSlider(
              label: 'Idratazione',
              sublabel: '1 = secca e tesa · 5 = super idratata',
              value: _hydration,
              onChanged: (v) => setState(() => _hydration = v),
            ),
            const SizedBox(height: 20),
            _QuestionSlider(
              label: 'Luminosità',
              sublabel: '1 = spenta · 5 = glowing',
              value: _glow,
              onChanged: (v) => setState(() => _glow = v),
            ),
            const SizedBox(height: 20),
            _QuestionChoice(
              label: 'Imperfezioni/brufoli',
              options: const ['Nessuna', 'Qualcuna', 'Molte'],
              selected: _blemishes - 1,
              onSelect: (i) => setState(() => _blemishes = i + 1),
            ),
            const SizedBox(height: 20),
            _QuestionChoice(
              label: 'Sensibilità/rossori 🌡️',
              options: const ['Nessuna', 'Lieve', 'Forte'],
              selected: _sensitivity - 1,
              onSelect: (i) => setState(() => _sensitivity = i + 1),
            ),
            const SizedBox(height: 20),
            _QuestionChoice(
              label: 'Texture 🤲',
              options: const ['Liscia', 'Normale', 'Ruvida'],
              selected: _texture - 1,
              onSelect: (i) => setState(() => _texture = i + 1),
            ),
            const SizedBox(height: 20),
            Text('Note libere',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Come ti senti? Hai notato cambiamenti?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beautyDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Salva check-up', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final entry = SkinCheckEntry(
      date: DateTime.now(),
      hydration: _hydration,
      glow: _glow,
      blemishes: _blemishes,
      sensitivity: _sensitivity,
      texture: _texture,
      notes: _notesCtrl.text.trim(),
    );
    Navigator.pop(context, entry);
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _QuestionSlider extends StatelessWidget {
  final String label;
  final String sublabel;
  final int value;
  final ValueChanged<int> onChanged;

  const _QuestionSlider({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [Icons.sentiment_very_dissatisfied_rounded, Icons.sentiment_dissatisfied_rounded, Icons.sentiment_neutral_rounded, Icons.sentiment_satisfied_rounded, Icons.sentiment_very_satisfied_rounded];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.beauty.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          Text(sublabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(icons[value - 1], size: 28, color: AppColors.beautyDark),
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: AppColors.beautyDark,
                  label: '$value',
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.beauty,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$value',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.beautyDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionChoice extends StatelessWidget {
  final String label;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelect;

  const _QuestionChoice({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.beauty.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Row(
            children: options.asMap().entries.map((e) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < options.length - 1 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => onSelect(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected == e.key ? AppColors.beautyDark : AppColors.beauty,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(e.value,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected == e.key ? Colors.white : AppColors.beautyDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final List<SkinCheckEntry> history;
  const _TrendCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final latest = history.first;
    final prev = history[1];
    final diff = latest.overallScore - prev.overallScore;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.beauty, AppColors.blush],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Score pelle attuale',
                style: TextStyle(fontSize: 13, color: AppColors.beautyDark),
              ),
              Text('${latest.overallScore}/100',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.beautyDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: diff >= 0 ? AppColors.mintDark : AppColors.blushDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  diff >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '${diff >= 0 ? '+' : ''}$diff vs precedente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
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

class _CheckCard extends StatelessWidget {
  final SkinCheckEntry entry;
  const _CheckCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final day = '${entry.date.day.toString().padLeft(2,'0')}/${entry.date.month.toString().padLeft(2,'0')}/${entry.date.year}';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.beauty.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(day,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.beautyDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.beauty,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Score: ${entry.overallScore}/100',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.beautyDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _MiniChip('Idr. ${entry.hydration}/5'),
              _MiniChip('Lum. ${entry.glow}/5'),
              _MiniChip(_blemishLabel(entry.blemishes)),
              _MiniChip(_sensitivityLabel(entry.sensitivity)),
              _MiniChip(_textureLabel(entry.texture)),
            ],
          ),
          if (entry.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(entry.notes,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _blemishLabel(int v) {
    switch (v) {
      case 1: return 'Nessuna imperf.';
      case 2: return 'Qualche imperf.';
      default: return 'Molte imperf.';
    }
  }

  String _sensitivityLabel(int v) {
    switch (v) {
      case 1: return 'No sensib.';
      case 2: return 'Sensib. lieve';
      default: return 'Sensib. forte';
    }
  }

  String _textureLabel(int v) {
    switch (v) {
      case 1: return 'Liscia';
      case 2: return 'Normale';
      default: return 'Ruvida';
    }
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  const _MiniChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.beauty.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.beautyDark)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.manage_search_rounded, size: 64, color: AppColors.beautyDark),
            const SizedBox(height: 20),
            Text('Nessun check-up ancora',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.beautyDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fai il primo check-up per iniziare a monitorare i progressi della tua pelle.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
