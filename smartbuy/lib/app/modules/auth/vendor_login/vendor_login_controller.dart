import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class VendorLoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final response = await _apiProvider.post(
        ApiConstants.vendorLogin,
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      _storage.write(AppConstants.storageKeyToken, response.data['token']);
      _storage.write(AppConstants.storageKeyUser, response.data['vendor']);

      Helpers.showSuccess('Vendor login successful!');
      Get.offAllNamed(Routes.VENDOR_HOME);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      Helpers.showError('field_required'.tr);
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Helpers.showError('field_required'.tr);
      return false;
    }

    return true;
  }

  void goToBuyerRegister() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToVendorRegister() {
    Get.toNamed(Routes.VENDOR_REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
