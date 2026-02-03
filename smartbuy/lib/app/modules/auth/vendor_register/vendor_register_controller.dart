import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_pages.dart';

class VendorRegisterController extends GetxController {
  final RxInt currentStep = 1.obs;
  final RxInt totalSteps = 3.obs;
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString selectedCountryCode = '+1'.obs;
  final RxString passwordStrength = ''.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool agreeToSellerAgreement = false.obs;
  final RxString selectedBusinessType = ''.obs;

  // Step 1 - Account Setup Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Step 2 - Business Details Controllers
  final TextEditingController legalBusinessNameController = TextEditingController();
  final TextEditingController storeDisplayNameController = TextEditingController();
  final TextEditingController businessAddressController = TextEditingController();

  // Step 3 - Verification
  final RxString taxDocument = ''.obs;
  final RxString businessProofDocument = ''.obs;
  final RxString nationalIdDocument = ''.obs;

  // Payout Details
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();

  // Business Types
  final List<String> businessTypes = [
    'Sole Proprietorship',
    'Partnership',
    'Limited Liability Company (LLC)',
    'Corporation',
    'Cooperative',
    'Other',
  ];

  double get progressPercentage => (currentStep.value / totalSteps.value) * 100;

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_checkPasswordStrength);

    // Set default payout details for demo
    accountNameController.text = 'Global Tech Ventures';
    accountNumberController.text = '************4592';
    ifscCodeController.text = 'SBIN0001234';
  }

  void _checkPasswordStrength() {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordStrength.value = '';
    } else if (password.length < 6) {
      passwordStrength.value = 'Weak';
    } else if (password.length < 8) {
      passwordStrength.value = 'Medium';
    } else if (password.length >= 8 && _hasNumbersAndSymbols(password)) {
      passwordStrength.value = 'Strong';
    } else {
      passwordStrength.value = 'Medium';
    }
  }

  bool _hasNumbersAndSymbols(String password) {
    return password.contains(RegExp(r'[0-9]')) &&
           password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  Color getPasswordStrengthColor() {
    switch (passwordStrength.value) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleTermsAgreement() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  void toggleSellerAgreement() {
    agreeToSellerAgreement.value = !agreeToSellerAgreement.value;
  }

  void selectBusinessType(String? type) {
    if (type != null) {
      selectedBusinessType.value = type;
    }
  }

  Future<void> pickTaxDocument() async {
    // Simulate file picker
    await Future.delayed(const Duration(milliseconds: 500));
    taxDocument.value = 'tax_certificate.pdf';
    Helpers.showSuccess('document_uploaded'.tr);
  }

  Future<void> pickBusinessProofDocument() async {
    // Simulate file picker
    await Future.delayed(const Duration(milliseconds: 500));
    businessProofDocument.value = 'business_license.pdf';
    Helpers.showSuccess('document_uploaded'.tr);
  }

  Future<void> pickNationalIdDocument() async {
    // Simulate file picker
    await Future.delayed(const Duration(milliseconds: 500));
    nationalIdDocument.value = 'passport.pdf';
    Helpers.showSuccess('document_uploaded'.tr);
  }

  void nextStep() {
    if (_validateCurrentStep()) {
      if (currentStep.value < totalSteps.value) {
        currentStep.value++;
      } else {
        submitRegistration();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 1:
        return _validateStep1();
      case 2:
        return _validateStep2();
      case 3:
        return _validateStep3();
      default:
        return true;
    }
  }

  bool _validateStep1() {
    if (fullNameController.text.trim().isEmpty) {
      Helpers.showError('please_enter_full_name'.tr);
      return false;
    }
    if (businessEmailController.text.trim().isEmpty) {
      Helpers.showError('please_enter_business_email'.tr);
      return false;
    }
    if (!GetUtils.isEmail(businessEmailController.text.trim())) {
      Helpers.showError('please_enter_valid_email'.tr);
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      Helpers.showError('please_enter_phone'.tr);
      return false;
    }
    if (passwordController.text.isEmpty) {
      Helpers.showError('please_enter_password'.tr);
      return false;
    }
    if (passwordController.text.length < 8) {
      Helpers.showError('password_min_length'.tr);
      return false;
    }
    if (!agreeToTerms.value) {
      Helpers.showError('please_agree_terms'.tr);
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (legalBusinessNameController.text.trim().isEmpty) {
      Helpers.showError('please_enter_legal_business_name'.tr);
      return false;
    }
    if (storeDisplayNameController.text.trim().isEmpty) {
      Helpers.showError('please_enter_store_name'.tr);
      return false;
    }
    if (selectedBusinessType.value.isEmpty) {
      Helpers.showError('please_select_business_type'.tr);
      return false;
    }
    if (businessAddressController.text.trim().isEmpty) {
      Helpers.showError('please_enter_business_address'.tr);
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (taxDocument.value.isEmpty) {
      Helpers.showError('please_upload_tax_document'.tr);
      return false;
    }
    if (businessProofDocument.value.isEmpty) {
      Helpers.showError('please_upload_business_proof'.tr);
      return false;
    }
    if (nationalIdDocument.value.isEmpty) {
      Helpers.showError('please_upload_national_id'.tr);
      return false;
    }
    if (accountNameController.text.trim().isEmpty ||
        accountNumberController.text.trim().isEmpty ||
        ifscCodeController.text.trim().isEmpty) {
      Helpers.showError('please_complete_payout_details'.tr);
      return false;
    }
    if (!agreeToSellerAgreement.value) {
      Helpers.showError('please_agree_seller_agreement'.tr);
      return false;
    }
    return true;
  }

  Future<void> submitRegistration() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Helpers.showSuccess('vendor_registration_submitted'.tr);
    Get.offAllNamed(Routes.VENDOR_STATUS);
  }

  void navigateToLogin() {
    Get.toNamed(Routes.VENDOR_LOGIN);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    businessEmailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    legalBusinessNameController.dispose();
    storeDisplayNameController.dispose();
    businessAddressController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    super.onClose();
  }
}
