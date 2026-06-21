import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/beauty_product_provider.dart';
import '../../data/products_database.dart';
import '../../domain/product.dart';
import 'product_detail_screen.dart';

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beautyState = ref.watch(beautyProductProvider);

    final grouped = <ProductCategory, List<Product>>{};
    for (final p in kProducts.values) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    final categories =
        ProductCategory.values.where((c) => grouped.containsKey(c)).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('I miei prodotti'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.beauty.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 15, color: AppColors.beautyDark),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Attiva i prodotti che possiedi. Potrai poi aggiungerli alla tua routine settimanale.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.beautyDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          for (final cat in categories) ...[
            _CategoryHeader(category: cat),
            const SizedBox(height: 10),
            ...grouped[cat]!.map((p) => _ProductCard(
                  product: p,
                  isActive: beautyState.activeIds.contains(p.id),
                  onToggle: () => ref
                      .read(beautyProductProvider.notifier)
                      .toggleActive(p.id),
                )),
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
          child: Text(
            category.label,
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

class _ProductCard extends StatefulWidget {
  final Product product;
  final bool isActive;
  final VoidCallback onToggle;

  const _ProductCard({
    required this.product,
    required this.isActive,
    required this.onToggle,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.product.category;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: widget.isActive
              ? cat.bgColor.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isActive ? cat.bgColor : AppColors.divider,
            width: widget.isActive ? 1.5 : 1,
          ),
          boxShadow: widget.isActive
              ? null
              : [
                  BoxShadow(
                    color: AppColors.divider.withValues(alpha: 0.8),
                    blurRadius: 6,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon / image
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: widget.product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(
                              widget.product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                  child: Icon(widget.product.icon,
                                      size: 22, color: cat.fgColor)),
                              loadingBuilder: (_, child, progress) =>
                                  progress == null
                                      ? child
                                      : Center(
                                          child: Icon(widget.product.icon,
                                              size: 22, color: cat.fgColor)),
                            ),
                          )
                        : Center(
                            child: Icon(widget.product.icon,
                                size: 22, color: cat.fgColor)),
                  ),
                  const SizedBox(width: 12),

                  // Name + timing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.shortName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (widget.product.brand.isNotEmpty) ...[
                          const SizedBox(height: 1),
                          Text(
                            widget.product.brand,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: cat.bgColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.product.timing.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: cat.fgColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Active toggle
                  GestureDetector(
                    onTap: widget.onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? cat.fgColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.isActive
                              ? cat.fgColor
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        widget.isActive ? 'Attivo' : 'Aggiungi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: widget.isActive
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Expandable: description + info button
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: _expanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppColors.divider),
                          const SizedBox(height: 12),
                          Text(
                            widget.product.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(
                                    productId: widget.product.id),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 13, color: cat.fgColor),
                                const SizedBox(width: 4),
                                Text(
                                  'Scheda completa',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: cat.fgColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
