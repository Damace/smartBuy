import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/theme_controller.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class SettingsController extends GetxController {
  final ThemeController themeController = Get.find<ThemeController>();

  void toggleDarkMode() {
    themeController.toggleTheme();
  }

  void changeLanguage(String languageCode) {
    if (languageCode == 'en') {
      themeController.setEnglish();
    } else if (languageCode == 'sw') {
      themeController.setSwahili();
    }
    Helpers.showSuccess('Language changed successfully');
  }

  void openSecurity() {
    Helpers.showInfo('security'.tr);
  }

  void openNotifications() {
    Get.toNamed(Routes.BUYER_NOTIFICATION_PREFERENCES);
  }

  void showCurrencyPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('currency'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('\$', style: TextStyle(fontSize: 20)),
              title: const Text('USD - US Dollar'),
              trailing: const Icon(Icons.check, color: AppTheme.primaryColor),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Text('TSh', style: TextStyle(fontSize: 16)),
              title: const Text('TZS - Tanzanian Shilling'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Text('KSh', style: TextStyle(fontSize: 16)),
              title: const Text('KES - Kenyan Shilling'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void showRegionPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('region'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('United States'),
              trailing: const Icon(Icons.check, color: AppTheme.primaryColor),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Text('🇹🇿', style: TextStyle(fontSize: 24)),
              title: const Text('Tanzania'),
              onTap: () => Get.back(),
            ),
            ListTile(
              leading: const Text('🇰🇪', style: TextStyle(fontSize: 24)),
              title: const Text('Kenya'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void openHelpCenter() {
    Helpers.showInfo('Opening Help Center...');
  }

  void openTermsOfService() {
    Helpers.showInfo('Opening Terms of Service...');
  }

  void openPrivacyPolicy() {
    Helpers.showInfo('Opening Privacy Policy...');
  }

  Future<void> deactivateAccount() async {
    final confirmed = await Helpers.showConfirmationDialog(
      title: 'Deactivate Account',
      message: 'Are you sure you want to deactivate your account? This action cannot be undone.',
      confirmText: 'Deactivate',
      cancelText: 'Cancel',
    );

    if (confirmed) {
      Helpers.showSuccess('Account deactivated');
      // Navigate to login
      Get.offAllNamed('/login');
    }
  }
}
