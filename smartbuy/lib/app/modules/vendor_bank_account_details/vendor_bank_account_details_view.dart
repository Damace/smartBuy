import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_bank_account_details_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorBankAccountDetailsView extends GetView<VendorBankAccountDetailsController> {
  const VendorBankAccountDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('bank_account_details'.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verified Account Banner
            _buildVerifiedBanner(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Bank Account Section
                  Text(
                    'current_bank_account'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildBankAccountInfo(),
                  const SizedBox(height: 20),

                  // Change Bank Account Button
                  _buildChangeAccountButton(),
                  const SizedBox(height: 24),

                  // Important Information
                  _buildImportantInformation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBanner() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        color: controller.isVerified.value
            ? AppTheme.successColor.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: controller.isVerified.value
                  ? AppTheme.successColor
                  : Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isVerified.value
                      ? 'verified_account'.tr
                      : 'pending_verification'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: controller.isVerified.value
                        ? AppTheme.successColor
                        : Colors.orange,
                  ),
                ),
                Text(
                  'ready_for_automatic_payouts'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.isVerified.value
                        ? AppTheme.successColor.withValues(alpha: 0.8)
                        : Colors.orange.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Get.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.person,
            'account_holder_name'.tr,
            controller.accountHolderName.value,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.account_balance,
            'bank_name'.tr,
            controller.bankName.value,
          ),
          const SizedBox(height: 16),
          _buildAccountNumberRow(),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.code,
            'ifsc_swift_code'.tr,
            controller.swiftCode.value,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Get.isDarkMode
              ? AppTheme.darkTextSecondary
              : AppTheme.textSecondary,
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
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountNumberRow() {
    final RxBool isVisible = false.obs;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock,
          size: 20,
          color: Get.isDarkMode
              ? AppTheme.darkTextSecondary
              : AppTheme.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'account_number'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  isVisible.value
                      ? '1234 5678 9012 5678'
                      : controller.accountNumber.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextPrimary
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Obx(
            () => Icon(
              isVisible.value ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ),
          onPressed: () => isVisible.toggle(),
        ),
      ],
    );
  }

  Widget _buildChangeAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.changeBankAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, size: 20),
            const SizedBox(width: 8),
            Text(
              'change_bank_account'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? AppTheme.darkCardColor
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? Colors.blue.shade800
              : Colors.blue.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Get.isDarkMode
                    ? Colors.blue.shade300
                    : Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'important_information'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode
                      ? Colors.blue.shade300
                      : Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'bank_account_important_info'.tr,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                size: 16,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'secure_256_bit_encryption'.tr,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
