import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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
  final RxBool isGoogleLoading = false.obs;
  final RxBool isAppleLoading = false.obs;
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
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
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

  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        isGoogleLoading.value = false;
        return;
      }

      final response = await _apiProvider.post(
        ApiConstants.googleLogin,
        data: {
          'google_id': googleUser.id,
          'email': googleUser.email,
          'name': googleUser.displayName ?? googleUser.email,
          'avatar_url': googleUser.photoUrl,
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
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    if (isAppleLoading.value) return;

    if (!Platform.isIOS && !Platform.isMacOS) {
      Helpers.showInfo('apple_sign_in_ios_only'.tr);
      return;
    }

    isAppleLoading.value = true;

    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      String? fullName;
      if (credential.givenName != null || credential.familyName != null) {
        fullName =
            '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim();
      }

      final response = await _apiProvider.post(
        ApiConstants.appleLogin,
        data: {
          'apple_id': credential.userIdentifier,
          'email': credential.email,
          'name': fullName,
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
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
          // User cancelled
          isAppleLoading.value = false;
          return;
        }
      }
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
    } finally {
      isAppleLoading.value = false;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  @override
  void onClose() {
    tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
