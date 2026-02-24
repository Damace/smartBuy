import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';
import '../../core/constants/api_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('shopping_cart'.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadCartItems,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart items count
                      Text(
                        'items_in_cart'.trParams({
                          'count': controller.cartItemCount.toString(),
                        }),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),

                      // Cart items list
                      ...controller.cartItems.map(
                        (item) => _buildCartItem(context, item),
                      ),

                      const SizedBox(height: 16),

                      // Coupon code section
                      //   _buildCouponSection(context),
                      // const SizedBox(height: 16),

                      // Saved for later section
                      if (controller.savedForLater.isNotEmpty) ...[
                        _buildSavedForLaterSection(context),
                        const SizedBox(height: 16),
                      ],

                      // Summary section
                      _buildSummarySection(context),

                      const SizedBox(height: 100), // space for checkout button
                    ],
                  ),
                ),
              ),
            ),

            // Checkout button (fixed at bottom)
            _buildCheckoutButton(context),
          ],
        );
      }),
    );
  }

  // ─── Empty state ─────────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            'cart_is_empty'.tr,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'add_items_to_cart'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('continue_shopping'.tr),
          ),
        ],
      ),
    );
  }

  // ─── Cart item card ──────────────────────────────────────────────────────────

  Widget _buildCartItem(BuildContext context, CartItemModel item) {
    final product = item.product;
    if (product == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Get.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildProductImage(product.image, 70, 70),
          ),
          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.finalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if ((product.categoryName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${'vendor'.tr}: ${product.categoryName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Quantity controls + remove
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () => controller.decrementQuantity(item.id),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        item.quantity.toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: () => controller.incrementQuantity(item.id),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _showRemoveDialog(context, item),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: Get.isDarkMode
                ? AppTheme.darkBorderColor
                : AppTheme.borderColor,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppTheme.primaryColor),
      ),
    );
  }

  // ─── Coupon ──────────────────────────────────────────────────────────────────

  Widget _buildCouponSection(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.couponController,
                  enabled: controller.appliedCoupon.value.isEmpty,
                  decoration: InputDecoration(
                    hintText: 'coupon_code'.tr,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              controller.appliedCoupon.value.isEmpty
                  ? ElevatedButton(
                      onPressed: controller.applyCoupon,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('apply'.tr),
                    )
                  : OutlinedButton(
                      onPressed: controller.removeCoupon,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                      ),
                      child: Text('remove'.tr),
                    ),
            ],
          ),
          if (controller.appliedCoupon.value.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: AppTheme.successColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${'coupon'.tr}: ${controller.appliedCoupon.value}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── Saved for later ─────────────────────────────────────────────────────────

  Widget _buildSavedForLaterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'saved_for_later'.tr,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.savedForLater.length,
            itemBuilder: (context, index) {
              final product = controller.savedForLater[index];
              return _buildSavedItem(context, product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSavedItem(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () => controller.moveToCart(product),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: Get.isDarkMode
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(product.image, 80, 80),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.name,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'move_to_cart'.tr,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Summary ─────────────────────────────────────────────────────────────────

  Widget _buildSummarySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Get.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Obx(
        () => Column(
          children: [
            _buildSummaryRow(
              context,
              'subtotal'.tr,
              '\$${controller.subtotal.toStringAsFixed(2)}',
              false,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              'shipping'.tr,
              controller.shipping == 0
                  ? 'free'.tr
                  : '\$${controller.shipping.toStringAsFixed(2)}',
              false,
            ),
            if (controller.discount.value > 0) ...[
              const SizedBox(height: 12),
              _buildSummaryRow(
                context,
                'discount'.tr,
                '-\$${controller.discount.value.toStringAsFixed(2)}',
                false,
                color: AppTheme.successColor,
              ),
            ],
            const Divider(height: 24),
            _buildSummaryRow(
              context,
              'total'.tr,
              '\$${controller.total.toStringAsFixed(2)}',
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isBold, {
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18 : null,
            color: color,
          ),
        ),
      ],
    );
  }

  // ─── Checkout button ─────────────────────────────────────────────────────────

  Widget _buildCheckoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.proceedToCheckout,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'proceed_to_checkout'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Remove bottom sheet ──────────────────────────────────────────────────────

  void _showRemoveDialog(BuildContext context, CartItemModel item) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'remove_item'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'remove_item_confirmation'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              _buildBottomSheetOption(
                context,
                icon: Icons.delete_outline,
                iconColor: AppTheme.errorColor,
                title: 'remove_from_cart'.tr,
                onTap: () {
                  Get.back();
                  controller.removeItem(item.id);
                },
              ),
              _buildBottomSheetOption(
                context,
                icon: Icons.bookmark_outline,
                iconColor: AppTheme.primaryColor,
                title: 'save_for_later'.tr,
                onTap: () {
                  Get.back();
                  controller.saveForLater(item);
                },
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('cancel'.tr),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Product image helper ─────────────────────────────────────────────────────

  Widget _buildProductImage(String? imagePath, double width, double height) {
    if (imagePath != null && imagePath.contains('/')) {
      return Image.network(
        '${ApiConstants.baseUrl.replaceAll('/api', '')}/storage/$imagePath',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _imagePlaceholder(width, height),
      );
    }
    return _imagePlaceholder(width, height);
  }

  Widget _imagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Get.isDarkMode ? AppTheme.darkBackgroundColor : Colors.grey[100],
      child: Icon(
        Icons.shopping_bag,
        size: width * 0.5,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
