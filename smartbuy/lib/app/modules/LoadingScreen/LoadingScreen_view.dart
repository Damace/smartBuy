import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'LoadingScreen_controller.dart';

class LoadingScreen extends GetView<LoadingScreenController> {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Get.isDarkMode
        ? AppTheme.darkBackgroundColor
        : AppTheme.backgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          if (controller.hasNoConnection.value) {
            return _buildNoConnection(context);
          }
          return _buildLoading(context);
        }),
      ),
    );
  }

  // ── Loading state ────────────────────────────────────────────────────────────

  Widget _buildLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 3),

          // Logo
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.30),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),

          const Spacer(flex: 2),

          // Step list
          Obx(() => Column(
                children: List.generate(
                  controller.steps.length,
                  (i) => _buildStepRow(context, controller.steps[i], i),
                ),
              )),

          const Spacer(flex: 3),

          // Subtle footer
          Text(
            'preparing_your_experience'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStepRow(
      BuildContext context, Map<String, dynamic> step, int index) {
    final state = step['state'] as String;
    final label = (step['label'] as String).tr;

    final Color iconColor;
    final Widget icon;

    switch (state) {
      case 'loading':
        iconColor = AppTheme.primaryColor;
        icon = SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        );
        break;
      case 'done':
        iconColor = AppTheme.successColor;
        icon = const Icon(Icons.check_circle_rounded,
            size: 22, color: AppTheme.successColor);
        break;
      case 'failed':
        iconColor = AppTheme.errorColor;
        icon = const Icon(Icons.cancel_rounded,
            size: 22, color: AppTheme.errorColor);
        break;
      default: // waiting
        iconColor = Get.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;
        icon = Icon(Icons.radio_button_unchecked,
            size: 22, color: iconColor);
    }

    final isActive = state == 'loading' || state == 'done';
    final textColor = isActive
        ? (Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary)
        : (Get.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Step number circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state == 'waiting'
                  ? Colors.transparent
                  : state == 'done'
                      ? AppTheme.successColor.withValues(alpha: 0.12)
                      : state == 'failed'
                          ? AppTheme.errorColor.withValues(alpha: 0.12)
                          : AppTheme.primaryColor.withValues(alpha: 0.12),
              border: Border.all(
                color: state == 'waiting'
                    ? (Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300)
                    : Colors.transparent,
              ),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 14),

          // Label
          Expanded(
            child: Text(
              label,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight:
                        state == 'loading' ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),

          // Connector line for non-last items
          if (index < controller.steps.length - 1) const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── No Connection state ──────────────────────────────────────────────────────

  Widget _buildNoConnection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.errorColor.withValues(alpha: 0.08),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: AppTheme.errorColor.withValues(alpha: 0.7),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Get.isDarkMode
                            ? AppTheme.darkBackgroundColor
                            : AppTheme.backgroundColor,
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'no_connection_title'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          Text(
            'no_connection_body'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Step list — shows which step failed
          Obx(() => Column(
                children: List.generate(
                  controller.steps.length,
                  (i) => _buildStepRow(context, controller.steps[i], i),
                ),
              )),
          const SizedBox(height: 40),

          // Retry button
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.isRetrying.value ? null : controller.retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: controller.isRetrying.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(
                    controller.isRetrying.value
                        ? 'retrying'.tr
                        : 'retry_connection'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 16),

          Text(
            'check_internet_settings'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
