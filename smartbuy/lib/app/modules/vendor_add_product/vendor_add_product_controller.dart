import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorAddProductController extends GetxController {
  final RxInt currentStep = 0.obs;

  // Step 1: Basic Info & Media
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final RxList<String> uploadedImages = <String>[].obs;
  final RxString uploadedVideo = ''.obs;

  // Step 2: Pricing & Inventory
  final TextEditingController regularPriceController = TextEditingController();
  final TextEditingController discountedPriceController =
      TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final RxInt quantityInStock = 25.obs;
  final RxBool lowStockAlert = true.obs;
  final RxList<Map<String, dynamic>> variants = <Map<String, dynamic>>[].obs;

  // Step 3: Shipping & Policy
  final RxString shippingPartner = 'SmartBuy Express'.obs;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final RxBool returnPolicyEnabled = true.obs;
  final RxString returnWindow = '7_days'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultValues();
  }

  void _initializeDefaultValues() {
    regularPriceController.text = '45.00';
    discountedPriceController.text = '0.00';
    skuController.text = 'SB-2024-SUMMER-01';
    weightController.text = '0.00';
    lengthController.text = '0';
    widthController.text = '0';
    heightController.text = '0';

    // Add default variants
    variants.add({
      'name': 'SIZE',
      'options': ['Small', 'Medium', 'Large'],
    });
    variants.add({
      'name': 'COLOR',
      'options': ['Blue', 'Black'],
    });
  }

  void nextStep() {
    if (currentStep.value == 0 && !_validateStep1()) return;
    if (currentStep.value == 1 && !_validateStep2()) return;

    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      _publishProduct();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  bool _validateStep1() {
    if (productNameController.text.trim().isEmpty) {
      Helpers.showError('please_enter_product_name'.tr);
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Helpers.showError('please_select_category'.tr);
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (regularPriceController.text.trim().isEmpty) {
      Helpers.showError('please_enter_price'.tr);
      return false;
    }
    if (skuController.text.trim().isEmpty) {
      Helpers.showError('please_enter_sku'.tr);
      return false;
    }
    return true;
  }

  void selectCategory() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'select_category'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...['Electronics', 'Fashion', 'Home', 'Beauty', 'Sports']
                .map((category) => ListTile(
                      title: Text(category),
                      onTap: () {
                        selectedCategory.value = category;
                        Get.back();
                      },
                    )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void uploadCoverImage() {
    Helpers.showSuccess('cover_image_uploaded'.tr);
  }

  void uploadVideo() {
    Helpers.showSuccess('video_uploaded'.tr);
  }

  void incrementQuantity() {
    quantityInStock.value++;
  }

  void decrementQuantity() {
    if (quantityInStock.value > 0) {
      quantityInStock.value--;
    }
  }

  void addVariant() {
    Get.snackbar(
      'add_variant'.tr,
      'feature_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeVariantOption(String variantName, String option) {
    final variant = variants.firstWhere((v) => v['name'] == variantName);
    final options = List<String>.from(variant['options']);
    options.remove(option);
    variant['options'] = options;
    variants.refresh();
  }

  void selectShippingPartner() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'select_shipping_partner'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...[
              'SmartBuy Express',
              'DHL',
              'FedEx',
              'UPS',
              'Custom Shipping'
            ].map((partner) => ListTile(
                  title: Text(partner),
                  trailing: partner == 'SmartBuy Express'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'recommended'.tr,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    shippingPartner.value = partner;
                    Get.back();
                  },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void selectReturnWindow() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'select_return_window'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...['7_days', '14_days', '30_days', '60_days', '90_days']
                .map((window) => ListTile(
                      title: Text('${window.split('_')[0]} ${'days'.tr}'),
                      onTap: () {
                        returnWindow.value = window;
                        Get.back();
                      },
                    )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _publishProduct() {
    Get.defaultDialog(
      title: 'publish_product'.tr,
      middleText: 'publish_product_confirmation'.tr,
      textConfirm: 'publish'.tr,
      textCancel: 'save_draft'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.back();
        Helpers.showSuccess('product_published'.tr);
      },
      onCancel: () {
        Get.back();
        Helpers.showSuccess('product_saved_draft'.tr);
      },
    );
  }

  @override
  void onClose() {
    productNameController.dispose();
    descriptionController.dispose();
    regularPriceController.dispose();
    discountedPriceController.dispose();
    skuController.dispose();
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.onClose();
  }
}
