import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';

class ProductDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxBool isLoading = true.obs;
  final RxMap<String, dynamic> product = <String, dynamic>{}.obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxString videoPath = ''.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt quantity = 1.obs;
  final RxBool isDescriptionExpanded = false.obs;

  String get storageBaseUrl =>
      '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final id = args?['id']?.toString();
    if (id != null) {
      fetchProduct(id);
    }
  }

  Future<void> fetchProduct(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get('${ApiConstants.products}/$id');
      final data = response.data['data'] ?? response.data;
      if (data is Map<String, dynamic>) {
        product.value = data;

        // Extract image URLs
        final images = data['images'] as List? ?? [];
        imageUrls.value = images
            .map<String>((img) => img['image_path']?.toString() ?? '')
            .where((p) => p.isNotEmpty)
            .toList();

        // Extract video
        videoPath.value = data['video_path']?.toString() ?? '';
      }
    } catch (_) {
      // Product not found or network error
    } finally {
      isLoading.value = false;
    }
  }

  void onImageChanged(int index) {
    currentImageIndex.value = index;
  }

  void selectColor(String color) {
    selectedColor.value = color;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void incrementQuantity() {
    final stock = product['quantity'] ?? 999;
    if (quantity.value < stock) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleDescription() {
    isDescriptionExpanded.value = !isDescriptionExpanded.value;
  }

  void shareProduct() {
    final name = product['name'] ?? 'Product';
    Get.snackbar(
      'share'.tr,
      'Sharing "$name"...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void viewAllReviews() {
    Get.snackbar(
      'customer_reviews'.tr,
      'coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void addToCart() {
    Get.snackbar(
      'cart'.tr,
      'item_added'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void buyNow() {
    Get.snackbar(
      'checkout'.tr,
      'proceeding_to_checkout'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
