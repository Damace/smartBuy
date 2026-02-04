import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorInventoryAlertsController extends GetxController {
  // Stock Notifications
  final RxBool enableLowStockAlerts = true.obs;
  final TextEditingController lowStockThresholdController =
      TextEditingController(text: '10');

  // Reordering & Automation
  final RxBool automatedReorder = false.obs;
  final RxBool autoHideOutOfStock = true.obs;

  // Notification Channels
  final RxBool emailNotifications = true.obs;
  final RxBool pushNotifications = true.obs;

  void toggleLowStockAlerts(bool value) {
    enableLowStockAlerts.value = value;
  }

  void toggleAutomatedReorder(bool value) {
    automatedReorder.value = value;
  }

  void toggleAutoHideOutOfStock(bool value) {
    autoHideOutOfStock.value = value;
  }

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void saveSettings() {
    // Validate threshold
    final threshold = int.tryParse(lowStockThresholdController.text);
    if (threshold == null || threshold < 0) {
      Helpers.showError('invalid_threshold_value'.tr);
      return;
    }

    // Save settings
    Helpers.showSuccess('inventory_alert_settings_saved'.tr);
  }

  @override
  void onClose() {
    lowStockThresholdController.dispose();
    super.onClose();
  }
}
