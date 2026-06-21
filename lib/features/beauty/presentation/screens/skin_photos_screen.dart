import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';

// ─── Modello foto ─────────────────────────────────────────────
class SkinPhoto {
  final DateTime date;
  final String label;   // es. "Fronte", "Guancia sx", ...
  final String base64;  // immagine codificata

  const SkinPhoto({required this.date, required this.label, required this.base64});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'label': label,
    'base64': base64,
  };

  factory SkinPhoto.fromJson(Map<String, dynamic> j) => SkinPhoto(
    date: DateTime.parse(j['date'] as String),
    label: j['label'] as String,
    base64: j['base64'] as String,
  );
}

const _kPhotosKey = 'skin_photos';

Future<List<SkinPhoto>> loadPhotos() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_kPhotosKey) ?? [];
  return raw.map((s) => SkinPhoto.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
}

Future<void> savePhoto(SkinPhoto photo) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_kPhotosKey) ?? [];
  raw.add(jsonEncode(photo.toJson()));
  await prefs.setStringList(_kPhotosKey, raw);
}

Future<void> deletePhoto(int index) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_kPhotosKey) ?? [];
  if (index >= 0 && index < raw.length) {
    raw.removeAt(index);
    await prefs.setStringList(_kPhotosKey, raw);
  }
}

// ─── Screen ───────────────────────────────────────────────────
class SkinPhotosScreen extends StatefulWidget {
  const SkinPhotosScreen({super.key});

  @override
  State<SkinPhotosScreen> createState() => _SkinPhotosScreenState();
}

class _SkinPhotosScreenState extends State<SkinPhotosScreen> {
  List<SkinPhoto> _photos = [];
  bool _loading = true;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final photos = await loadPhotos();
    setState(() {
      _photos = photos.reversed.toList();
      _loading = false;
    });
  }

  Future<void> _addPhoto() async {
    final labels = ['Fronte', 'Guancia sx', 'Guancia dx', 'Mento', 'Naso', 'Collo'];
    String selectedLabel = labels.first;

    // Scegli etichetta
    final chosenLabel = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quale zona fotografare?',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: labels.map((l) => GestureDetector(
                  onTap: () => setS(() => selectedLabel = l),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedLabel == l ? AppColors.beautyDark : AppColors.beauty,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(l,
                      style: TextStyle(
                        color: selectedLabel == l ? Colors.white : AppColors.beautyDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx, selectedLabel),
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Galleria'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.beautyDark),
                        foregroundColor: AppColors.beautyDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx, '📷$selectedLabel'),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Fotocamera'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.beautyDark),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (chosenLabel == null || !mounted) return;

    final useCamera = chosenLabel.startsWith('📷');
    final label = chosenLabel.replaceFirst('📷', '');

    final picked = await _picker.pickImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 70,
    );
    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();
    final base64Str = base64Encode(bytes);

    final photo = SkinPhoto(
      date: DateTime.now(),
      label: label,
      base64: base64Str,
    );
    await savePhoto(photo);
    _load();
  }

  Future<void> _deletePhoto(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminare la foto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annulla')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blushDark),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // Calcola l'indice reale (lista è invertita)
      final realIndex = _photos.length - 1 - index;
      await deletePhoto(realIndex);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto progressi 📸')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPhoto,
        backgroundColor: AppColors.beautyDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Aggiungi foto'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _photos.isEmpty
              ? _EmptyState(onAdd: _addPhoto)
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoBanner(),
                      const SizedBox(height: 20),
                      Text('Le tue foto (${_photos.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _photos.length,
                        itemBuilder: (ctx, i) => _PhotoCard(
                          photo: _photos[i],
                          onDelete: () => _deletePhoto(i),
                          onTap: () => _openFullscreen(i),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _openFullscreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenPhoto(photo: _photos[index]),
      ),
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.beauty.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_rounded, size: 20, color: AppColors.beautyDark),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Scatta sempre con la stessa luce e angolazione per confronti affidabili.',
              style: TextStyle(fontSize: 12, color: AppColors.beautyDark, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final SkinPhoto photo;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _PhotoCard({required this.photo, required this.onDelete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final day = '${photo.date.day.toString().padLeft(2,'0')}/${photo.date.month.toString().padLeft(2,'0')}';
    final bytes = base64Decode(photo.base64);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
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
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.memory(
                  bytes,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(photo.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.beautyDark,
                          ),
                        ),
                        Text(day,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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

class _FullscreenPhoto extends StatelessWidget {
  final SkinPhoto photo;
  const _FullscreenPhoto({required this.photo});

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(photo.base64);
    final dateStr = '${photo.date.day.toString().padLeft(2,'0')}/${photo.date.month.toString().padLeft(2,'0')}/${photo.date.year}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${photo.label} · $dateStr'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.memory(bytes),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📸', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text('Nessuna foto ancora',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.beautyDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Documenta il percorso della tua pelle con foto periodiche. Potrai confrontarle nel tempo!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_a_photo_rounded),
              label: const Text('Prima foto'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.beautyDark),
            ),
          ],
        ),
      ),
    );
  }
}
