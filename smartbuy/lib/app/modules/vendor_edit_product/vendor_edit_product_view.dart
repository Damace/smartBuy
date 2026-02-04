import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_edit_product_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorEditProductView extends GetView<VendorEditProductController> {
  const VendorEditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('edit_product'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentTabIndex,
                children: [
                  _buildGeneralTab(),
                  _buildPricingTab(),
                  _buildShippingTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
      child: Obx(
        () => Row(
          children: [
            _buildTab('general', 'general'.tr),
            _buildTab('pricing', 'pricing'.tr),
            _buildTab('shipping', 'shipping'.tr),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String value, String label) {
    final isSelected = controller.selectedTab.value == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.orange : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? Colors.orange
                  : Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Media
          Text(
            'product_media'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'add_up_to_10_images_or_videos'.tr,
            style: TextStyle(
              fontSize: 13,
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          _buildProductImages(),
          const SizedBox(height: 24),

          // Basic Information
          Text(
            'basic_information'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Product Title
          _buildTextField(
            label: 'product_title'.tr,
            controller: controller.titleController,
          ),
          const SizedBox(height: 16),

          // Category
          _buildCategoryDropdown(),
          const SizedBox(height: 16),

          // Price and Stock Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'price'.tr + ' (\$)',
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'stock'.tr,
                  controller: controller.stockController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'description'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'enter_product_description'.tr,
              filled: true,
              fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Delete Product Button
          OutlinedButton.icon(
            onPressed: controller.showDeleteProductDialog,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              'delete_product'.tr,
              style: const TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Save Changes Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'save_changes'.tr,
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

  Widget _buildPricingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Pricing
          Text(
            'basic_pricing'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Base Price and Sale Price Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'base_price'.tr + ' (\$)',
                  controller: controller.basePriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'sale_price'.tr + ' (\$)',
                  controller: controller.salePriceController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // SKU
          _buildTextField(
            label: 'sku'.tr.toUpperCase(),
            controller: controller.skuController,
          ),
          const SizedBox(height: 24),

          // Variants
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'variants'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: controller.addVariant,
                icon: const Icon(Icons.add, color: Colors.orange, size: 18),
                label: Text(
                  'add_variant'.tr,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Size Variants
          _buildVariantSection(
            label: 'size'.tr.toUpperCase(),
            variants: controller.availableSizes,
            selectedVariants: controller.selectedSizes,
            onTap: controller.toggleSize,
            onEdit: controller.editSizeVariants,
          ),
          const SizedBox(height: 16),

          // Color Variants
          _buildVariantSection(
            label: 'color'.tr.toUpperCase(),
            variants: controller.selectedColors,
            selectedVariants: controller.selectedColors,
            onTap: controller.toggleColor,
            onEdit: controller.editColorVariants,
            isColorVariant: true,
          ),
          const SizedBox(height: 24),

          // Update Inventory Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.updateInventory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'update_inventory'.tr,
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

  Widget _buildShippingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logistics Details
          Text(
            'logistics_details'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Product Weight
          _buildTextField(
            label: 'product_weight'.tr + ' (kg)',
            controller: controller.weightController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Dimensions Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'length'.tr + ' (cm)',
                  controller: controller.lengthController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  label: 'width'.tr + ' (cm)',
                  controller: controller.widthController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  label: 'height'.tr + ' (cm)',
                  controller: controller.heightController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Shipping Method
          Text(
            'shipping_method'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Shipping Class Dropdown
          _buildShippingClassDropdown(),
          const SizedBox(height: 24),

          // Policies
          Text(
            'policies'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Enable Return Policy Toggle
          Container(
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'enable_return_policy'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                  ),
                ),
                Obx(
                  () => Switch(
                    value: controller.enableReturnPolicy.value,
                    onChanged: controller.toggleReturnPolicy,
                    activeTrackColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Remove & Update Product Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.removeAndUpdateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'remove_update_product'.tr,
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

  Widget _buildProductImages() {
    return Obx(
      () => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.productImages.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.productImages.length) {
              // Add image button
              return GestureDetector(
                onTap: controller.addProductImage,
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              );
            }

            // Product image
            return Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      controller.productImages[index],
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => controller.removeProductImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedCategory.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
                dropdownColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                items: controller.categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: controller.setCategory,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingClassDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'shipping_class'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedShippingClass.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
                dropdownColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                items: controller.shippingClasses
                    .map((shippingClass) => DropdownMenuItem<String>(
                          value: shippingClass,
                          child: Text(shippingClass),
                        ))
                    .toList(),
                onChanged: controller.setShippingClass,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSection({
    required String label,
    required List<String> variants,
    required RxList<String> selectedVariants,
    required Function(String) onTap,
    required VoidCallback onEdit,
    bool isColorVariant = false,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: variants.map((variant) {
                final isSelected = selectedVariants.contains(variant);
                return GestureDetector(
                  onTap: () => onTap(variant),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange.withValues(alpha: 0.1)
                          : Get.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orange
                            : Get.isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      variant,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? Colors.orange
                            : Get.isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
