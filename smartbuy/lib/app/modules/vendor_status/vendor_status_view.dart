import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_status_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorStatusView extends GetView<VendorStatusController> {
  const VendorStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.backToHome,
        ),
        title: Text('application_status'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Status Icon
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Status Title
            Text(
              'application_under_review'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 16),

            // Status Description
            Text(
              'verification_process_note'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 40),

            // Registration Progress Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'registration_progress'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Progress Timeline
            Obx(
              () => Column(
                children: List.generate(
                  controller.progressSteps.length,
                  (index) => _buildProgressStep(
                    context,
                    controller.progressSteps[index],
                    isLast: index == controller.progressSteps.length - 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Contact Support Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.contactSupport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.support_agent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'contact_support'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Back to Home Link
            TextButton(
              onPressed: controller.backToHome,
              child: Text(
                'back_to_home'.tr,
                style: TextStyle(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(
    BuildContext context,
    ProgressStep step,
    {required bool isLast}
  ) {
    Color iconColor;
    IconData iconData;
    Color lineColor;

    switch (step.status) {
      case StepStatus.completed:
        iconColor = AppTheme.successColor;
        iconData = Icons.check_circle;
        lineColor = AppTheme.successColor;
        break;
      case StepStatus.inProgress:
        iconColor = AppTheme.primaryColor;
        iconData = Icons.circle;
        lineColor = Get.isDarkMode
            ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
            : AppTheme.borderColor;
        break;
      case StepStatus.pending:
        iconColor = Get.isDarkMode
            ? AppTheme.darkTextSecondary.withValues(alpha: 0.5)
            : AppTheme.textSecondary.withValues(alpha: 0.5);
        iconData = Icons.circle_outlined;
        lineColor = Get.isDarkMode
            ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
            : AppTheme.borderColor;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: 28,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: lineColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Step content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: step.status == StepStatus.pending
                              ? (Get.isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.textSecondary)
                              : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
