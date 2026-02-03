import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      currentTab.value = tabController.index;
      // Navigate to Vendor Login when Vendor tab is selected
      if (tabController.index == 1) {
        goToVendorLogin();
      }
    });
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Helpers.showSuccessSheet(
      'You\'re all set to continue shopping for the best deals.',
      title: 'Login Successful!',
      onClose: () => Get.offAllNamed(Routes.HOME),
    );
  }

  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Helpers.showErrorSheet('field_required'.tr);
      return false;
    }

    if (passwordController.text.length < 6) {
      Helpers.showErrorSheet('password_too_short'.tr);
      return false;
    }

    return true;
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToVendorLogin() {
    Get.toNamed(Routes.VENDOR_LOGIN);
  }

  void loginWithGoogle() {
    Helpers.showInfo('Coming soon');
  }

  void loginWithApple() {
    Helpers.showInfo('Coming soon');
  }

  @override
  void onClose() {
    tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
