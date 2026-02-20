import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../core/constants/api_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

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
  final RxBool isAddingToCart = false.obs;
  final RxBool isBuyingNow = false.obs;

  // Reviews
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxMap<String, dynamic> reviewSummary = <String, dynamic>{}.obs;
  final RxBool isLoadingReviews = false.obs;
  final RxBool isSubmittingReview = false.obs;

  // Video
  VideoPlayerController? _videoPlayerController;
  ChewieController? chewieController;
  final RxBool isVideoInitialized = false.obs;

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

  @override
  void onClose() {
    _videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
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

        // Fetch reviews
        fetchReviews(id);
      }
    } catch (_) {
      // Product not found or network error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReviews(String productId) async {
    isLoadingReviews.value = true;
    try {
      final response = await _apiProvider.get(
        '${ApiConstants.products}/$productId/reviews',
      );
      final data = response.data;

      if (data['reviews'] != null) {
        reviews.value = List<Map<String, dynamic>>.from(data['reviews']);
      }
      if (data['summary'] != null) {
        reviewSummary.value = Map<String, dynamic>.from(data['summary']);
      }
    } catch (_) {
      // Use product-level rating as fallback
      reviewSummary.value = {
        'average_rating':
            double.tryParse(product['rating']?.toString() ?? '0') ?? 0,
        'total_reviews': product['total_reviews'] ?? 0,
        'rating_breakdown': {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
      };
    } finally {
      isLoadingReviews.value = false;
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

  // --- Video Playback ---

  void playVideo() {
    if (videoPath.value.isEmpty) return;

    final videoUrl = '$storageBaseUrl${videoPath.value}';

    _videoPlayerController?.dispose();
    chewieController?.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    );

    _videoPlayerController!.initialize().then((_) {
      chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text(
                  'video_load_error'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      );
      isVideoInitialized.value = true;

      Get.dialog(
        _buildVideoDialog(),
        barrierColor: Colors.black87,
      );
    }).catchError((_) {
      Helpers.showError('video_load_error'.tr);
    });
  }

  Widget _buildVideoDialog() {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _disposeVideo();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _disposeVideo();
              Get.back();
            },
          ),
          title: Text(
            product['name'] ?? 'video'.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: Center(
          child: chewieController != null
              ? Chewie(controller: chewieController!)
              : const CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  void _disposeVideo() {
    chewieController?.pause();
    chewieController?.dispose();
    _videoPlayerController?.dispose();
    chewieController = null;
    _videoPlayerController = null;
    isVideoInitialized.value = false;
  }

  // --- Reviews ---

  void viewAllReviews() {
    final productId = product['id']?.toString();
    if (productId == null) return;

    Get.bottomSheet(
      _buildAllReviewsSheet(),
      isScrollControlled: true,
      backgroundColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildAllReviewsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'customer_reviews'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      showWriteReviewDialog();
                    },
                    icon: const Icon(Icons.rate_review, size: 18),
                    label: Text('write_review'.tr),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.reviews_outlined,
                            size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          'no_reviews_yet'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            showWriteReviewDialog();
                          },
                          child: Text('be_first_to_review'.tr),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _buildReviewItem(context, review);
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewItem(BuildContext context, Map<String, dynamic> review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              backgroundImage: review['buyer_photo'] != null
                  ? NetworkImage(review['buyer_photo'])
                  : null,
              child: review['buyer_photo'] == null
                  ? Text(
                      (review['buyer_name'] ?? 'A')[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        review['buyer_name'] ?? 'Anonymous',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (review['is_verified_purchase'] == true) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.verified,
                            size: 14, color: Colors.green[600]),
                      ],
                    ],
                  ),
                  Text(
                    review['time_ago'] ?? review['created_at'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            return Icon(
              i < (review['rating'] ?? 0)
                  ? Icons.star
                  : Icons.star_border,
              color: Colors.amber,
              size: 16,
            );
          }),
        ),
        if (review['title'] != null && review['title'].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              review['title'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        if (review['comment'] != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              review['comment'],
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  void showWriteReviewDialog() {
    final commentController = TextEditingController();
    final titleController = TextEditingController();
    final RxDouble selectedRating = 5.0.obs;

    Get.dialog(
      AlertDialog(
        title: Text('write_review'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('rate_product'.tr),
              const SizedBox(height: 8),
              Center(
                child: Obx(() => RatingBar.builder(
                      initialRating: selectedRating.value,
                      minRating: 1,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 36,
                      itemBuilder: (_, __) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        selectedRating.value = rating;
                      },
                    )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'review_title'.tr,
                  hintText: 'review_title_hint'.tr,
                  border: const OutlineInputBorder(),
                ),
                maxLength: 200,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'your_review'.tr,
                  hintText: 'review_comment_hint'.tr,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 4,
                maxLength: 2000,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          Obx(() => ElevatedButton(
                onPressed: isSubmittingReview.value
                    ? null
                    : () => submitReview(
                          selectedRating.value.toInt(),
                          titleController.text.trim(),
                          commentController.text.trim(),
                        ),
                child: isSubmittingReview.value
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('submit'.tr),
              )),
        ],
      ),
    );
  }

  Future<void> submitReview(int rating, String title, String comment) async {
    if (comment.isEmpty) {
      Helpers.showError('review_comment_required'.tr);
      return;
    }

    isSubmittingReview.value = true;
    final productId = product['id']?.toString();

    try {
      final response = await _apiProvider.post(
        '${ApiConstants.products}/$productId/reviews',
        data: {
          'rating': rating,
          'title': title.isNotEmpty ? title : null,
          'comment': comment,
        },
      );

      final newReview = response.data['review'];
      if (newReview != null) {
        reviews.insert(0, Map<String, dynamic>.from(newReview));
      }

      Get.back(); // Close dialog
      Helpers.showSuccess('review_submitted'.tr);

      // Refresh reviews
      if (productId != null) {
        fetchReviews(productId);
      }
    } catch (e) {
      Helpers.showErrorSheet(Helpers.parseErrorMessage(e));
    } finally {
      isSubmittingReview.value = false;
    }
  }

  // --- Cart & Buy Now ---

  Future<void> addToCart() async {
    if (isAddingToCart.value) return;
    isAddingToCart.value = true;

    try {
      await _apiProvider.post(
        ApiConstants.addToCart,
        data: {
          'product_id': product['id'],
          'quantity': quantity.value,
        },
      );
      Helpers.showSuccess('item_added'.tr);
    } catch (e) {
      Helpers.showError('cart_error'.tr);
    } finally {
      isAddingToCart.value = false;
    }
  }

  Future<void> buyNow() async {
    if (isBuyingNow.value) return;
    isBuyingNow.value = true;

    try {
      await _apiProvider.post(
        ApiConstants.addToCart,
        data: {
          'product_id': product['id'],
          'quantity': quantity.value,
        },
      );
    } catch (_) {}

    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
    final salePrice =
        double.tryParse(product['sale_price']?.toString() ?? '0') ?? 0;
    final effectivePrice =
        (salePrice > 0 && salePrice < price) ? salePrice : price;

    isBuyingNow.value = false;

    Get.toNamed(
      Routes.BUYER_CHECKOUT,
      arguments: {
        'items': [
          {
            'id': product['id'].toString(),
            'product_id': product['id'],
            'name': product['name'] ?? '',
            'price': effectivePrice,
            'quantity': quantity.value,
            'image': imageUrls.isNotEmpty ? imageUrls.first : 'default',
          },
        ],
      },
    );
  }
}
