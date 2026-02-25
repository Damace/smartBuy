import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_products_controller.dart';
import '../../core/constants/api_constants.dart';
import '../../core/themes/app_theme.dart';

class VendorProductsView extends GetView<VendorProductsController> {
  const VendorProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('my_products'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchProducts,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'sort_name') {
                Get.snackbar(
                  'sort'.tr,
                  'feature_coming_soon'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else if (value == 'sort_price') {
                Get.snackbar(
                  'sort'.tr,
                  'feature_coming_soon'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'sort_price',
                child: Text('Sort by Price'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'search_products_sku'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
                filled: true,
                fillColor: Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final selected = controller.selectedFilter.value;
              final all = controller.allCount;
              final published = controller.publishedCount;
              final inStock = controller.inStockCount;
              final outOfStock = controller.outOfStockCount;
              final drafts = controller.draftsCount;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'all'.tr, all, selected),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'published', 'published_products'.tr, published, selected),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'in_stock', 'in_stock'.tr, inStock, selected),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'out_of_stock', 'out_of_stock'.tr, outOfStock, selected),
                    const SizedBox(width: 8),
                    _buildFilterChip('drafts', 'drafts'.tr, drafts, selected),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          // Products List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = controller.filteredProducts;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_products_found'.tr,
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

              return RefreshIndicator(
                onRefresh: controller.fetchProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, products[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addNewProduct,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(
      String value, String label, int count, String selected) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => controller.changeFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : Get.isDarkMode
                  ? AppTheme.darkCardColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.grey.shade300,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final imageUrl = product['image'] != null && product['image'] != 'default'
        ? '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/${product['image']}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Product Image
          GestureDetector(
            onTap: () => _showProductBottomSheet(context, product),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.inventory_2,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: GestureDetector(
              onTap: () => _showProductBottomSheet(context, product),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if ((product['category'] as String? ?? '').isNotEmpty)
                    Text(
                      product['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${(product['price'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(product['status'], product['stock']),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: AppTheme.primaryColor,
                iconSize: 20,
                onPressed: () => controller.editProduct(product),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
                iconSize: 20,
                onPressed: () => controller.deleteProduct(product),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, dynamic stock) {
    Color color;
    String label;
    switch (status) {
      case 'in_stock':
        color = AppTheme.successColor;
        label = '$stock ${'in_stock_count'.tr}';
        break;
      case 'out_of_stock':
        color = Colors.red;
        label = 'out_of_stock_label'.tr;
        break;
      case 'draft':
        color = Colors.grey;
        label = 'draft_status'.tr;
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showProductBottomSheet(
      BuildContext context, Map<String, dynamic> product) {
    final imageUrl = product['image'] != null && product['image'] != 'default'
        ? '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/${product['image']}'
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Product Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    height: 220,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, e) => Container(
                                      height: 220,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.inventory_2,
                                        size: 72,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 220,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      size: 72,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                          ),
                          // Status badge overlay
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _buildStatusBadge(
                              product['status'],
                              product['stock'],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            product['name'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Get.isDarkMode
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Category
                          if ((product['category'] as String? ?? '')
                              .isNotEmpty)
                            Text(
                              product['category'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Get.isDarkMode
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          const SizedBox(height: 12),

                          // Price row
                          Row(
                            children: [
                              Text(
                                '\$${(product['price'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if ((product['sale_price'] != null &&
                                  product['sale_price'].toString() != '0.0' &&
                                  product['sale_price'].toString() !=
                                      '0.00')) ...[
                                const SizedBox(width: 10),
                                Text(
                                  'sale_price'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Details grid
                          _buildDetailRow(
                            'sku_label'.tr,
                            product['sku']?.toString() ?? '-',
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            'quantity_in_stock'.tr,
                            '${product['stock']} ${'units'.tr}',
                          ),
                          const SizedBox(height: 24),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Get.back();
                                    controller.editProduct(product);
                                  },
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 18),
                                  label: Text('edit_product'.tr),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () {
                                    Get.back();
                                    controller.deleteProduct(product);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? AppTheme.darkTextPrimary
                : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
