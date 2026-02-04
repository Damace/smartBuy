import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_stock_inventory_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorStockInventoryView extends GetView<VendorStockInventoryController> {
  const VendorStockInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('stock_inventory'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
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
                hintText: 'search_sku_product_name'.tr,
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
              () => Row(
                children: [
                  _buildFilterChip(
                    'low_stock',
                    '${'low_stock'.tr} (${controller.lowStockCount})',
                  ),
                  const SizedBox(width: 12),
                  _buildFilterChip(
                    'out_of_stock',
                    '${'out_of_stock'.tr} (${controller.outOfStockCount})',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Active Inventory Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'active_inventory'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextPrimary
                        : AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Inventory List
          Expanded(
            child: Obx(
              () {
                final items = controller.filteredInventory;

                if (items.isEmpty) {
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
                          'no_inventory_items_found'.tr,
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
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildInventoryCard(item);
                  },
                );
              },
            ),
          ),

          // Add New Inventory Item Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.addNewInventoryItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'add_new_inventory_item'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = controller.selectedFilter.value == value;

    return GestureDetector(
      onTap: () => controller.changeFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (value == 'low_stock'
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1))
              : Get.isDarkMode
                  ? AppTheme.darkCardColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (value == 'low_stock' ? Colors.orange : Colors.red)
                : Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value == 'low_stock')
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: Colors.orange,
              )
            else
              const Icon(
                Icons.error_outline,
                size: 16,
                color: Colors.red,
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (value == 'low_stock' ? Colors.orange : Colors.red)
                    : Get.isDarkMode
                        ? AppTheme.darkTextPrimary
                        : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              // Product Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.status == 'out_of_stock'
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Get.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: item.status == 'out_of_stock'
                      ? Container(
                          color: Colors.grey.shade800,
                          child: Center(
                            child: Text(
                              'OUT OF STOCK',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Text(
                          item.image,
                          style: const TextStyle(fontSize: 32),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Get.isDarkMode
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (item.status == 'low_stock')
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 16,
                            color: Colors.orange,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'sku'.tr}: ${item.sku} | ${'wh'.tr}: ${item.warehouse}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quantity Controls and Status
          Row(
            children: [
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      onPressed: () => controller.decrementQuantity(item),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          item.quantity.value.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: item.quantity.value == 0
                                ? Colors.red
                                : Get.isDarkMode
                                    ? AppTheme.darkTextPrimary
                                    : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      onPressed: () => controller.incrementQuantity(item),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Status Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'status'.tr.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusLabel(item.status),
                      style: TextStyle(
                        color: _getStatusColor(item.status),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Auto-mark out of stock toggle
          Row(
            children: [
              Obx(
                () => Switch(
                  value: item.autoMarkOutOfStock.value,
                  onChanged: (value) => controller.toggleAutoMark(item),
                  activeTrackColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'auto_mark_out_of_stock'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
                onPressed: () => controller.showItemOptions(item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'low_stock':
        return 'low_stock'.tr;
      case 'healthy':
        return 'healthy'.tr;
      case 'out_of_stock':
        return 'out_of_stock'.tr;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'low_stock':
        return Colors.orange;
      case 'healthy':
        return AppTheme.successColor;
      case 'out_of_stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
