import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_edit_bank_account_details_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorEditBankAccountDetailsView extends GetView<VendorEditBankAccountDetailsController> {
  const VendorEditBankAccountDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('edit_bank_account'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Banner
            _buildSecurityBanner(),
            const SizedBox(height: 16),

            // Info Message
            Text(
              'enter_bank_details_securely'.tr,
              style: TextStyle(
                fontSize: 13,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Account Holder Name
            _buildTextField(
              label: 'account_holder_name'.tr,
              controller: controller.accountHolderController,
            ),
            const SizedBox(height: 16),

            // Bank Name Dropdown
            Text(
              'bank_name'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedBank.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: TextStyle(
                      fontSize: 14,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                    dropdownColor: Get.isDarkMode
                        ? AppTheme.darkCardColor
                        : Colors.white,
                    items: controller.banks
                        .map((bank) => DropdownMenuItem<String>(
                              value: bank,
                              child: Text(bank),
                            ))
                        .toList(),
                    onChanged: controller.setBank,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account Number
            _buildTextField(
              label: 'account_number'.tr,
              controller: controller.accountNumberController,
            ),
            const SizedBox(height: 16),

            // IFSC/SWIFT Code
            _buildTextField(
              label: 'ifsc_swift_code'.tr,
              controller: controller.ifscSwiftController,
            ),
            const SizedBox(height: 24),

            // Enable Weekly Payouts
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'enable_weekly_payouts'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'receive_earnings_every_monday'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.enableWeeklyPayouts.value,
                      onChanged: controller.toggleWeeklyPayouts,
                      activeTrackColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Update Account Button
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'your_financial_data_is_encrypted_and_secure'.tr,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.successColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? AppTheme.darkTextPrimary
                : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.updateAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'update_account'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
