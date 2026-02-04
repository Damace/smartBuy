import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class BuyerEditAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final houseNumberController = TextEditingController();
  final areaController = TextEditingController();

  final RxString selectedState = 'New York'.obs;
  final RxString selectedAddressType = 'home'.obs;
  final RxBool isEditMode = false.obs;

  final List<String> states = [
    'New York',
    'California',
    'Texas',
    'Florida',
    'Illinois',
    'Pennsylvania',
    'Ohio',
    'Washington',
  ];

  @override
  void onInit() {
    super.onInit();

    // Check if editing existing address
    if (Get.arguments != null) {
      isEditMode.value = true;
      _loadAddressData(Get.arguments as Map<String, dynamic>);
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    houseNumberController.dispose();
    areaController.dispose();
    super.onClose();
  }

  void _loadAddressData(Map<String, dynamic> address) {
    fullNameController.text = address['name'] ?? '';
    selectedAddressType.value = address['type'] ?? 'home';
    // Parse address string and populate fields (simplified)
    // In real app, you'd have structured data
  }

  void selectAddressType(String type) {
    selectedAddressType.value = type;
  }

  void updateAddress() {
    if (formKey.currentState!.validate()) {
      // Save address logic here
      Helpers.showSuccess(
        isEditMode.value
            ? 'address_updated_successfully'.tr
            : 'address_added_successfully'.tr,
      );
      Get.back();
    }
  }

  void deleteAddress() {
    if (!isEditMode.value) return;

    Get.defaultDialog(
      title: 'delete_address'.tr,
      middleText: 'delete_address_confirmation'.tr,
      textConfirm: 'yes_delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Go back to saved addresses
        Helpers.showSuccess('address_deleted'.tr);
      },
    );
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName ${'is_required'.tr}';
    }
    return null;
  }

  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'mobile_number_required'.tr;
    }
    if (value.length < 10) {
      return 'mobile_number_invalid'.tr;
    }
    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'pincode_required'.tr;
    }
    if (value.length < 5) {
      return 'pincode_invalid'.tr;
    }
    return null;
  }
}
