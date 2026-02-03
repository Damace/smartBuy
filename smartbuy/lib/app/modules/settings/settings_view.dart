import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import '../../core/themes/app_theme.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('settings'.tr),
      ),
      body: ListView(
        children: [
          // Account Section
          _buildSectionHeader(context, 'account'.tr),
          _buildListTile(
            context,
            icon: Icons.security,
            iconColor: AppTheme.primaryColor,
            title: 'security'.tr,
            onTap: () {},
          ),
          _buildListTile(
            context,
            icon: Icons.notifications,
            iconColor: AppTheme.primaryColor,
            title: 'notifications'.tr,
            onTap: () {},
          ),
          _buildLanguageTile(context),
          const Divider(),

          // Preferences Section
          _buildSectionHeader(context, 'preferences'.tr),
          _buildDarkModeTile(context),
          _buildListTile(
            context,
            icon: Icons.monetization_on,
            iconColor: AppTheme.primaryColor,
            title: 'currency'.tr,
            trailing: 'usd'.tr,
            onTap: () {},
          ),
          _buildListTile(
            context,
            icon: Icons.public,
            iconColor: AppTheme.primaryColor,
            title: 'region'.tr,
            trailing: 'united_states'.tr,
            onTap: () {},
          ),
          const Divider(),

          // Support Section
          _buildSectionHeader(context, 'support'.tr),
          _buildListTile(
            context,
            icon: Icons.help_center,
            iconColor: AppTheme.primaryColor,
            title: 'help_center'.tr,
            isExternal: true,
            onTap: controller.openHelpCenter,
          ),
          _buildListTile(
            context,
            icon: Icons.description,
            iconColor: AppTheme.primaryColor,
            title: 'terms_of_service'.tr,
            onTap: controller.openTermsOfService,
          ),
          _buildListTile(
            context,
            icon: Icons.privacy_tip,
            iconColor: AppTheme.primaryColor,
            title: 'privacy_policy'.tr,
            onTap: controller.openPrivacyPolicy,
          ),
          const Divider(),

          // Danger Zone
          _buildSectionHeader(context, 'danger_zone'.tr, isRed: true),
          _buildListTile(
            context,
            icon: Icons.cancel,
            iconColor: AppTheme.errorColor,
            title: 'deactivate_account'.tr,
            titleColor: AppTheme.errorColor,
            onTap: controller.deactivateAccount,
          ),
          const SizedBox(height: 32),

          // App Version
          Center(
            child: Column(
              children: [
                Text(
                  'version'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'made_with_love'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: isRed ? AppTheme.errorColor : null,
            ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    String? trailing,
    bool isExternal = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          if (trailing != null) const SizedBox(width: 8),
          Icon(
            isExternal ? Icons.open_in_new : Icons.chevron_right,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    return Obx(
      () => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            controller.themeController.isDarkMode.value
                ? Icons.dark_mode
                : Icons.light_mode,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          'dark_mode'.tr,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Switch(
          value: controller.themeController.isDarkMode.value,
          onChanged: (value) => controller.toggleDarkMode(),
          activeColor: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Obx(
      () => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.language, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          'language'.tr,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.themeController.isEnglish ? 'english'.tr : 'swahili'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ],
        ),
        onTap: () => _showLanguageDialog(context),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => RadioListTile<String>(
                title: Text('english'.tr),
                value: 'en',
                groupValue: controller.themeController.isEnglish ? 'en' : 'sw',
                onChanged: (value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                    Get.back();
                  }
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
            Obx(
              () => RadioListTile<String>(
                title: Text('swahili'.tr),
                value: 'sw',
                groupValue: controller.themeController.isEnglish ? 'en' : 'sw',
                onChanged: (value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                    Get.back();
                  }
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
