import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'buyer_order_details_controller.dart';
import '../../core/themes/app_theme.dart';

class BuyerOrderDetailsView extends GetView<BuyerOrderDetailsController> {
  const BuyerOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('${'order'.tr} #${controller.orderData['id'] ?? ''}'),
        actions: [
          TextButton(
            onPressed: controller.getHelp,
            child: Text(
              'help'.tr,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Date
            Text(
              '${'placed_on'.tr} ${controller.orderData['orderDate'] ?? ''}',
              style: TextStyle(
                fontSize: 13,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Tracking Status Section
            Text(
              'tracking_status'.tr.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Tracking Timeline
            _buildTrackingTimeline(),
            const SizedBox(height: 32),

            // Shipping Address
            _buildShippingAddress(),
            const SizedBox(height: 20),

            // Payment Details
            _buildPaymentDetails(),
            const SizedBox(height: 24),

            // Buy It Again Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.buyItAgain,
                icon: const Icon(Icons.refresh, size: 20),
                label: Text('buy_it_again'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Download Invoice Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.downloadInvoice,
                icon: const Icon(Icons.download, size: 20),
                label: Text('download_invoice'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Get.isDarkMode ? Colors.white : Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Obx(
      () => Column(
        children: List.generate(
          controller.trackingStatus.length,
          (index) {
            final status = controller.trackingStatus[index];
            final isLast = index == controller.trackingStatus.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline Indicator
                Column(
                  children: [
                    // Circle Icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: status['isCompleted'] == true
                            ? Colors.orange
                            : status['isActive'] == true
                                ? Colors.orange
                                : Get.isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        status['isCompleted'] == true
                            ? Icons.check
                            : status['isActive'] == true
                                ? Icons.local_shipping
                                : Icons.circle,
                        color: status['isCompleted'] == true ||
                                status['isActive'] == true
                            ? Colors.white
                            : Get.isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                        size: status['isActive'] == true ? 18 : 16,
                      ),
                    ),
                    // Connecting Line
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: status['isCompleted'] == true
                            ? Colors.orange
                            : Get.isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Status Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: status['isActive'] == true
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status['time'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShippingAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'shipping_address'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.shippingName.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.shippingAddress.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'payment_details'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color:
                Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.credit_card,
                  color: Get.isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.paymentMethod.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.paymentDate.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
