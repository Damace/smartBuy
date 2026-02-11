import 'package:dio/dio.dart' hide Response;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/providers/api_provider.dart';
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

  // Step 3 - Verification (file name for display, file path for upload)
  final RxString taxDocument = ''.obs;
  final RxString taxDocumentPath = ''.obs;
  final RxString businessProofDocument = ''.obs;
  final RxString businessProofDocumentPath = ''.obs;
  final RxString nationalIdDocument = ''.obs;
  final RxString nationalIdDocumentPath = ''.obs;

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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      taxDocument.value = result.files.single.name;
      taxDocumentPath.value = result.files.single.path!;
      Helpers.showSuccess('document_uploaded'.tr);
    }
  }

  Future<void> pickBusinessProofDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      businessProofDocument.value = result.files.single.name;
      businessProofDocumentPath.value = result.files.single.path!;
      Helpers.showSuccess('document_uploaded'.tr);
    }
  }

  Future<void> pickNationalIdDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      nationalIdDocument.value = result.files.single.name;
      nationalIdDocumentPath.value = result.files.single.path!;
      Helpers.showSuccess('document_uploaded'.tr);
    }
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

  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();

  Future<void> submitRegistration() async {
    isLoading.value = true;

    try {
      final formMap = <String, dynamic>{
        'contact_person_name': fullNameController.text.trim(),
        'email': businessEmailController.text.trim(),
        'business_phone': phoneNumberController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': passwordController.text,
        'business_name': legalBusinessNameController.text.trim(),
        'store_display_name': storeDisplayNameController.text.trim(),
        'business_type': selectedBusinessType.value,
        'business_address': businessAddressController.text.trim(),
        'bank_name': accountNameController.text.trim(),
        'bank_account_number': accountNumberController.text.trim(),
        'bank_routing_number': ifscCodeController.text.trim(),
      };

      // Attach document files
      if (taxDocumentPath.value.isNotEmpty) {
        formMap['tax_document'] =
            await MultipartFile.fromFile(taxDocumentPath.value, filename: taxDocument.value);
      }
      if (businessProofDocumentPath.value.isNotEmpty) {
        formMap['business_proof_document'] =
            await MultipartFile.fromFile(businessProofDocumentPath.value, filename: businessProofDocument.value);
      }
      if (nationalIdDocumentPath.value.isNotEmpty) {
        formMap['national_id_document'] =
            await MultipartFile.fromFile(nationalIdDocumentPath.value, filename: nationalIdDocument.value);
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiProvider.post(
        ApiConstants.vendorRegister,
        data: formData,
      );

      _storage.write(AppConstants.storageKeyToken, response.data['token']);
      _storage.write(AppConstants.storageKeyUser, response.data['vendor']);

      Helpers.showSuccess('vendor_registration_submitted'.tr);
      Get.offAllNamed(Routes.VENDOR_STATUS);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
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
