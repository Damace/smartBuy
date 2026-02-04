import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'buyer_orders_controller.dart';
import '../../core/themes/app_theme.dart';

class BuyerOrdersView extends GetView<BuyerOrdersController> {
  const BuyerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('my_orders'.tr),
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
                hintText: 'search_your_orders'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
                filled: true,
                fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
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
                    _buildFilterChip('all', 'all'.tr),
                    const SizedBox(width: 8),
                    _buildFilterChip('ongoing', 'ongoing'.tr),
                    const SizedBox(width: 8),
                    _buildFilterChip('completed', 'completed'.tr),
                    const SizedBox(width: 8),
                    _buildFilterChip('cancelled', 'cancelled'.tr),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Orders List
          Expanded(
            child: Obx(
              () {
                final orders = controller.filteredOrders;

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_orders_found'.tr,
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
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order);
                  },
                );
              },
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange
              : Get.isDarkMode
                  ? AppTheme.darkCardColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.orange
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

  Widget _buildOrderCard(Map<String, dynamic> order) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          _buildStatusBadge(order['status'], order['statusColor']),
          const SizedBox(height: 12),

          // Product Info
          Row(
            children: [
              // Product Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    order['productImage'],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['productName'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'placed_on'.tr} ${order['orderDate']} • \$${order['price'].toStringAsFixed(2)}',
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

          // Action Buttons
          _buildActionButtons(order),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, String statusColor) {
    Color bgColor;
    Color textColor;
    String statusText;

    switch (status) {
      case 'arriving_tomorrow':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        statusText = 'arriving_tomorrow'.tr;
        break;
      case 'delivered':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        statusText = 'delivered'.tr;
        break;
      case 'shipped':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        statusText = 'shipped'.tr;
        break;
      case 'cancelled':
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        statusText = 'cancelled'.tr;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        statusText = status;
    }

    if (Get.isDarkMode) {
      bgColor = bgColor.withValues(alpha: 0.2);
      textColor = textColor.withValues(alpha: 0.9);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> order) {
    String status = order['status'];

    if (status == 'arriving_tomorrow' || status == 'shipped') {
      // Ongoing orders: Track Order + Details
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.trackOrder(order),
              icon: const Icon(Icons.local_shipping, size: 18),
              label: Text('track_order'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.viewOrderDetails(order),
              style: OutlinedButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              child: Text('details'.tr),
            ),
          ),
        ],
      );
    } else if (status == 'delivered') {
      // Delivered orders: Buy Again + Order Details
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.buyAgain(order),
              icon: const Icon(Icons.shopping_cart, size: 18),
              label: Text('buy_again'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.viewOrderDetails(order),
              style: OutlinedButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              child: Text('order_details'.tr),
            ),
          ),
        ],
      );
    } else if (status == 'cancelled') {
      // Cancelled orders: View Cancellation Details
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => controller.viewCancellationDetails(order),
          style: OutlinedButton.styleFrom(
            foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(
              color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: Text('view_cancellation_details'.tr),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
