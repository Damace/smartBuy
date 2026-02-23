import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_controller.dart';
import '../../core/constants/api_constants.dart';
import '../../core/themes/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // 👈 important
      body: Stack(
        children: [
          /// 🔥 Carousel Background (Top Layer Behind)
          _buildCarouselBanner(context),

          /// 🔥 Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  /// Search Bar on top of carousel
                  _buildSearchBar(context),

                  const SizedBox(height: 20),

                  /// Other page content here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'SmartBuy',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          // Obx(
          //   () => badges.Badge(
          //     badgeContent: Text(
          //       controller.notificationCount.value.toString(),
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 10,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     showBadge: controller.notificationCount.value > 0,
          //     position: badges.BadgePosition.topEnd(top: -8, end: -8),
          //     child: IconButton(
          //       icon: const Icon(Icons.notifications_outlined),
          //       onPressed: controller.onNotificationTapped,
          //     ),
          //   ),
          // ),
          Obx(
            () => badges.Badge(
              badgeContent: Text(
                controller.cartCount.value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              showBadge: controller.cartCount.value > 0,
              position: badges.BadgePosition.topEnd(top: -8, end: -8),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: controller.onCartTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: controller.onSearchTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              'search_placeholder'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselBanner(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(
      () => Column(
        children: [
          carousel.CarouselSlider.builder(
            itemCount: controller.banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = controller.banners[index];
              return GestureDetector(
                onTap: controller.onBannerTapped,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _buildBannerBackground(banner['image']),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.55),
                                  Colors.black.withValues(alpha: 0.15),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(
                              _getBannerIcon(banner['icon']),
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner['subtitle'],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'shop_now'.tr,
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            options: carousel.CarouselOptions(
              height: screenHeight * 0.22,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                controller.currentBannerIndex.value = index;
              },
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => AnimatedSmoothIndicator(
              activeIndex: controller.currentBannerIndex.value,
              count: controller.banners.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: AppTheme.primaryColor,
                dotColor: Get.isDarkMode
                    ? AppTheme.darkTextSecondary.withOpacity(0.3)
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBannerIcon(String? iconName) {
    switch (iconName) {
      case 'chair':
        return Icons.chair;
      case 'electronics':
        return Icons.devices;
      case 'shipping':
      case 'local_shipping':
        return Icons.local_shipping;
      case 'new_releases':
        return Icons.new_releases;
      default:
        return Icons.local_offer;
    }
  }

  Widget _buildBannerBackground(String? imagePath) {
    if (imagePath != null && imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildBannerGradient(),
      );
    }
    if (imagePath != null && imagePath.contains('://')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildBannerGradient(),
      );
    }
    return _buildBannerGradient();
  }

  Widget _buildBannerGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.8),
            AppTheme.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'categories'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: controller.onSeeAllCategories,
              child: Text(
                'see_all'.tr,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: Obx(
            () => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return _buildCategoryIcon(context, category);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return GestureDetector(
      onTap: () => controller.onCategoryTapped(category['id']),
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Color(category['color']).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(category['icon']),
                color: Color(category['color']),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category['name'],
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'fashion':
        return Icons.checkroom;
      case 'electronics':
        return Icons.devices;
      case 'home':
        return Icons.home;
      case 'beauty':
        return Icons.face;
      case 'grocery':
        return Icons.local_grocery_store;
      case 'sports':
        return Icons.sports_soccer;
      case 'toys':
        return Icons.toys;
      case 'books':
        return Icons.menu_book;
      case 'automotive':
        return Icons.directions_car;
      case 'health':
        return Icons.health_and_safety;
      case 'jewelry':
        return Icons.diamond;
      case 'mobiles':
        return Icons.smartphone;
      case 'laptops':
        return Icons.laptop;
      case 'shoes':
        return Icons.hiking;
      case 'furniture':
        return Icons.chair;
      default:
        return Icons.category;
    }
  }

  Widget _buildVendorProductsSection(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingVendorProducts.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.vendorProducts.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'vendor_products'.tr,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ...controller.vendorProducts.map((vendor) {
            final products = vendor['products'] as List<Map<String, dynamic>>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.store,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vendor['vendorName'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${products.length} ${'products_count'.tr}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildVendorProductCard(context, product);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      );
    });
  }

  Widget _buildVendorProductCard(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final hasDiscount = product['originalPrice'] != null;

    return GestureDetector(
      onTap: () => controller.onProductTapped(product['id']),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: _buildProductImage(product['image'], 120, 40),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product['description'] != null &&
                      product['description'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        product['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${product['rating']}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '\$${product['price'].toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '\$${product['originalPrice'].toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Get.isDarkMode
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewArrivalSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'new_arrival'.tr,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: controller.onSeeAllNewArrivals,
                child: Text(
                  'see_all'.tr,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = controller.recommendedProducts[index];
                return _buildNewArrivalCard(context, product);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewArrivalCard(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    final hasDiscount = product['originalPrice'] != null;

    return GestureDetector(
      onTap: () => controller.onProductTapped(product['id']),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: _buildProductImage(product['image'], 140, 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product['price'].toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            controller.onAddToCartTapped(product['id']),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasDiscount)
                    Text(
                      '\$${product['originalPrice'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath, double height, double iconSize) {
    if (imagePath != null &&
        imagePath != 'default' &&
        imagePath.contains('/')) {
      return Image.network(
        '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/$imagePath',
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => SizedBox(
          height: height,
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: iconSize,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      child: Center(
        child: Icon(
          Icons.shopping_bag,
          size: iconSize,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
