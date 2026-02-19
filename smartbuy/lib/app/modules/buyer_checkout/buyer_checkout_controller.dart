import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class BuyerCheckoutController extends GetxController {
  final TextEditingController promoCodeController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();

  final RxInt currentStep = 2.obs; // 0: Address, 1: Payment, 2: Review
  final RxString selectedDeliverySpeed = 'free'.obs;
  final RxBool isPlacingOrder = false.obs;
  final RxBool isApplyingPromo = false.obs;

  // Delivery Address
  final RxMap<String, dynamic> deliveryAddress = <String, dynamic>{}.obs;

  // Cart Items (from previous cart or arguments)
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  // Pricing
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble estimatedTax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxString appliedPromoCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCheckoutData();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  void _loadCheckoutData() {
    // Load from arguments if available
    if (Get.arguments != null) {
      if (Get.arguments['items'] != null) {
        cartItems.value = List<Map<String, dynamic>>.from(Get.arguments['items']);
      }
      if (Get.arguments['address'] != null) {
        deliveryAddress.value = Map<String, dynamic>.from(Get.arguments['address']);
      }
    }

    // Fallback to default address if none provided
    if (deliveryAddress.isEmpty) {
      _loadDefaultAddress();
    }

    // Fallback to mock items if none provided
    if (cartItems.isEmpty) {
      _loadMockCartItems();
    }

    calculatePricing();
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final response = await _apiProvider.get(ApiConstants.buyerAddresses);
      final addresses = response.data['data'] ?? response.data;
      if (addresses is List && addresses.isNotEmpty) {
        // Find default address or use first
        final defaultAddr = addresses.firstWhere(
          (a) => a['is_default'] == true,
          orElse: () => addresses.first,
        );
        deliveryAddress.value = {
          'name': defaultAddr['full_name'] ?? defaultAddr['name'] ?? '',
          'address': defaultAddr['address_line_1'] ?? defaultAddr['address'] ?? '',
          'city': defaultAddr['city'] ?? '',
          'state': defaultAddr['state'] ?? '',
          'zipCode': defaultAddr['zip_code'] ?? defaultAddr['postal_code'] ?? '',
        };
        return;
      }
    } catch (_) {}

    // Fallback mock address
    deliveryAddress.value = {
      'name': 'Alex Johnson',
      'address': '844 Ritter Lake Suite 052',
      'city': 'Redwood City',
      'state': 'CA',
      'zipCode': '94063',
    };
  }

  void _loadMockCartItems() {
    cartItems.value = [
      {
        'id': '1',
        'product_id': 1,
        'name': 'PS 5 Wireless Headphones',
        'price': 380.00,
        'quantity': 1,
        'image': 'assets/images/headphones.png',
      },
      {
        'id': '2',
        'product_id': 2,
        'name': 'Huger-Cloth Mouse',
        'price': 25.00,
        'quantity': 1,
        'image': 'assets/images/mouse.png',
      },
    ];
  }

  void calculatePricing() {
    double sub = 0.0;
    for (var item in cartItems) {
      sub += (item['price'] as double) * (item['quantity'] as int);
    }
    subtotal.value = sub;

    if (selectedDeliverySpeed.value == 'free') {
      shipping.value = 0.0;
    } else {
      shipping.value = 9.99;
    }

    estimatedTax.value = subtotal.value * 0.08;
    total.value = subtotal.value + shipping.value + estimatedTax.value - discount.value;
  }

  void selectDeliverySpeed(String speed) {
    selectedDeliverySpeed.value = speed;
    calculatePricing();
  }

  void changeAddress() {
    Get.toNamed(Routes.BUYER_SAVED_ADDRESS);
  }

  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      Helpers.showError('promo_code_required'.tr);
      return;
    }

    isApplyingPromo.value = true;

    try {
      // Try API validation
      final response = await _apiProvider.post(
        ApiConstants.applyCoupon,
        data: {
          'code': code,
          'subtotal': subtotal.value,
        },
      );

      final discountAmount = response.data['discount'] ?? 0.0;
      discount.value = (discountAmount is int)
          ? discountAmount.toDouble()
          : discountAmount as double;
      appliedPromoCode.value = code;
      calculatePricing();
      Helpers.showSuccess('promo_code_applied'.tr);
      promoCodeController.clear();
    } catch (_) {
      // Fallback: local promo code validation
      if (code.toLowerCase() == 'save10') {
        discount.value = subtotal.value * 0.1;
        appliedPromoCode.value = code;
        calculatePricing();
        Helpers.showSuccess('promo_code_applied'.tr);
        promoCodeController.clear();
      } else {
        Helpers.showError('invalid_promo_code'.tr);
      }
    } finally {
      isApplyingPromo.value = false;
    }
  }

  Future<void> placeOrder() async {
    if (isPlacingOrder.value) return;
    isPlacingOrder.value = true;

    try {
      final orderData = {
        'items': cartItems.map((item) => {
          'product_id': item['product_id'] ?? int.tryParse(item['id'].toString()) ?? 0,
          'quantity': item['quantity'],
        }).toList(),
        'shipping_address': {
          'name': deliveryAddress['name'],
          'address': deliveryAddress['address'],
          'city': deliveryAddress['city'],
          'state': deliveryAddress['state'],
          'zip_code': deliveryAddress['zipCode'],
        },
        'delivery_speed': selectedDeliverySpeed.value,
        'payment_method': 'card',
        if (appliedPromoCode.value.isNotEmpty)
          'promo_code': appliedPromoCode.value,
      };

      final response = await _apiProvider.post(
        ApiConstants.buyerPlaceOrder,
        data: orderData,
      );

      final order = response.data['order'];

      Get.offNamed(
        '/buyer-order-success',
        arguments: {
          'orderId': order['order_number'],
          'totalAmount': (order['total'] is int)
              ? (order['total'] as int).toDouble()
              : order['total'] as double,
          'deliveryAddress': Map<String, dynamic>.from(deliveryAddress),
          'estimatedDelivery': order['estimated_delivery'] ?? '',
        },
      );
    } catch (e) {
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
