import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorEditBankAccountDetailsController extends GetxController {
  final TextEditingController accountHolderController = TextEditingController(
    text: 'John Michael Smith',
  );
  final TextEditingController accountNumberController = TextEditingController(
    text: '**** **** **** 1234',
  );
  final TextEditingController ifscSwiftController = TextEditingController(
    text: 'ABC0012345',
  );

  final RxString selectedBank = 'Select your bank'.obs;
  final RxBool enableWeeklyPayouts = true.obs;

  final List<String> banks = [
    'Select your bank',
    'Global Tech Bank',
    'First National Bank',
    'International Bank',
    'Central Bank',
    'Regional Bank',
  ];

  void setBank(String? bank) {
    if (bank != null) {
      selectedBank.value = bank;
    }
  }

  void toggleWeeklyPayouts(bool value) {
    enableWeeklyPayouts.value = value;
  }

  void updateAccount() {
    // Validate fields
    if (accountHolderController.text.isEmpty) {
      Helpers.showError('account_holder_name_required'.tr);
      return;
    }
    if (selectedBank.value == 'Select your bank') {
      Helpers.showError('bank_name_required'.tr);
      return;
    }
    if (accountNumberController.text.isEmpty) {
      Helpers.showError('account_number_required'.tr);
      return;
    }
    if (ifscSwiftController.text.isEmpty) {
      Helpers.showError('ifsc_swift_code_required'.tr);
      return;
    }

    // Update account
    Helpers.showSuccess('bank_account_updated_successfully'.tr);
    Get.back();
  }

  @override
  void onClose() {
    accountHolderController.dispose();
    accountNumberController.dispose();
    ifscSwiftController.dispose();
    super.onClose();
  }
}
