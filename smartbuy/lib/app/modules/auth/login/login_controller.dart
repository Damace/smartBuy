import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

// Storage keys for biometric credential cache
const _kBioEmail = 'biometric_email';
const _kBioPassword = 'biometric_password';
const _kBioUserType = 'biometric_user_type'; // 'buyer' | 'vendor'

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isAppleLoading = false.obs;
  final RxBool isBiometricAvailable = false.obs;
  final RxBool isBiometricLoading = false.obs;

  final ApiProvider _apiProvider = ApiProvider();
  final GetStorage _storage = GetStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void onInit() {
    super.onInit();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (canCheck && isSupported) {
        final types = await _localAuth.getAvailableBiometrics();
        isBiometricAvailable.value = types.isNotEmpty &&
            _storage.read(_kBioEmail) != null;
      }
    } catch (_) {
      isBiometricAvailable.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!_validateForm()) return;
    isLoading.value = true;

    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      // Try buyer login first
      await _loginAsBuyer(email, password);
    } catch (buyerError) {
      // Buyer login failed — try vendor login
      try {
        await _loginAsVendor(email, password);
      } catch (vendorError) {
        // Both failed — show the buyer error (more likely what the user expects)
        Helpers.showError(Helpers.parseErrorMessage(buyerError));
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loginAsBuyer(String email, String password) async {
    final response = await _apiProvider.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    _storage.write(AppConstants.storageKeyToken, response.data['token']);
    _storage.write(AppConstants.storageKeyUser, response.data['buyer']);
    _saveBiometricCredentials(email, password, 'buyer');

    Helpers.showSuccessSheet(
      'You\'re all set to continue shopping for the best deals.',
      title: 'Login Successful!',
      onClose: () => Get.offAllNamed(Routes.LOADING_SCREEN),
    );
  }

  Future<void> _loginAsVendor(String email, String password) async {
    final response = await _apiProvider.post(
      ApiConstants.vendorLogin,
      data: {'email': email, 'password': password},
    );

    _storage.write(AppConstants.storageKeyToken, response.data['token']);
    _storage.write(AppConstants.storageKeyUser, response.data['vendor']);
    _saveBiometricCredentials(email, password, 'vendor');

    Helpers.showSuccess('login_successful'.tr);
    Get.offAllNamed(Routes.VENDOR_HOME);
  }

  void _saveBiometricCredentials(
      String email, String password, String userType) {
    _storage.write(_kBioEmail, email);
    _storage.write(_kBioPassword, password);
    _storage.write(_kBioUserType, userType);
    // Re-check so fingerprint button appears after first login
    _checkBiometrics();
  }

  Future<void> loginWithBiometrics() async {
    final storedEmail = _storage.read<String>(_kBioEmail);
    final storedPassword = _storage.read<String>(_kBioPassword);
    final storedUserType = _storage.read<String>(_kBioUserType);

    if (storedEmail == null || storedPassword == null) {
      Helpers.showError('biometric_no_credentials'.tr);
      return;
    }

    isBiometricLoading.value = true;
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'biometric_reason'.tr,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!authenticated) return;

      isLoading.value = true;
      if (storedUserType == 'vendor') {
        await _loginAsVendor(storedEmail, storedPassword);
      } else {
        await _loginAsBuyer(storedEmail, storedPassword);
      }
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isBiometricLoading.value = false;
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
    if (passwordController.text.length < 6) {
      Helpers.showError('password_too_short'.tr);
      return false;
    }
    return true;
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> loginWithGoogle() async {
    if (isGoogleLoading.value) return;
    isGoogleLoading.value = true;

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
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
        onClose: () => Get.offAllNamed(Routes.LOADING_SCREEN),
      );
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
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
        onClose: () => Get.offAllNamed(Routes.LOADING_SCREEN),
      );
    } catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled) {
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
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
