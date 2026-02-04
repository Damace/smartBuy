import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class BuyerEditPaymentController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryDateController = TextEditingController();

  final RxBool isPrimaryCard = false.obs;
  final RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Check if editing existing card
    if (Get.arguments != null) {
      isEditMode.value = true;
      _loadCardData(Get.arguments as Map<String, dynamic>);
    }
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryDateController.dispose();
    super.onClose();
  }

  void _loadCardData(Map<String, dynamic> card) {
    cardNumberController.text = '**** **** **** ${card['lastFourDigits'] ?? ''}';
    cardHolderController.text = card['cardHolder'] ?? '';
    expiryDateController.text = card['expiryDate'] ?? '';
    isPrimaryCard.value = card['isPrimary'] ?? false;
  }

  void togglePrimaryCard(bool value) {
    isPrimaryCard.value = value;
  }

  void saveChanges() {
    if (formKey.currentState!.validate()) {
      Helpers.showSuccess(
        isEditMode.value
            ? 'card_updated_successfully'.tr
            : 'card_added_successfully'.tr,
      );
      Get.back();
    }
  }

  void removeCard() {
    if (!isEditMode.value) return;

    Get.defaultDialog(
      title: 'remove_card'.tr,
      middleText: 'remove_card_confirmation'.tr,
      textConfirm: 'yes_remove'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(); // Go back to saved payments
        Helpers.showSuccess('card_removed'.tr);
      },
    );
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'card_number_required'.tr;
    }
    // Remove spaces and check length
    final cardNumber = value.replaceAll(' ', '');
    if (cardNumber.length < 16) {
      return 'card_number_invalid'.tr;
    }
    return null;
  }

  String? validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'cardholder_name_required'.tr;
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'expiry_date_required'.tr;
    }
    // Basic validation for MM/YY format
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'expiry_date_invalid'.tr;
    }
    return null;
  }
}
