import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class BuyerCheckoutController extends GetxController {
  final TextEditingController promoCodeController = TextEditingController();

  final RxInt currentStep = 2.obs; // 0: Address, 1: Payment, 2: Review
  final RxString selectedDeliverySpeed = 'free'.obs;

  // Delivery Address
  final RxMap<String, dynamic> deliveryAddress = <String, dynamic>{
    'name': 'Alex Johnson',
    'address': '844 Ritter Lake Suite 052',
    'city': 'Redwood City',
    'state': 'CA',
    'zipCode': '94063',
  }.obs;

  // Cart Items (from previous cart)
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'PS 5 Wireless Headphones',
      'price': 380.00,
      'quantity': 1,
      'image': 'assets/images/headphones.png',
    },
    {
      'id': '2',
      'name': 'Huger-Cloth Mouse',
      'price': 25.00,
      'quantity': 1,
      'image': 'assets/images/mouse.png',
    },
  ].obs;

  // Pricing
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble estimatedTax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    calculatePricing();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  void calculatePricing() {
    // Calculate subtotal
    double sub = 0.0;
    for (var item in cartItems) {
      sub += (item['price'] as double) * (item['quantity'] as int);
    }
    subtotal.value = sub;

    // Calculate shipping
    if (selectedDeliverySpeed.value == 'free') {
      shipping.value = 0.0;
    } else {
      shipping.value = 9.99;
    }

    // Calculate tax (8% of subtotal)
    estimatedTax.value = subtotal.value * 0.08;

    // Calculate total
    total.value = subtotal.value + shipping.value + estimatedTax.value - discount.value;
  }

  void selectDeliverySpeed(String speed) {
    selectedDeliverySpeed.value = speed;
    calculatePricing();
  }

  void changeAddress() {
    Get.toNamed(Routes.BUYER_SAVED_ADDRESS);
  }

  void applyPromoCode() {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      Helpers.showError('promo_code_required'.tr);
      return;
    }

    // Simulate promo code validation
    if (code.toLowerCase() == 'save10') {
      discount.value = subtotal.value * 0.1; // 10% discount
      calculatePricing();
      Helpers.showSuccess('promo_code_applied'.tr);
      promoCodeController.clear();
    } else {
      Helpers.showError('invalid_promo_code'.tr);
    }
  }

  void placeOrder() {
    // Navigate to order success screen
    Get.toNamed(
      '/buyer-order-success',
      arguments: {
        'orderId': '#18-40210',
        'totalAmount': total.value,
        'deliveryAddress': deliveryAddress,
        'estimatedDelivery': 'Oct 24 - Oct 30',
      },
    );
  }
}
