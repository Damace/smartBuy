import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/theme_controller.dart';
import '../../core/utils/helpers.dart';


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
    Helpers.showBottomSheet(
      icon: Icons.security,
      iconColor: AppTheme.primaryColor,
      title: 'security'.tr,
      message:
          'Your account is protected with industry-standard encryption.\n\n'
          '• Change your password regularly\n'
          '• Enable two-factor authentication for extra protection\n'
          '• Never share your login credentials with anyone\n'
          '• Log out from shared or public devices after use',
      buttonText: 'Got it',
    );
  }

  void openNotifications() {
    Helpers.showBottomSheet(
      icon: Icons.notifications_active,
      iconColor: AppTheme.primaryColor,
      title: 'notifications'.tr,
      message:
          'Stay up to date with your SmartBuy activity.\n\n'
          '• Order updates and delivery alerts\n'
          '• Exclusive deals and flash sale reminders\n'
          '• Price drop alerts on wishlisted items\n'
          '• Account activity and security notices\n\n'
          'You can manage notification preferences in your device settings.',
      buttonText: 'Got it',
    );
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
    Helpers.showBottomSheet(
      icon: Icons.help_center,
      iconColor: AppTheme.primaryColor,
      title: 'help_center'.tr,
      message:
          'We\'re here to help you 24/7.\n\n'
          '• Browse our FAQ for quick answers\n'
          '• Chat with our support team live\n'
          '• Report an issue with your order or account\n'
          '• Track refunds and return requests\n\n'
          'Contact us: support@smartbuy.com\n'
          'Phone: +1 234 567 890',
      buttonText: 'Got it',
    );
  }

  void openTermsOfService() {
    Helpers.showBottomSheet(
      icon: Icons.description,
      iconColor: AppTheme.primaryColor,
      title: 'terms_of_service'.tr,
      message:
          'By using SmartBuy, you agree to our Terms of Service.\n\n'
          '• You must be 18+ to create an account\n'
          '• All purchases are subject to our return policy\n'
          '• Misuse of the platform may result in account suspension\n'
          '• SmartBuy is not liable for vendor product descriptions\n\n'
          'Full terms are available at smartbuy.com/terms',
      buttonText: 'Understood',
    );
  }

  void openPrivacyPolicy() {
    Helpers.showBottomSheet(
      icon: Icons.privacy_tip,
      iconColor: AppTheme.primaryColor,
      title: 'privacy_policy'.tr,
      message:
          'Your privacy matters to us.\n\n'
          '• We collect only the data needed to serve you\n'
          '• Your payment info is encrypted and never stored in plain text\n'
          '• We do not sell your personal data to third parties\n'
          '• You can request data deletion at any time\n\n'
          'Full policy available at smartbuy.com/privacy',
      buttonText: 'Understood',
    );
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
