import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/providers/api_provider.dart';
import '../buyer_saved_address/buyer_saved_address_controller.dart';
import '../cart/cart_controller.dart';

class BuyerCheckoutController extends GetxController {
  final TextEditingController promoCodeController = TextEditingController();
  final ApiProvider _apiProvider = ApiProvider();

  final RxInt currentStep = 2.obs;
  final RxBool isPlacingOrder = false.obs;
  final RxBool isApplyingPromo = false.obs;

  // Selected delivery address
  final Rx<Map<String, dynamic>?> selectedAddress =
      Rx<Map<String, dynamic>?>(null);

  // Pricing
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble estimatedTax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxString appliedPromoCode = ''.obs;

  late final CartController _cartController;
  late final BuyerSavedAddressController _addressController;

  @override
  void onInit() {
    super.onInit();

    // Reuse or create CartController
    try {
      _cartController = Get.find<CartController>();
    } catch (_) {
      _cartController = Get.put(CartController());
    }

    // Reuse or create BuyerSavedAddressController
    try {
      _addressController = Get.find<BuyerSavedAddressController>();
    } catch (_) {
      _addressController = Get.put(BuyerSavedAddressController());
    }

    // Auto-select default address once addresses load
    ever(_addressController.addresses, (List<Map<String, dynamic>> list) {
      if (selectedAddress.value == null && list.isNotEmpty) {
        final def =
            list.firstWhereOrNull((a) => a['isDefault'] == true) ?? list.first;
        selectedAddress.value = def;
      }
    });

    // If addresses already loaded, set immediately
    if (_addressController.addresses.isNotEmpty &&
        selectedAddress.value == null) {
      final def = _addressController.addresses
              .firstWhereOrNull((a) => a['isDefault'] == true) ??
          _addressController.addresses.first;
      selectedAddress.value = def;
    }

    // Recalculate pricing whenever cart changes
    ever(_cartController.cartItems, (_) => calculatePricing());
    calculatePricing();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  List<CartItemModel> get cartItems => _cartController.cartItems;

  List<Map<String, dynamic>> get addresses => _addressController.addresses;

  bool get isLoadingAddresses => _addressController.isLoading.value;

  void calculatePricing() {
    subtotal.value = _cartController.subtotal;
    shipping.value = 0.0;
    estimatedTax.value = subtotal.value * 0.08;
    total.value =
        subtotal.value + shipping.value + estimatedTax.value - discount.value;
  }

  void selectAddress(Map<String, dynamic> address) {
    selectedAddress.value = address;
  }

  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) {
      Helpers.showError('promo_code_required'.tr);
      return;
    }

    isApplyingPromo.value = true;
    try {
      final response = await _apiProvider.post(
        ApiConstants.applyCoupon,
        data: {'code': code, 'subtotal': subtotal.value},
      );
      final discountAmount = response.data['discount'] ?? 0.0;
      discount.value = (discountAmount is int)
          ? discountAmount.toDouble()
          : (discountAmount as num).toDouble();
      appliedPromoCode.value = code;
      calculatePricing();
      Helpers.showSuccess('promo_code_applied'.tr);
      promoCodeController.clear();
    } catch (_) {
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
    if (selectedAddress.value == null) {
      Helpers.showError('please_select_address'.tr);
      return;
    }

    isPlacingOrder.value = true;
    try {
      final addr = selectedAddress.value!;
      final orderData = {
        'items': cartItems
            .map((item) => {
                  'product_id': item.productId,
                  'quantity': item.quantity,
                })
            .toList(),
        'shipping_address': {
          'name': addr['name'],
          'address': addr['address_line_1'],
          'city': addr['city'],
          'state': addr['state'],
          'zip_code': addr['postal_code'],
        },
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
              : (order['total'] as num).toDouble(),
          'deliveryAddress': addr,
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
