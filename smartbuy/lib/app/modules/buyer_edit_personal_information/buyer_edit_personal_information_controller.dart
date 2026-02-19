import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_constants.dart';
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
    fetchProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.buyerProfile);
      final buyer = response.data['buyer'];

      fullNameController.text = buyer['name'] ?? '';
      emailController.text = buyer['email'] ?? '';
      phoneController.text = buyer['phone'] ?? '';
      selectedCountryCode.value = buyer['country_code'] ?? '+1';
      selectedGender.value = buyer['gender'] ?? 'Female';
      isEmailVerified.value = buyer['email_verified'] ?? false;
      profilePhotoUrl.value = buyer['profile_photo'] ?? '';
      isBuyerAccount.value = buyer['status'] == 'active';
    } catch (e) {
      _loadFromStorage();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFromStorage() {
    fullNameController.text = storage.read('fullName') ?? 'Alex Johnson';
    emailController.text =
        storage.read('email') ?? 'alex.johnson@example.com';
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

      // Also save to local storage
      storage.write('fullName', fullNameController.text);
      storage.write('email', emailController.text);
      storage.write('phone', phoneController.text);
      storage.write('countryCode', selectedCountryCode.value);
      storage.write('gender', selectedGender.value);

      Helpers.showSuccess('profile_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }
}
