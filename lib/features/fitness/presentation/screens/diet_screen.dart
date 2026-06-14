import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
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
        title: const Text('Dieta 🥗'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.mintDark,
          labelColor: AppColors.mintDark,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Oggi'),
            Tab(text: 'Piano'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.mintDark,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Aggiungi pasto'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TodayTab(),
          _PlanTab(),
        ],
      ),
    );
  }
}

class _TodayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MacroSummaryCard(),
          const SizedBox(height: 24),
          Text('Pasti di oggi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _MealCard(
            meal: 'Colazione',
            time: '08:00',
            items: ['Yogurt greco', 'Frutti di bosco', 'Granola'],
            calories: 320,
            emoji: '🌅',
          ),
          _MealCard(
            meal: 'Pranzo',
            time: '13:00',
            items: ['Riso integrale', 'Petto di pollo', 'Verdure'],
            calories: 580,
            emoji: '☀️',
          ),
          _MealCard(
            meal: 'Cena',
            time: '20:00',
            items: [],
            calories: 0,
            emoji: '🌙',
            isEmpty: true,
          ),
        ],
      ),
    );
  }
}

class _MacroSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.mint, AppColors.sky],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Calorie oggi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.mintDark,
                ),
              ),
              Text('900 / 1800 kcal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.mintDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 900 / 1800,
              backgroundColor: Colors.white.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mintDark),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _MacroItem(label: 'Proteine', value: '65g', target: '120g'),
              _MacroItem(label: 'Carboidrati', value: '110g', target: '200g'),
              _MacroItem(label: 'Grassi', value: '30g', target: '60g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String target;
  const _MacroItem({
    required this.label,
    required this.value,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.mintDark,
          ),
        ),
        Text('/ $target',
          style: const TextStyle(fontSize: 11, color: AppColors.mintDark),
        ),
        Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  final String meal;
  final String time;
  final List<String> items;
  final int calories;
  final String emoji;
  final bool isEmpty;

  const _MealCard({
    required this.meal,
    required this.time,
    required this.items,
    required this.calories,
    required this.emoji,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEmpty ? AppColors.mint.withValues(alpha: 0.3) : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isEmpty
          ? Border.all(color: AppColors.mintDark.withValues(alpha: 0.3), style: BorderStyle.solid)
          : null,
        boxShadow: isEmpty ? null : [
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(meal,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (isEmpty)
                  Text('Aggiungi pasto',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mintDark.withValues(alpha: 0.7),
                    ),
                  )
                else ...[
                  const SizedBox(height: 4),
                  Text(items.join(' · '),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('$calories kcal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mintDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🥗', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('Piano alimentare',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text('Crea il tuo piano settimanale',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mintDark,
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crea piano'),
          ),
        ],
      ),
    );
  }
}
