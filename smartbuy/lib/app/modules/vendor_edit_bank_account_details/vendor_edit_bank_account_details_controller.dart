import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class VendorEditBankAccountDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscSwiftController = TextEditingController();

  final RxString selectedBank = 'Select your bank'.obs;
  final RxBool enableWeeklyPayouts = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDeleting = false.obs;

  final List<String> banks = [
    'Select your bank',
    'Global Tech Bank',
    'First National Bank',
    'International Bank',
    'Central Bank',
    'Regional Bank',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCurrentDetails();
  }

  Future<void> _loadCurrentDetails() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorBankAccount);
      final bankAccount = response.data['bank_account'];

      if (bankAccount != null) {
        accountHolderController.text =
            bankAccount['contact_person_name'] ?? '';
        accountNumberController.text =
            bankAccount['bank_account_number'] ?? '';
        ifscSwiftController.text = bankAccount['bank_routing_number'] ?? '';

        final bankName = bankAccount['bank_name'] ?? '';
        if (banks.contains(bankName)) {
          selectedBank.value = bankName;
        }
      }
    } catch (e) {
      // Fall back to mock data
      accountHolderController.text = 'John Michael Smith';
      accountNumberController.text = '**** **** **** 1234';
      ifscSwiftController.text = 'ABC0012345';
    } finally {
      isLoading.value = false;
    }
  }

  void setBank(String? bank) {
    if (bank != null) {
      selectedBank.value = bank;
    }
  }

  void toggleWeeklyPayouts(bool value) {
    enableWeeklyPayouts.value = value;
  }

  Future<void> updateAccount() async {
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

    isSaving.value = true;
    try {
      await _apiProvider.put(
        ApiConstants.vendorBankAccount,
        data: {
          'contact_person_name': accountHolderController.text.trim(),
          'bank_name': selectedBank.value,
          'bank_account_number': accountNumberController.text.trim(),
          'bank_routing_number': ifscSwiftController.text.trim(),
        },
      );
      Helpers.showSuccess('bank_account_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAccount() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete_bank_account'.tr),
        content: Text('delete_bank_account_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isDeleting.value = true;
    try {
      await _apiProvider.delete(ApiConstants.vendorBankAccount);
      Helpers.showSuccess('bank_account_deleted_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  void onClose() {
    accountHolderController.dispose();
    accountNumberController.dispose();
    ifscSwiftController.dispose();
    super.onClose();
  }
}
