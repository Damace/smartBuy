import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorStorePoliciesController extends GetxController {
  // Return Settings
  final RxBool acceptReturns = true.obs;
  final TextEditingController returnPolicyController = TextEditingController(
    text: 'Describe your return conditions, timeframes, and process...',
  );

  // Refund Details
  final TextEditingController refundPolicyController = TextEditingController(
    text: 'Outline your refund process and expected timelines...',
  );

  // Shipping Logistics
  final RxBool freeShippingEnabled = false.obs;
  final TextEditingController minimumOrderAmountController =
      TextEditingController(text: 'e.g. 50.00');
  final TextEditingController shippingTimelineController = TextEditingController(
    text: 'Example: Orders are processed within 24 hours and delivered in 3-5 business days...',
  );

  void toggleAcceptReturns(bool value) {
    acceptReturns.value = value;
  }

  void toggleFreeShipping(bool value) {
    freeShippingEnabled.value = value;
  }

  void savePolicies() {
    // Validate and save policies
    Helpers.showSuccess('store_policies_saved'.tr);
  }

  @override
  void onClose() {
    returnPolicyController.dispose();
    refundPolicyController.dispose();
    minimumOrderAmountController.dispose();
    shippingTimelineController.dispose();
    super.onClose();
  }
}
