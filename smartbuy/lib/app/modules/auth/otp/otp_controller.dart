import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final RxInt remainingTime = 45.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  String phone = '';
  String email = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      phone = args['phone'] ?? '';
      email = args['email'] ?? '';
    }
    startTimer();
  }

  void startTimer() {
    remainingTime.value = 45;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      Helpers.showErrorSheet('Please enter complete OTP code');
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Helpers.showSuccessSheet(
      'Your account has been verified successfully. You\'re all set!',
      title: 'Account Verified!',
      onClose: () => Get.offAllNamed(Routes.HOME),
    );
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;

    Helpers.showInfo('Sending new code...');

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    Helpers.showSuccess('New code sent!');
    startTimer();
  }

  String get formattedPhone {
    if (phone.length >= 4) {
      return '+1 (***) ***-${phone.substring(phone.length - 4)}';
    }
    return phone;
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
