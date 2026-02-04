import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorEditProductController extends GetxController {
  // Tab control
  final RxString selectedTab = 'general'.obs;

  // Get current tab index
  int get currentTabIndex {
    switch (selectedTab.value) {
      case 'general':
        return 0;
      case 'pricing':
        return 1;
      case 'shipping':
        return 2;
      default:
        return 0;
    }
  }

  // General Information
  final TextEditingController titleController = TextEditingController(
    text: 'Wireless Pro Studio Headphones',
  );
  final RxString selectedCategory = 'Audio & Headphones'.obs;
  final TextEditingController priceController = TextEditingController(
    text: '259.00',
  );
  final TextEditingController stockController = TextEditingController(
    text: '24',
  );
  final TextEditingController descriptionController = TextEditingController(
    text: 'High-fidelity audio with active noise cancellation and 40-hour battery life. Perfect for travel and focus.',
  );

  // Product images
  final RxList<String> productImages = <String>['🎧', '🎨', '🏷️'].obs;

  // Categories list
  final List<String> categories = [
    'Audio & Headphones',
    'Electronics',
    'Fashion',
    'Home & Living',
    'Sports & Outdoors',
  ];

  // Pricing Information
  final TextEditingController basePriceController = TextEditingController(
    text: '120.00',
  );
  final TextEditingController salePriceController = TextEditingController(
    text: '99.99',
  );
  final TextEditingController skuController = TextEditingController(
    text: 'SB-TTH-0024-NV',
  );

  // Variants
  final RxList<String> selectedSizes = <String>['S', 'M', 'L', 'XL'].obs;
  final RxList<String> selectedColors = <String>['Navy Blue', 'Slate Gray'].obs;
  final List<String> availableSizes = ['S', 'M', 'L', 'XL'];
  final List<String> availableColors = ['Navy Blue', 'Slate Gray', 'Black', 'White'];

  // Shipping Information
  final TextEditingController weightController = TextEditingController(
    text: '0.5',
  );
  final TextEditingController lengthController = TextEditingController(
    text: '0',
  );
  final TextEditingController widthController = TextEditingController(
    text: '0',
  );
  final TextEditingController heightController = TextEditingController(
    text: '0',
  );
  final RxString selectedShippingClass = 'Standard Shipping'.obs;
  final RxBool enableReturnPolicy = true.obs;

  // Shipping classes
  final List<String> shippingClasses = [
    'Standard Shipping',
    'Express Shipping',
    'Free Shipping',
    'No Shipping',
  ];

  @override
  void onInit() {
    super.onInit();
    // Load product data if editing existing product
    loadProductData();
  }

  @override
  void onClose() {
    titleController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    basePriceController.dispose();
    salePriceController.dispose();
    skuController.dispose();
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.onClose();
  }

  void loadProductData() {
    // Load product data from storage or API
    // This would typically fetch data based on product ID
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void setCategory(String? category) {
    if (category != null) {
      selectedCategory.value = category;
    }
  }

  void setShippingClass(String? shippingClass) {
    if (shippingClass != null) {
      selectedShippingClass.value = shippingClass;
    }
  }

  void addProductImage() {
    // Simulate image upload
    Helpers.showInfo('image_upload_feature_coming_soon'.tr);
  }

  void removeProductImage(int index) {
    if (productImages.length > 1) {
      productImages.removeAt(index);
      Helpers.showSuccess('image_removed'.tr);
    } else {
      Helpers.showError('at_least_one_image_required'.tr);
    }
  }

  void toggleSize(String size) {
    if (selectedSizes.contains(size)) {
      selectedSizes.remove(size);
    } else {
      selectedSizes.add(size);
    }
  }

  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
    }
  }

  void addVariant() {
    Helpers.showInfo('add_variant_feature_coming_soon'.tr);
  }

  void editSizeVariants() {
    Helpers.showInfo('edit_variants_feature_coming_soon'.tr);
  }

  void editColorVariants() {
    Helpers.showInfo('edit_variants_feature_coming_soon'.tr);
  }

  void toggleReturnPolicy(bool value) {
    enableReturnPolicy.value = value;
  }

  void saveChanges() {
    // Validate general information
    if (titleController.text.isEmpty) {
      Helpers.showError('product_title_required'.tr);
      return;
    }

    if (priceController.text.isEmpty) {
      Helpers.showError('product_price_required'.tr);
      return;
    }

    if (stockController.text.isEmpty) {
      Helpers.showError('product_stock_required'.tr);
      return;
    }

    // Save product changes
    Helpers.showSuccess('product_updated_successfully'.tr);
    Get.back();
  }

  void updateInventory() {
    // Validate pricing information
    if (basePriceController.text.isEmpty) {
      Helpers.showError('base_price_required'.tr);
      return;
    }

    if (skuController.text.isEmpty) {
      Helpers.showError('sku_required'.tr);
      return;
    }

    // Update inventory
    Helpers.showSuccess('inventory_updated_successfully'.tr);
  }

  void removeAndUpdateProduct() {
    // Validate shipping information
    if (weightController.text.isEmpty) {
      Helpers.showError('product_weight_required'.tr);
      return;
    }

    // Update product with shipping details
    Helpers.showSuccess('product_updated_successfully'.tr);
    Get.back();
  }

  void showDeleteProductDialog() {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.red.shade600,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'delete_product'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'delete_product_confirmation_message'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: deleteProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'delete_product'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: Text(
                'cancel'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteProduct() {
    Get.back(); // Close dialog
    Helpers.showSuccess('product_deleted_successfully'.tr);
    Get.back(); // Go back to products list
  }
}
