import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  Future<void> register() async {
    if (!_validateForm()) return;

    if (!agreeToTerms.value) {
      Helpers.showErrorSheet('please_agree_terms'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiProvider.post(
        ApiConstants.register,
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text,
          'password_confirmation': passwordController.text,
        },
      );

      _storage.write(AppConstants.storageKeyToken, response.data['token']);
      _storage.write(AppConstants.storageKeyUser, response.data['buyer']);

      Helpers.showSuccessSheet(
        'Your account has been created successfully.',
        title: 'Welcome!',
        onClose: () => Get.offAllNamed(Routes.HOME),
      );
    } catch (e) {
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (!Helpers.isValidEmail(emailController.text)) {
      Helpers.showErrorSheet('invalid_email'.tr);
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (passwordController.text.length < 8) {
      Helpers.showErrorSheet('password_too_short'.tr);
      return false;
    }

    return true;
  }

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
