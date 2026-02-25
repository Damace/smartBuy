import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'category_list_controller.dart';

class CategoryListView extends GetView<CategoryListController> {
  const CategoryListView({super.key});

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Color get _bg => Get.isDarkMode
      ? AppTheme.darkBackgroundColor
      : const Color(0xFFF5F5F5);

  Color get _card =>
      Get.isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor;

  Color get _textPrimary =>
      Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary;

  Color get _textSecondary =>
      Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

  Color get _border =>
      Get.isDarkMode ? Colors.grey.shade800 : AppTheme.borderColor;

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: Text(controller.categoryName),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'filter'.tr,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          const SizedBox(height: 4),
          _buildResultsHeader(),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        onChanged: controller.searchProducts,
        style: TextStyle(color: _textPrimary),
        decoration: InputDecoration(
          hintText:
              '${'search_in'.tr} ${controller.categoryName}',
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondary),
          filled: true,
          fillColor: _card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ── Filter Chips ─────────────────────────────────────────────────────────────

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
      child: Obx(() {
        final selected = controller.selectedFilter.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.filters.length,
          itemBuilder: (context, index) {
            final filter = controller.filters[index];
            final isSelected = selected == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter.tr),
                selected: isSelected,
                onSelected: (_) => controller.changeFilter(filter),
                selectedColor: AppTheme.primaryColor,
                backgroundColor: _card,
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryColor : _border,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : _textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              ),
            );
          },
        );
      }),
    );
  }

  // ── Results Header ───────────────────────────────────────────────────────────

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                '${controller.filteredProducts.length} ${'results'.tr}',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              )),
          Obx(() => IconButton(
                icon: Icon(
                  controller.isGrid.value
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: AppTheme.primaryColor,
                ),
                tooltip: controller.isGrid.value
                    ? 'list_view'.tr
                    : 'grid_view'.tr,
                onPressed: controller.toggleLayout,
              )),
        ],
      ),
    );
  }

  // ── Product List / Grid ───────────────────────────────────────────────────────

  Widget _buildProductList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        );
      }

      if (controller.filteredProducts.isEmpty) {
        return _buildEmptyState();
      }

      if (controller.isGrid.value) {
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) =>
              _buildGridItem(context, controller.filteredProducts[index]),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, controller.filteredProducts[index]),
      );
    });
  }

  // ── Empty State ───────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: _textSecondary),
          const SizedBox(height: 16),
          Text(
            'no_products_found'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${'no_products_in_category'.tr} ${controller.categoryName}',
            style: TextStyle(fontSize: 13, color: _textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── List Item ────────────────────────────────────────────────────────────────

  Widget _buildListItem(BuildContext context, Map<String, dynamic> product) {
    final description = (product['description'] ?? '').toString().trim();
    final originalPrice = product['original_price'];
    final inStock = product['in_stock'] != false;

    return GestureDetector(
      onTap: () => controller.onProductTapped(product['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: Get.isDarkMode ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            _buildImage(product['image'], 88, 88, borderRadius: 10),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product['name'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  if (description.isNotEmpty) ...[
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Vendor
                  if ((product['vendor_name'] ?? '').isNotEmpty)
                    Text(
                      product['vendor_name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: _textSecondary),
                    ),
                  const SizedBox(height: 6),

                  // Rating
                  _buildRating(product['rating'], product['rating_count']),
                  const SizedBox(height: 8),

                  // Price row + Add button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Original price (strikethrough) if on sale
                            if (originalPrice != null && originalPrice > 0)
                              Text(
                                'KES ${originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              'KES ${(product['price'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // In stock badge
                      if (!inStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'out_of_stock'.tr,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.errorColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Add to cart
                      GestureDetector(
                        onTap: inStock
                            ? () => controller.addToCart(product['id'])
                            : null,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: inStock
                                ? AppTheme.primaryColor
                                : _textSecondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Grid Item ────────────────────────────────────────────────────────────────

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> product) {
    final description = (product['description'] ?? '').toString().trim();
    final originalPrice = product['original_price'];
    final inStock = product['in_stock'] != false;

    return GestureDetector(
      onTap: () => controller.onProductTapped(product['id']),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: Get.isDarkMode ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14)),
                  child: _buildImage(
                      product['image'], double.infinity, 130,
                      borderRadius: 0),
                ),
                if (!inStock)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'out_of_stock'.tr,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product['name'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Description
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: _textSecondary,
                        height: 1.35,
                      ),
                    ),

                  const SizedBox(height: 4),

                  // Rating
                  _buildRating(product['rating'], product['rating_count']),
                  const SizedBox(height: 6),

                  // Price + Add button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (originalPrice != null && originalPrice > 0)
                              Text(
                                'KES ${originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              'KES ${(product['price'] as double).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: inStock
                            ? () => controller.addToCart(product['id'])
                            : null,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: inStock
                                ? AppTheme.primaryColor
                                : _textSecondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Image ────────────────────────────────────────────────────────────────────

  Widget _buildImage(String? url, double width, double height,
      {double borderRadius = 12}) {
    final bg =
        Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: url != null && url.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: width,
                height: height,
                errorBuilder: (context, error, stackTrace) =>
                    _imageFallback(bg),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                      color: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            )
          : _imageFallback(bg),
    );
  }

  Widget _imageFallback(Color bg) {
    return Container(
      color: bg,
      child: Icon(
        Icons.image_not_supported_rounded,
        size: 32,
        color: Get.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
      ),
    );
  }

  // ── Rating ───────────────────────────────────────────────────────────────────

  Widget _buildRating(dynamic rating, dynamic count) {
    final r = (rating ?? 0.0) as double;
    final c = count ?? 0;
    return Row(
      children: [
        const Icon(Icons.star_rounded,
            size: 13, color: AppTheme.primaryColor),
        const SizedBox(width: 3),
        Text(
          r.toStringAsFixed(1),
          style: TextStyle(
              fontSize: 11,
              color: _textPrimary,
              fontWeight: FontWeight.w600),
        ),
        if (c > 0) ...[
          Text(
            ' ($c)',
            style: TextStyle(fontSize: 11, color: _textSecondary),
          ),
        ],
      ],
    );
  }
}
