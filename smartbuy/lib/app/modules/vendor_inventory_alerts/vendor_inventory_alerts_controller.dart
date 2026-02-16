import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class VendorInventoryAlertsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorSettings);
      final settings = response.data['settings'];

      if (settings != null) {
        enableLowStockAlerts.value = settings['low_stock_alerts'] ?? true;
        lowStockThresholdController.text =
            (settings['low_stock_threshold'] ?? 10).toString();
        automatedReorder.value = settings['automated_reorder'] ?? false;
        autoHideOutOfStock.value = settings['auto_hide_out_of_stock'] ?? true;
        emailNotifications.value = settings['email_notifications'] ?? true;
        pushNotifications.value = settings['push_notifications'] ?? true;
      }
    } catch (e) {
      // Keep defaults on error
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> saveSettings() async {
    // Validate threshold
    final threshold = int.tryParse(lowStockThresholdController.text);
    if (threshold == null || threshold < 0) {
      Helpers.showError('invalid_threshold_value'.tr);
      return;
    }

    isSaving.value = true;
    try {
      await _apiProvider.put(
        ApiConstants.vendorSettings,
        data: {
          'low_stock_alerts': enableLowStockAlerts.value,
          'low_stock_threshold': threshold,
          'automated_reorder': automatedReorder.value,
          'auto_hide_out_of_stock': autoHideOutOfStock.value,
          'email_notifications': emailNotifications.value,
          'push_notifications': pushNotifications.value,
        },
      );
      Helpers.showSuccess('inventory_alert_settings_saved'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    lowStockThresholdController.dispose();
    super.onClose();
  }
}
