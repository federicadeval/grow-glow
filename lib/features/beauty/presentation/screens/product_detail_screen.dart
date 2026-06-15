import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/products_database.dart';
import '../../domain/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final product = kProducts[productId];
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prodotto')),
        body: const Center(child: Text('Prodotto non trovato')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _ProductAppBar(product: product),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _CategoryTimingRow(product: product),
                const SizedBox(height: 24),
                _Section(
                  title: 'Descrizione',
                  child: Text(product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _Section(
                  title: 'Come si usa',
                  child: Text(product.howToUse,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.6,
                    ),
                  ),
                ),
                if (product.keyIngredients.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _Section(
                    title: 'Ingredienti chiave',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.keyIngredients.map((ing) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 10),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: product.category.fgColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(ing,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ],
                if (product.warnings != null) ...[
                  const SizedBox(height: 20),
                  _WarningsCard(text: product.warnings!),
                ],
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductAppBar extends StatelessWidget {
  final Product product;
  const _ProductAppBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: product.imageUrl != null ? 280 : 200,
      pinned: true,
      backgroundColor: product.category.bgColor,
      foregroundColor: product.category.fgColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                product.category.bgColor,
                product.category.bgColor.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                Text(product.emoji, style: const TextStyle(fontSize: 56)),
                            loadingBuilder: (_, child, progress) => progress == null
                                ? child
                                : Text(product.emoji, style: const TextStyle(fontSize: 56)),
                          )
                        : Text(product.emoji, style: const TextStyle(fontSize: 56)),
                  ),
                ),
                if (product.brand.isNotEmpty)
                  Text(product.brand,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: product.category.fgColor.withValues(alpha: 0.7),
                      letterSpacing: 1.2,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(product.shortName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: product.category.fgColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTimingRow extends StatelessWidget {
  final Product product;
  const _CategoryTimingRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: product.category.label,
          bg: product.category.bgColor,
          fg: product.category.fgColor,
        ),
        const SizedBox(width: 8),
        _Chip(
          label: product.timing.label,
          bg: AppColors.cream,
          fg: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Chip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.lavender.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

class _WarningsCard extends StatelessWidget {
  final String text;
  const _WarningsCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠️', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Attenzione',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE65100),
                  ),
                ),
                const SizedBox(height: 4),
                Text(text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5D4037),
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
