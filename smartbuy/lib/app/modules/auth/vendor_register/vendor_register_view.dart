import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_register_controller.dart';
import '../../../core/themes/app_theme.dart';

class VendorRegisterView extends GetView<VendorRegisterController> {
  const VendorRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.previousStep,
        ),
        title: Text('vendor_registration'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Obx(() => _buildProgressIndicator(context)),

          // Step Content
          Expanded(
            child: Obx(() => _buildStepContent(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // Step indicator text or dots
          Obx(
            () => controller.currentStep.value == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.totalSteps.value,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == 0 ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? AppTheme.primaryColor
                              : Get.isDarkMode
                                  ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                                  : AppTheme.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  )
                : Text(
                    'Step ${controller.currentStep.value}: ${_getStepTitle()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
          ),
          const SizedBox(height: 12),

          // Progress bar for steps 2 and 3
          if (controller.currentStep.value > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: controller.progressPercentage / 100,
                      backgroundColor: Get.isDarkMode
                          ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                          : AppTheme.textSecondary.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${controller.currentStep.value}/${controller.totalSteps.value}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (controller.currentStep.value) {
      case 1:
        return 'step_1_account_setup'.tr;
      case 2:
        return 'step_2_business_details'.tr;
      case 3:
        return 'step_3_verification'.tr;
      default:
        return '';
    }
  }

  Widget _buildStepContent(BuildContext context) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildStep1(context);
      case 2:
        return _buildStep2(context);
      case 3:
        return _buildStep3(context);
      default:
        return const SizedBox();
    }
  }

  // Step 1: Account Setup
  Widget _buildStep1(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'step_1_account_setup'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'join_smartbuy_sellers'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 32),

          // Full Name
          _buildLabel('full_name'.tr),
          const SizedBox(height: 8),
          TextField(
            controller: controller.fullNameController,
            decoration: InputDecoration(
              hintText: 'john_doe'.tr,
            ),
          ),
          const SizedBox(height: 20),

          // Business Email
          _buildLabel('business_email'.tr),
          const SizedBox(height: 8),
          TextField(
            controller: controller.businessEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'business_email_placeholder'.tr,
            ),
          ),
          const SizedBox(height: 20),

          // Phone Number
          _buildLabel('phone_number'.tr),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                        : AppTheme.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedCountryCode.value,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: '+1', child: Text('+1')),
                        DropdownMenuItem(value: '+44', child: Text('+44')),
                        DropdownMenuItem(value: '+91', child: Text('+91')),
                        DropdownMenuItem(value: '+254', child: Text('+254')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedCountryCode.value = value;
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller.phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'phone_placeholder'.tr,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password
          _buildLabel('password'.tr),
          const SizedBox(height: 8),
          Obx(
            () => TextField(
              controller: controller.passwordController,
              obscureText: controller.obscurePassword.value,
              decoration: InputDecoration(
                hintText: '••••••••••',
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Password Strength
          Obx(
            () => controller.passwordStrength.value.isNotEmpty
                ? Row(
                    children: [
                      Text(
                        '${'password_strength'.tr}: ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        controller.passwordStrength.value.toLowerCase().tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: controller.getPasswordStrengthColor(),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 4),
          Text(
            'password_hint'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 24),

          // Terms Checkbox
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.agreeToTerms.value,
                    onChanged: (_) => controller.toggleTermsAgreement(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'i_agree_to'.tr),
                        TextSpan(
                          text: 'seller_terms'.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(text: 'and'.tr),
                        TextSpan(
                          text: 'privacy_policy'.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Create Account Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.nextStep,
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
                  Text(
                    'create_vendor_account'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Already have account
          Center(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(text: 'already_have_vendor_account'.tr),
                  TextSpan(
                    text: 'log_in'.tr,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = controller.navigateToLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Business Details
  Widget _buildStep2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'business_details'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'provide_business_info'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 32),

          // Legal Business Name
          _buildLabel('legal_business_name'.tr),
          const SizedBox(height: 8),
          TextField(
            controller: controller.legalBusinessNameController,
            decoration: InputDecoration(
              hintText: 'business_name_placeholder'.tr,
            ),
          ),
          const SizedBox(height: 20),

          // Store Display Name
          _buildLabel('store_display_name'.tr),
          const SizedBox(height: 8),
          TextField(
            controller: controller.storeDisplayNameController,
            decoration: InputDecoration(
              hintText: 'store_name_placeholder'.tr,
            ),
          ),
          const SizedBox(height: 20),

          // Business Type
          _buildLabel('business_type'.tr),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                      : AppTheme.borderColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedBusinessType.value.isEmpty
                      ? null
                      : controller.selectedBusinessType.value,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'select_business_type'.tr,
                      style: TextStyle(
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  items: controller.businessTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),
                  onChanged: controller.selectBusinessType,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Registered Business Address
          _buildLabel('registered_business_address'.tr),
          const SizedBox(height: 8),
          TextField(
            controller: controller.businessAddressController,
            decoration: InputDecoration(
              hintText: 'search_address_manually'.tr,
              prefixIcon: const Icon(
                Icons.search,
                color: AppTheme.primaryColor,
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            'address_tax_note'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 40),

          // Save & Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.nextStep,
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
                  Text(
                    'save_continue'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Verification
  Widget _buildStep3(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'upload_documents'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'kyc_compliance_note'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 24),

          // Tax ID / GST
          Obx(
            () => _buildDocumentUpload(
              context,
              icon: Icons.description_outlined,
              title: 'tax_id_gst'.tr,
              subtitle: 'pdf_jpg_5mb'.tr,
              isUploaded: controller.taxDocument.value.isNotEmpty,
              onTap: controller.pickTaxDocument,
            ),
          ),
          const SizedBox(height: 16),

          // Business Proof
          Obx(
            () => _buildDocumentUpload(
              context,
              icon: Icons.business_outlined,
              title: 'business_proof'.tr,
              subtitle: 'certified_business_proof'.tr,
              isUploaded: controller.businessProofDocument.value.isNotEmpty,
              onTap: controller.pickBusinessProofDocument,
            ),
          ),
          const SizedBox(height: 16),

          // National ID
          Obx(
            () => _buildDocumentUpload(
              context,
              icon: Icons.badge_outlined,
              title: 'national_id'.tr,
              subtitle: 'passport_govt_id'.tr,
              isUploaded: controller.nationalIdDocument.value.isNotEmpty,
              onTap: controller.pickNationalIdDocument,
            ),
          ),
          const SizedBox(height: 32),

          // Verify Payout Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'verify_payout_details'.tr,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'edit'.tr,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Payout Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                    : AppTheme.borderColor,
              ),
            ),
            child: Column(
              children: [
                _buildPayoutDetailRow('account_name'.tr, controller.accountNameController.text),
                const SizedBox(height: 12),
                _buildPayoutDetailRow('account_number'.tr, controller.accountNumberController.text),
                const SizedBox(height: 12),
                _buildPayoutDetailRow('ifsc_code'.tr, controller.ifscCodeController.text),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seller Agreement Checkbox
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.agreeToSellerAgreement.value,
                    onChanged: (_) => controller.toggleSellerAgreement(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(text: 'i_agree_to'.tr),
                        TextSpan(
                          text: 'marketplace_seller_agreement'.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(text: 'confirm_details_accurate'.tr),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'submit_for_verification'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildDocumentUpload(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary.withValues(alpha: 0.3)
                : AppTheme.borderColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isUploaded
                    ? AppTheme.successColor.withValues(alpha: 0.1)
                    : AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isUploaded ? '✓' : 'upload'.tr,
                style: TextStyle(
                  color: isUploaded ? AppTheme.successColor : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
