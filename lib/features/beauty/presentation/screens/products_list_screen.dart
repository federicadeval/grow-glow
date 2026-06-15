import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/products_database.dart';
import '../../domain/product.dart';
import 'product_detail_screen.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = <ProductCategory, List<Product>>{};
    for (final p in kProducts.values) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    final categories = ProductCategory.values
        .where((c) => grouped.containsKey(c))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('I miei prodotti 🧴')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final cat in categories) ...[
            _CategoryHeader(category: cat),
            const SizedBox(height: 10),
            ...grouped[cat]!.map((p) => _ProductCard(product: p)),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final ProductCategory category;
  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: category.bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(category.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: category.fgColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: product.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: product.category.bgColor.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: product.category.bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Center(child: Text(product.emoji, style: const TextStyle(fontSize: 24))),
                        loadingBuilder: (_, child, progress) => progress == null
                            ? child
                            : Center(child: Text(product.emoji, style: const TextStyle(fontSize: 24))),
                      ),
                    )
                  : Center(
                      child: Text(product.emoji, style: const TextStyle(fontSize: 24)),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.shortName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: product.category.fgColor,
                    ),
                  ),
                  if (product.brand.isNotEmpty)
                    Text(product.brand,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(product.timing.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
              size: 14,
              color: product.category.fgColor.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
