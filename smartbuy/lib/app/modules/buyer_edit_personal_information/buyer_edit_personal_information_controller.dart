import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class BuyerEditPersonalInformationController extends GetxController {
  final storage = GetStorage();
  final ApiProvider _apiProvider = ApiProvider();
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable values
  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedGender = 'Female'.obs;
  final RxBool isEmailVerified = true.obs;
  final RxBool isBuyerAccount = true.obs;
  final RxString profilePhotoUrl = ''.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isUploadingPhoto = false.obs;
  final RxBool isFromServer = false.obs;

  // Country codes
  final List<String> countryCodes = [
    '+254', // Kenya
    '+255', // Tanzania
    '+256', // Uganda
    '+250', // Rwanda
    '+251', // Ethiopia
    '+1',   // USA/Canada
    '+44',  // UK
    '+91',  // India
    '+27',  // South Africa
    '+234', // Nigeria
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
    fetchProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.buyerProfile);

      final data = response.data;
      if (data is! Map) throw Exception('Invalid response format');
      final buyer = data['buyer'];
      if (buyer is! Map) throw Exception('Buyer data not found');

      fullNameController.text = buyer['name']?.toString() ?? '';
      emailController.text = buyer['email']?.toString() ?? '';
      phoneController.text = buyer['phone']?.toString() ?? '';

      final code = buyer['country_code']?.toString() ?? '';
      selectedCountryCode.value =
          countryCodes.contains(code) ? code : countryCodes.first;

      final gender = buyer['gender']?.toString() ?? '';
      selectedGender.value =
          genderOptions.contains(gender) ? gender : genderOptions[1];

      isEmailVerified.value = buyer['email_verified'] == true;
      profilePhotoUrl.value = buyer['profile_photo']?.toString() ?? '';
      isBuyerAccount.value = buyer['status']?.toString() == 'active';
      isFromServer.value = true;

      // Keep local storage in sync with server data
      _saveToStorage(Map<String, dynamic>.from(buyer));
    } catch (e) {
      isFromServer.value = false;
      _loadFromStorage();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile(silent: true);
  }

  void _loadFromStorage() {
    final userData = storage.read(AppConstants.storageKeyUser);
    if (userData is Map) {
      fullNameController.text = userData['name']?.toString() ?? '';
      emailController.text = userData['email']?.toString() ?? '';
      phoneController.text = userData['phone']?.toString() ?? '';

      final code = userData['country_code']?.toString() ?? '';
      selectedCountryCode.value =
          countryCodes.contains(code) ? code : countryCodes.first;

      final gender = userData['gender']?.toString() ?? '';
      selectedGender.value =
          genderOptions.contains(gender) ? gender : genderOptions[1];

      isEmailVerified.value = userData['email_verified'] == true;
      profilePhotoUrl.value =
          (userData['profile_photo'] ?? userData['avatar_url'])?.toString() ?? '';
      isBuyerAccount.value = userData['status']?.toString() == 'active';
    }
  }

  void _saveToStorage(Map<String, dynamic> buyer) {
    final existing =
        storage.read(AppConstants.storageKeyUser) as Map? ?? {};
    storage.write(AppConstants.storageKeyUser, {
      ...existing,
      ...buyer,
    });
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
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('take_photo'.tr),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('choose_from_gallery'.tr),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image == null) return;

      isUploadingPhoto.value = true;

      final response = await _apiProvider.uploadFile(
        ApiConstants.buyerProfilePhoto,
        image.path,
        fileKey: 'photo',
      );

      final photoUrl = response.data['profile_photo'] ?? '';
      profilePhotoUrl.value = photoUrl;

      Helpers.showSuccess('photo_updated_successfully'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  Future<void> updateProfile() async {
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

    isSaving.value = true;
    try {
      await _apiProvider.put(
        ApiConstants.buyerProfile,
        data: {
          'name': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'country_code': selectedCountryCode.value,
          'gender': selectedGender.value,
        },
      );

      // Keep local storage in sync
      _saveToStorage({
        'name': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'country_code': selectedCountryCode.value,
        'gender': selectedGender.value,
      });

      Helpers.showSuccess('profile_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }
}
