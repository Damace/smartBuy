import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'buyer_order_success_controller.dart';

class BuyerOrderSuccessView extends GetView<BuyerOrderSuccessController> {
  const BuyerOrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? AppTheme.darkBackgroundColor
            : AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => controller.continueShopping(),
        ),
        title: Text('order_status'.tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Success Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Success Title
              Text(
                'order_placed_successfully'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Thank You Message
              Text(
                'thank_you_for_shopping'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode ? Colors.white70 : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Order ID Section
              _buildInfoSection(
                Icons.receipt_long_outlined,
                'order_id_label'.tr,
                controller.orderId,
                showCopy: true,
              ),

              const SizedBox(height: 16),

              // Delivery Address Section
              _buildInfoSection(
                Icons.location_on_outlined,
                'delivery_address'.tr,
                '${controller.deliveryAddress['address'] ?? ''}, ${controller.deliveryAddress['city'] ?? ''}, ${controller.deliveryAddress['state'] ?? ''} ${controller.deliveryAddress['zipCode'] ?? ''}',
              ),

              const SizedBox(height: 16),

              // Estimated Arrival Section
              _buildInfoSection(
                Icons.calendar_today_outlined,
                'estimated_arrival'.tr,
                controller.estimatedDelivery,
              ),

              const SizedBox(height: 32),

              // Delivery Map Placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Map placeholder with route line
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor.withValues(alpha: 0.1),
                              AppTheme.primaryColor.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                      // Route illustration
                      CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _DeliveryRoutePainter(),
                      ),
                      // Start point (Store)
                      Positioned(
                        left: 40,
                        top: 40,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.store, color: Colors.white, size: 20),
                        ),
                      ),
                      // End point (Destination)
                      Positioned(
                        right: 40,
                        bottom: 40,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.location_on, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Track Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.trackOrder,
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: Text('track_order'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Continue Shopping Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: controller.continueShopping,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(color: AppTheme.primaryColor, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('continue_shopping'.tr),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    IconData icon,
    String label,
    String value, {
    bool showCopy = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.isDarkMode ? Colors.white60 : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (showCopy)
            IconButton(
              icon: Icon(
                Icons.copy,
                size: 20,
                color: Get.isDarkMode ? Colors.white60 : AppTheme.textSecondary,
              ),
              onPressed: () {
                // Copy to clipboard functionality
              },
            ),
        ],
      ),
    );
  }
}

// Custom painter for delivery route line
class _DeliveryRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(60, 60);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width - 60,
      size.height - 60,
    );

    // Draw dashed line
    const dashWidth = 10;
    const dashSpace = 5;
    double distance = 0;
    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final segment = pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
