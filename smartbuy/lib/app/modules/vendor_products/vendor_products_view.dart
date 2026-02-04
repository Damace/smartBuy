import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_products_controller.dart';
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
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
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
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'all'.tr, controller.allCount),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'in_stock', 'in_stock'.tr, controller.inStockCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('out_of_stock', 'out_of_stock'.tr,
                        controller.outOfStockCount),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                        'drafts', 'drafts'.tr, controller.draftsCount),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Products List
          Expanded(
            child: Obx(
              () {
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

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
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

  Widget _buildFilterChip(String value, String label, int count) {
    final isSelected = controller.selectedFilter.value == value;

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
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getProductIcon(product['image']),
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(product['status'], product['stock']),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(product['status']),
                        fontWeight: product['status'] == 'out_of_stock'
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
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
                color: AppTheme.primaryColor,
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

  IconData _getProductIcon(String imageName) {
    switch (imageName) {
      case 'honey':
        return Icons.water_drop;
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      case 'bottle':
        return Icons.local_drink;
      case 'lamp':
        return Icons.lightbulb_outline;
      default:
        return Icons.inventory_2;
    }
  }

  String _getStatusText(String status, int stock) {
    switch (status) {
      case 'in_stock':
        return '$stock ${'in_stock_count'.tr}';
      case 'out_of_stock':
        return 'out_of_stock_label'.tr;
      case 'draft':
        return 'draft_status'.tr;
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_stock':
        return Get.isDarkMode
            ? AppTheme.darkTextSecondary
            : AppTheme.textSecondary;
      case 'out_of_stock':
        return Colors.red;
      case 'draft':
        return Get.isDarkMode
            ? AppTheme.darkTextSecondary
            : AppTheme.textSecondary;
      default:
        return Get.isDarkMode
            ? AppTheme.darkTextSecondary
            : AppTheme.textSecondary;
    }
  }
}
