import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'buyer_track_order_controller.dart';
import '../../core/themes/app_theme.dart';

class BuyerTrackOrderView extends GetView<BuyerTrackOrderController> {
  const BuyerTrackOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Map View
          _buildMapView(),

          // Content Overlay
          Column(
            children: [
              // Top Bar with Order Number
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Order Number Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${'order'.tr} #${controller.orderData['id'] ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Info Card
              _buildBottomInfoCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    // Map placeholder - in real app, this would be Google Maps or similar
    return Container(
      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.blue.shade50,
      child: Stack(
        children: [
          // Map pattern/grid (placeholder)
          CustomPaint(
            size: Size(Get.width, Get.height * 0.6),
            painter: MapPatternPainter(),
          ),
          // Delivery marker
          Positioned(
            top: Get.height * 0.25,
            left: Get.width * 0.45,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_shipping,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // Destination marker
          Positioned(
            top: Get.height * 0.35,
            right: Get.width * 0.25,
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Estimated Arrival
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'estimated_arrival'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.estimatedArrival.value,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      controller.deliveryStatus.value,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Delivery Partner Info
            Row(
              children: [
                // Partner Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Partner Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'delivery_partner'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.deliveryPartner.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Get.isDarkMode
                                    ? AppTheme.darkTextPrimary
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.partnerRating.value.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Call Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.phone, color: Colors.white),
                    onPressed: controller.callDeliveryPartner,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Order Status
            Text(
              'order_status'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Order Status Timeline
            _buildOrderStatusTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusTimeline() {
    return Obx(
      () => Column(
        children: List.generate(
          controller.orderStatus.length,
          (index) {
            final status = controller.orderStatus[index];
            final isLast = index == controller.orderStatus.length - 1;

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
                        status['icon'],
                        color: status['isCompleted'] == true ||
                                status['isActive'] == true
                            ? Colors.white
                            : Get.isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                        size: 18,
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
                            fontSize: 14,
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
                          status['subtitle'],
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for map pattern (placeholder)
class MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Get.isDarkMode
          ? Colors.grey.shade800.withValues(alpha: 0.3)
          : Colors.grey.shade300.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw grid pattern
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
