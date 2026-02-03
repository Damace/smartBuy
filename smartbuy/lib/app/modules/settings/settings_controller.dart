import 'package:get/get.dart';
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
