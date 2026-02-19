import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentTab = 0.obs;

  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();

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

    try {
      final response = await _apiProvider.post(
        ApiConstants.login,
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      _storage.write(AppConstants.storageKeyToken, response.data['token']);
      _storage.write(AppConstants.storageKeyUser, response.data['buyer']);

      Helpers.showSuccessSheet(
        'You\'re all set to continue shopping for the best deals.',
        title: 'Login Successful!',
        onClose: () => Get.offAllNamed(Routes.HOME),
      );
    } catch (e) {
      Helpers.showErrorSheetLogin(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
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
