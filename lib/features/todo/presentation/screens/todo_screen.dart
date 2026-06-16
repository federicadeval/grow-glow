import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum TodoPriority { low, medium, high }
enum TodoCategory { personal, health, work, shopping }

class TodoItem {
  final String id;
  final String title;
  final TodoPriority priority;
  final TodoCategory category;
  final DateTime? dueDate;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    required this.priority,
    required this.category,
    this.dueDate,
    this.isCompleted = false,
  });
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<TodoItem> _todos = [
    TodoItem(id: '1', title: 'Bere 2L di acqua', priority: TodoPriority.high, category: TodoCategory.health),
    TodoItem(id: '2', title: 'Fare 10.000 passi', priority: TodoPriority.medium, category: TodoCategory.health),
    TodoItem(id: '3', title: 'Comprare SPF 50', priority: TodoPriority.medium, category: TodoCategory.shopping),
    TodoItem(id: '4', title: 'Meditazione 10 min', priority: TodoPriority.low, category: TodoCategory.personal, isCompleted: true),
    TodoItem(id: '5', title: 'Chiamare la palestra', priority: TodoPriority.low, category: TodoCategory.personal),
  ];

  TodoCategory? _filterCategory;

  List<TodoItem> get _pending => _todos
    .where((t) => !t.isCompleted)
    .where((t) => _filterCategory == null || t.category == _filterCategory)
    .toList();

  List<TodoItem> get _completed => _todos
    .where((t) => t.isCompleted)
    .where((t) => _filterCategory == null || t.category == _filterCategory)
    .toList();

  void _addTodo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddTodoSheet(
        onAdd: (todo) => setState(() => _todos.insert(0, todo)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        backgroundColor: AppColors.todoDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuovo task'),
      ),
      body: Column(
        children: [
          _CategoryFilter(
            selected: _filterCategory,
            onSelect: (cat) => setState(() =>
              _filterCategory = _filterCategory == cat ? null : cat,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(total: _todos.length, done: _completed.length),
                  const SizedBox(height: 20),
                  if (_pending.isNotEmpty) ...[
                    Text('Da fare (${_pending.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ..._pending.map((t) => _TodoTile(
                      todo: t,
                      onToggle: () => setState(() => t.isCompleted = !t.isCompleted),
                      onDelete: () => setState(() => _todos.remove(t)),
                    )),
                  ],
                  if (_completed.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Completati (${_completed.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._completed.map((t) => _TodoTile(
                      todo: t,
                      onToggle: () => setState(() => t.isCompleted = !t.isCompleted),
                      onDelete: () => setState(() => _todos.remove(t)),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int total;
  final int done;
  const _SummaryRow({required this.total, required this.done});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.todo, AppColors.mint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progresso',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.todoDark,
                ),
              ),
              Text('$done / $total completati',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.todoDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.todoDark),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final TodoCategory? selected;
  final Function(TodoCategory) onSelect;
  const _CategoryFilter({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: TodoCategory.values.map((cat) {
          final isSelected = selected == cat;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.todoDark : AppColors.todo.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(cat.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.todoDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension on TodoCategory {
  String get label {
    switch (this) {
      case TodoCategory.personal: return 'Personale';
      case TodoCategory.health: return 'Salute';
      case TodoCategory.work: return 'Lavoro';
      case TodoCategory.shopping: return 'Shopping';
    }
  }
  String get emoji {
    switch (this) {
      case TodoCategory.personal: return '🌸';
      case TodoCategory.health: return '💚';
      case TodoCategory.work: return '💼';
      case TodoCategory.shopping: return '🛍️';
    }
  }
}

extension on TodoPriority {
  Color get color {
    switch (this) {
      case TodoPriority.high: return const Color(0xFFE05C7A);
      case TodoPriority.medium: return const Color(0xFFE8855A);
      case TodoPriority.low: return const Color(0xFF3DAA82);
    }
  }
  String get label {
    switch (this) {
      case TodoPriority.high: return 'Alta';
      case TodoPriority.medium: return 'Media';
      case TodoPriority.low: return 'Bassa';
    }
  }
}

class _TodoTile extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _TodoTile({required this.todo, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.blushDark,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: todo.isCompleted
              ? AppColors.todo.withValues(alpha: 0.4)
              : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: todo.isCompleted ? null : [
              BoxShadow(
                color: AppColors.todo.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: todo.isCompleted ? AppColors.todoDark : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: todo.isCompleted ? AppColors.todoDark : AppColors.divider,
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                        color: todo.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(todo.category.emoji, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(todo.category.label,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: todo.priority.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(todo.priority.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: todo.priority.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTodoSheet extends StatefulWidget {
  final Function(TodoItem) onAdd;
  const _AddTodoSheet({required this.onAdd});

  @override
  State<_AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<_AddTodoSheet> {
  final _titleCtrl = TextEditingController();
  TodoPriority _priority = TodoPriority.medium;
  TodoCategory _category = TodoCategory.personal;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Nuovo task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Cosa devi fare?',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Text('Priorità', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Row(
            children: TodoPriority.values.map((p) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _priority = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: p != TodoPriority.low ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _priority == p
                      ? p.color.withValues(alpha: 0.2)
                      : AppColors.divider.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: _priority == p
                      ? Border.all(color: p.color, width: 1.5)
                      : null,
                  ),
                  child: Center(
                    child: Text(p.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _priority == p ? p.color : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text('Categoria', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: TodoCategory.values.map((cat) => GestureDetector(
              onTap: () => setState(() => _category = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _category == cat ? AppColors.todoDark : AppColors.todo.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(cat.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _category == cat ? Colors.white : AppColors.todoDark,
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_titleCtrl.text.trim().isEmpty) return;
                widget.onAdd(TodoItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleCtrl.text.trim(),
                  priority: _priority,
                  category: _category,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.todoDark,
              ),
              child: const Text('Aggiungi'),
            ),
          ),
        ],
      ),
    );
  }
}
