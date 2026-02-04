import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/helpers.dart';

class BuyerEditPersonalInformationController extends GetxController {
  final storage = GetStorage();

  // Form controllers
  final TextEditingController fullNameController = TextEditingController(
    text: 'Alex Johnson',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'alex.johnson@example.com',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '202-555-0123',
  );

  // Observable values
  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedGender = 'Female'.obs;
  final RxBool isEmailVerified = true.obs;
  final RxBool isBuyerAccount = true.obs;
  final RxString profilePhotoUrl = ''.obs;

  // Country codes
  final List<String> countryCodes = [
    '+1',
    '+44',
    '+254',
    '+91',
    '+86',
    '+81',
  ];

  // Gender options
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
  ];

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void loadUserData() {
    // Load user data from storage
    fullNameController.text = storage.read('fullName') ?? 'Alex Johnson';
    emailController.text = storage.read('email') ?? 'alex.johnson@example.com';
    phoneController.text = storage.read('phone') ?? '202-555-0123';
    selectedCountryCode.value = storage.read('countryCode') ?? '+1';
    selectedGender.value = storage.read('gender') ?? 'Female';
    isEmailVerified.value = storage.read('emailVerified') ?? true;
    isBuyerAccount.value = storage.read('isBuyerAccount') ?? true;
    profilePhotoUrl.value = storage.read('profilePhoto') ?? '';
  }

  void setCountryCode(String? code) {
    if (code != null) {
      selectedCountryCode.value = code;
    }
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void changePhoto() {
    // Simulate photo change
    Helpers.showInfo('photo_upload_feature_coming_soon'.tr);
  }

  void updateProfile() {
    // Validate fields
    if (fullNameController.text.isEmpty) {
      Helpers.showError('full_name_required'.tr);
      return;
    }

    if (emailController.text.isEmpty) {
      Helpers.showError('email_required'.tr);
      return;
    }

    if (phoneController.text.isEmpty) {
      Helpers.showError('phone_number_required'.tr);
      return;
    }

    // Save user data
    storage.write('fullName', fullNameController.text);
    storage.write('email', emailController.text);
    storage.write('phone', phoneController.text);
    storage.write('countryCode', selectedCountryCode.value);
    storage.write('gender', selectedGender.value);

    Helpers.showSuccess('profile_updated_successfully'.tr);
    Get.back();
  }
}
