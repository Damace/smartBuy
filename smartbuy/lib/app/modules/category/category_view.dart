import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_controller.dart';
import '../../core/constants/api_constants.dart';
import '../../core/themes/app_theme.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('categories'.tr),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: controller.onSortChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'latest',
                child: Text('sort_latest'.tr),
              ),
              PopupMenuItem(
                value: 'name_asc',
                child: Text('sort_a_z'.tr),
              ),
              PopupMenuItem(
                value: 'name_desc',
                child: Text('sort_z_a'.tr),
              ),
              PopupMenuItem(
                value: 'price_low',
                child: Text('sort_price_low'.tr),
              ),
              PopupMenuItem(
                value: 'price_high',
                child: Text('sort_price_high'.tr),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Text('sort_rating'.tr),
              ),
              PopupMenuItem(
                value: 'popular',
                child: Text('sort_popular'.tr),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: Obx(() {
              if (controller.isSearchActive.value) {
                return _buildSearchResults(context);
              }
              return Row(
                children: [
                  _buildCategorySidebar(context),
                  Expanded(
                    child: _buildMainContent(context),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller.searchTextController,
        focusNode: controller.searchFocusNode,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'search_in_smartbuy'.tr,
          hintStyle: TextStyle(
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
            size: 20,
          ),
          suffixIcon: Obx(() => controller.isSearchActive.value
              ? IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink()),
          filled: true,
          fillColor:
              Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // --- Search Results ---

  Widget _buildSearchResults(BuildContext context) {
    return Obx(() {
      // Show suggestions while typing
      if (controller.searchSuggestions.isNotEmpty &&
          controller.searchResults.isEmpty &&
          controller.isSearching.value == false &&
          controller.searchQuery.value.length < 2) {
        return _buildSuggestionsList(context);
      }

      if (controller.isSearching.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.searchResults.isEmpty &&
          controller.searchQuery.value.length >= 2) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'no_results_found'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Suggestions chips
          if (controller.searchSuggestions.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.searchSuggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final suggestion = controller.searchSuggestions[index];
                  return ActionChip(
                    label: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () =>
                        controller.onSuggestionTapped(suggestion),
                    backgroundColor: Get.isDarkMode
                        ? AppTheme.darkCardColor
                        : Colors.grey[100],
                  );
                },
              ),
            ),
          if (controller.searchSuggestions.isNotEmpty)
            const SizedBox(height: 8),
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '${controller.searchResults.length} ${'results'.tr}',
              style: TextStyle(
                fontSize: 13,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
          ),
          // Product grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final product = controller.searchResults[index];
                return _buildProductCard(context, product);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSuggestionsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.searchSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = controller.searchSuggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, size: 20),
          title: Text(suggestion),
          dense: true,
          onTap: () => controller.onSuggestionTapped(suggestion),
        );
      },
    );
  }

  // --- Category Sidebar ---

  Widget _buildCategorySidebar(BuildContext context) {
    return Container(
      width: 90,
      color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
      child: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected =
                controller.selectedCategoryIndex.value == index;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.selectCategory(index),
                splashColor:
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                highlightColor:
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (Get.isDarkMode
                            ? AppTheme.primaryColor
                                .withValues(alpha: 0.15)
                            : AppTheme.backgroundColor)
                        : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                                  .withValues(alpha: 0.15)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          size: 24,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : (Get.isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                              fontSize: 9,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : (Get.isDarkMode
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary),
                              letterSpacing: 0.5,
                              height: 1.2,
                            ),
                        child: Text(
                          (category['name'] ?? '').toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // --- Main Content ---

  Widget _buildMainContent(BuildContext context) {
    return Obx(() => Container(
          color: Get.isDarkMode
              ? AppTheme.darkBackgroundColor
              : AppTheme.backgroundColor,
          child: Column(
            children: [
              // Category Header
              if (controller.categories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller
                                .categories[
                                    controller.selectedCategoryIndex.value]
                                    ['name'] ??
                            '',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: controller.onViewAllTapped,
                        child: Text(
                          'view_all'.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Subcategories horizontal list
              if (controller.isLoadingSubcategories.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (controller.subcategories.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.subcategories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final sub = controller.subcategories[index];
                      return _buildSubcategoryChip(context, sub);
                    },
                  ),
                ),
              const SizedBox(height: 8),

              // Products grid
              Expanded(
                child: _buildProductsGrid(context),
              ),
            ],
          ),
        ));
  }

  Widget _buildSubcategoryChip(
      BuildContext context, Map<String, dynamic> subcategory) {
    return GestureDetector(
      onTap: () => controller.onSubcategoryTapped(subcategory['id']),
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Color(subcategory['color'] ?? 0xFF636E72)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                subcategory['icon'] ?? Icons.category,
                size: 26,
                color: Color(subcategory['color'] ?? 0xFF636E72),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subcategory['name'] ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingProducts.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 60, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'no_products'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          final product = controller.products[index];
          return _buildProductCard(context, product);
        },
      );
    });
  }

  // --- Product Card ---

  Widget _buildProductCard(
      BuildContext context, Map<String, dynamic> product) {
    final hasDiscount = product['originalPrice'] != null;

    return GestureDetector(
      onTap: () => controller.onProductTapped(product['id']),
      child: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: Get.isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: _buildProductImage(product['image']),
              ),
            ),
            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product['vendorName'] != null &&
                        product['vendorName'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          product['vendorName'],
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                fontSize: 10,
                                color: Get.isDarkMode
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${product['rating'] ?? 0}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '\$${(product['price'] ?? 0).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '\$${product['originalPrice'].toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration:
                                        TextDecoration.lineThrough,
                                    color: Get.isDarkMode
                                        ? AppTheme.darkTextSecondary
                                        : AppTheme.textSecondary,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath != null && imagePath.contains('/')) {
      return Image.network(
        '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/$imagePath',
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
          child: const Center(
            child:
                Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          ),
        ),
      );
    }
    return Container(
      color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
      child: const Center(
        child: Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
      ),
    );
  }
}
