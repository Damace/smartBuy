import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // Navigate to OTP verification
    Get.toNamed(Routes.OTP, arguments: {
      'phone': phoneController.text,
      'email': emailController.text,
    });
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
