import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class VendorEditProductController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final ImagePicker _picker = ImagePicker();

  // Product ID from arguments
  String? productId;

  // Tab control
  final RxString selectedTab = 'general'.obs;
  final RxBool isLoading = false.obs;

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
  final TextEditingController titleController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Media — existing server URLs + newly picked local files
  final RxList<String> serverImages = <String>[].obs;
  final RxList<File> newImages = <File>[].obs;
  final RxString serverVideoPath = ''.obs;
  final Rx<File?> newVideoFile = Rx<File?>(null);
  static const int maxTotalMedia = 10;

  // Categories fetched from API
  final RxList<String> categories = <String>[].obs;

  // Pricing Information
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController skuController = TextEditingController();

  // Variants
  final RxList<String> selectedSizes = <String>['S', 'M', 'L', 'XL'].obs;
  final RxList<String> selectedColors = <String>['Navy Blue', 'Slate Gray'].obs;
  final List<String> availableSizes = ['S', 'M', 'L', 'XL'];
  final List<String> availableColors = [
    'Navy Blue',
    'Slate Gray',
    'Black',
    'White'
  ];

  // Shipping Information
  final TextEditingController weightController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final RxString selectedShippingClass = 'Standard Shipping'.obs;
  final RxBool enableReturnPolicy = true.obs;

  final List<String> shippingClasses = [
    'Standard Shipping',
    'Express Shipping',
    'Free Shipping',
    'No Shipping',
  ];

  int get totalMediaCount => serverImages.length + newImages.length;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
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

  Future<void> _fetchCategories() async {
    try {
      final response = await _apiProvider.get(ApiConstants.categories);
      final data = response.data['data'] ?? response.data;
      if (data is List) {
        categories.value =
            data.map<String>((c) => c['name']?.toString() ?? '').toList();
      }
    } catch (_) {
      categories.value = [
        'Electronics',
        'Fashion',
        'Home',
        'Beauty',
        'Sports',
      ];
    }
  }

  void loadProductData() {
    final product = Get.arguments as Map<String, dynamic>?;
    if (product == null) return;

    productId = product['id']?.toString();
    titleController.text = product['name'] ?? '';
    priceController.text = (product['price'] ?? '').toString();
    stockController.text = (product['stock'] ?? 0).toString();
    descriptionController.text = product['description'] ?? '';

    basePriceController.text = (product['price'] ?? '').toString();
    salePriceController.text = (product['sale_price'] ?? '').toString();
    skuController.text = product['sku'] ?? '';

    final weight = product['weight'];
    weightController.text = weight != null ? weight.toString() : '';

    final dims = product['dimensions'];
    if (dims is Map) {
      lengthController.text = dims['length']?.toString() ?? '';
      widthController.text = dims['width']?.toString() ?? '';
      heightController.text = dims['height']?.toString() ?? '';
    }

    // Load category
    selectedCategory.value = product['category']?.toString() ?? '';

    // Load server images
    final images = product['images'] as List?;
    if (images != null && images.isNotEmpty) {
      serverImages.value = images
          .map<String>((img) => img['image_path']?.toString() ?? '')
          .where((path) => path.isNotEmpty)
          .toList();
    }

    // Load video
    serverVideoPath.value = product['video_path']?.toString() ?? '';
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  void selectCategory() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => Column(
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
            ...categories.map((cat) => ListTile(
                  title: Text(cat),
                  trailing: cat == selectedCategory.value
                      ? const Icon(Icons.check, color: Colors.orange)
                      : null,
                  onTap: () {
                    selectedCategory.value = cat;
                    Get.back();
                  },
                )),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }

  void setShippingClass(String? shippingClass) {
    if (shippingClass != null) {
      selectedShippingClass.value = shippingClass;
    }
  }

  // --- Media picking ---

  Future<void> pickImages() async {
    final remaining = maxTotalMedia - totalMediaCount;
    if (remaining <= 0) {
      Helpers.showError('max_media_reached'.tr);
      return;
    }
    final List<XFile> picked = await _picker.pickMultiImage(
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked.isNotEmpty) {
      final toAdd = picked.take(remaining).map((x) => File(x.path)).toList();
      newImages.addAll(toAdd);
    }
  }

  Future<void> pickVideo() async {
    final XFile? picked = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    if (picked != null) {
      newVideoFile.value = File(picked.path);
    }
  }

  void removeServerImage(int index) {
    if (index >= 0 && index < serverImages.length) {
      serverImages.removeAt(index);
    }
  }

  void removeNewImage(int index) {
    if (index >= 0 && index < newImages.length) {
      newImages.removeAt(index);
    }
  }

  void removeVideo() {
    if (newVideoFile.value != null) {
      newVideoFile.value = null;
    } else {
      serverVideoPath.value = '';
    }
  }

  // --- Variants ---

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

  // --- Save / Update / Delete ---

  Future<void> saveChanges() async {
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
    if (productId == null) return;

    isLoading.value = true;
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorProducts}/$productId',
        data: {
          'name': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'category': selectedCategory.value,
          'price': double.tryParse(priceController.text) ?? 0,
          'sale_price': double.tryParse(salePriceController.text),
          'sku': skuController.text.trim(),
          'quantity': int.tryParse(stockController.text) ?? 0,
          'weight': double.tryParse(weightController.text),
          'dimensions': {
            'length': lengthController.text,
            'width': widthController.text,
            'height': heightController.text,
          },
        },
      );
      Helpers.showSuccess('product_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInventory() async {
    if (basePriceController.text.isEmpty) {
      Helpers.showError('base_price_required'.tr);
      return;
    }
    if (skuController.text.isEmpty) {
      Helpers.showError('sku_required'.tr);
      return;
    }
    if (productId == null) return;

    isLoading.value = true;
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorProducts}/$productId',
        data: {
          'price': double.tryParse(basePriceController.text) ?? 0,
          'sale_price': double.tryParse(salePriceController.text),
          'sku': skuController.text.trim(),
        },
      );
      Helpers.showSuccess('inventory_updated_successfully'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeAndUpdateProduct() async {
    if (weightController.text.isEmpty) {
      Helpers.showError('product_weight_required'.tr);
      return;
    }
    if (productId == null) return;

    isLoading.value = true;
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorProducts}/$productId',
        data: {
          'weight': double.tryParse(weightController.text),
          'dimensions': {
            'length': lengthController.text,
            'width': widthController.text,
            'height': heightController.text,
          },
          'shipping_class': selectedShippingClass.value,
          'return_policy_enabled': enableReturnPolicy.value,
        },
      );
      Helpers.showSuccess('product_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
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
              color: Get.isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
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
                foregroundColor:
                    Get.isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
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

  Future<void> deleteProduct() async {
    Get.back();
    if (productId == null) return;

    isLoading.value = true;
    try {
      await _apiProvider.delete('${ApiConstants.vendorProducts}/$productId');
      Helpers.showSuccess('product_deleted_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }
}
