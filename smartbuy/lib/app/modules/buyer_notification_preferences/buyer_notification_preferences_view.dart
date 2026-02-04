import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'buyer_notification_preferences_controller.dart';

class BuyerNotificationPreferencesView
    extends GetView<BuyerNotificationPreferencesController> {
  const BuyerNotificationPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('notification_preferences'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // iOS Warning Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.warningColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warningColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ios_notification_warning'.tr,
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Status Updates
                _buildSectionHeader('order_status_updates'.tr),
                const SizedBox(height: 12),
                Obx(() => _buildToggleItem(
                      'push_notifications'.tr,
                      'real_time_delivery_progress'.tr,
                      controller.orderStatusPush.value,
                      (value) => controller.orderStatusPush.value = value,
                    )),
                Obx(() => _buildToggleItem(
                      'email'.tr,
                      'detailed_receipts_and_blazars'.tr,
                      controller.orderStatusEmail.value,
                      (value) => controller.orderStatusEmail.value = value,
                    )),
                Obx(() => _buildToggleItem(
                      'sms'.tr,
                      'critical_for_re_tries'.tr,
                      controller.orderStatusSms.value,
                      (value) => controller.orderStatusSms.value = value,
                    )),
                const SizedBox(height: 24),

                // Promotional Offers
                _buildSectionHeader('promotional_offers'.tr),
                const SizedBox(height: 12),
                Obx(() => _buildToggleItem(
                      'push_notifications'.tr,
                      'sales_coupons_and_discounts'.tr,
                      controller.promotionalPush.value,
                      (value) => controller.promotionalPush.value = value,
                    )),
                Obx(() => _buildToggleItem(
                      'email'.tr,
                      'weekly_curated_newsletters'.tr,
                      controller.promotionalEmail.value,
                      (value) => controller.promotionalEmail.value = value,
                    )),
                const SizedBox(height: 24),

                // Payment Alerts
                _buildSectionHeader('payment_alerts'.tr),
                const SizedBox(height: 12),
                Obx(() => _buildToggleItem(
                      'push_notifications'.tr,
                      'payment_alerts_desc'.tr,
                      controller.paymentPush.value,
                      (value) => controller.paymentPush.value = value,
                    )),
                const SizedBox(height: 24),

                // Wallet Balance Alerts
                _buildSectionHeader('wallet_balance_alerts'.tr),
                const SizedBox(height: 12),
                Obx(() => _buildToggleItem(
                      'push_notifications'.tr,
                      'low_balance_and_cashback_alerts'.tr,
                      controller.walletPush.value,
                      (value) => controller.walletPush.value = value,
                    )),
                Obx(() => _buildToggleItem(
                      'sms'.tr,
                      'instantly_sent_balance_low'.tr,
                      controller.walletSms.value,
                      (value) => controller.walletSms.value = value,
                    )),
                const SizedBox(height: 24),

                // Messages
                _buildSectionHeader('messages'.tr),
                const SizedBox(height: 12),
                Obx(() => _buildToggleItem(
                      'push_notifications'.tr,
                      'seller_and_support_messages'.tr,
                      controller.messagesPush.value,
                      (value) => controller.messagesPush.value = value,
                    )),
                Obx(() => _buildToggleItem(
                      'email'.tr,
                      'get_message_transcripts'.tr,
                      controller.messagesEmail.value,
                      (value) => controller.messagesEmail.value = value,
                    )),
              ],
            ),
          ),
          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveAllChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('save_all_changes'.tr),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'notification_changes_info'.tr,
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color:
            Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildToggleItem(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppTheme.darkBorderColor
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }
}
