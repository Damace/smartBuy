import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'product_details_controller.dart';
import '../../core/themes/app_theme.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('product_details'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.product.isEmpty) {
          return Center(child: Text('product_not_found'.tr));
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageCarousel(),
                    _buildProductInfo(),
                    _buildColorSelection(),
                    _buildSizeSelection(),
                    _buildDescription(),
                    _buildReviewsSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  Widget _buildImageCarousel() {
    return Obx(() {
      final images = controller.imageUrls;
      final hasVideo = controller.videoPath.value.isNotEmpty;
      final totalSlides = images.isEmpty ? 1 : images.length;

      return Column(
        children: [
          Stack(
            children: [
              carousel.CarouselSlider.builder(
                itemCount: totalSlides,
                itemBuilder: (context, index, _) {
                  if (index < images.length) {
                    return Image.network(
                      '${controller.storageBaseUrl}${images[index]}',
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 320,
                        color: Get.isDarkMode
                            ? AppTheme.darkCardColor
                            : Colors.grey[100],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 60, color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: 320,
                    color: Get.isDarkMode
                        ? AppTheme.darkCardColor
                        : Colors.grey[100],
                    child: const Center(
                      child: Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  );
                },
                options: carousel.CarouselOptions(
                  height: 320,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: images.length > 1,
                  onPageChanged: (index, _) =>
                      controller.onImageChanged(index),
                ),
              ),
              // Video play button
              if (hasVideo)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => _showVideoInfo(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_circle_fill,
                              color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Play Video',
                            style: TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Badge
              if (controller.product['is_featured'] == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'smartbuy_exclusive'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (images.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: images.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildProductInfo() {
    final product = controller.product;
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;
    final salePrice =
        double.tryParse(product['sale_price']?.toString() ?? '0') ?? 0;
    final hasSale = salePrice > 0 && salePrice < price;
    final rating =
        double.tryParse(product['rating']?.toString() ?? '0') ?? 0;
    final reviewCount = product['total_reviews'] ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 2),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${hasSale ? salePrice.toStringAsFixed(2) : price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              if (hasSale) ...[
                const SizedBox(width: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${((1 - salePrice / price) * 100).round()}% OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Vendor + reviews
          Row(
            children: [
              if (product['vendor'] != null)
                Text(
                  product['vendor']['business_name'] ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                ),
              if (reviewCount > 0) ...[
                const Text(' · '),
                Text(
                  '$reviewCount ${'reviews'.tr}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelection() {
    final colors = ['Midnight Black', 'Silver', 'Navy Blue'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'color'.tr}:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: colors.map((color) {
                  final isSelected =
                      controller.selectedColor.value == color;
                  return GestureDetector(
                    onTap: () => controller.selectColor(color),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : Get.isDarkMode
                                ? AppTheme.darkCardColor
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Get.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        color,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    final sizes = ['S', 'M', 'L', 'XL'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'select_size'.tr}:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: sizes.map((size) {
                  final isSelected =
                      controller.selectedSize.value == size;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => controller.selectSize(size),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Get.isDarkMode
                                  ? AppTheme.darkCardColor
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Get.isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final description = controller.product['description'] ?? '';
    if (description.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'description'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'read_more'.tr,
              style: const TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final rating =
        double.tryParse(controller.product['rating']?.toString() ?? '0') ?? 0;
    final reviewCount = controller.product['total_reviews'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'customer_reviews'.tr} ($reviewCount)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Rating summary
          Row(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$reviewCount ${'reviews'.tr}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Add to Cart
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.addToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: Text('add_to_cart'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Buy Now
            Expanded(
              child: ElevatedButton(
                onPressed: controller.buyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'buy_now'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoInfo() {
    Get.snackbar(
      'video'.tr,
      'video_playback_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
