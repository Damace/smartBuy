import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_controller.dart';
import '../../core/themes/app_theme.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text('categories'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(context),

          // Main Content with Sidebar
          Expanded(
            child: Row(
              children: [
                // Left Sidebar - Category List
                _buildCategorySidebar(context),

                // Right Content - Subcategories
                Expanded(
                  child: _buildSubcategoriesContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: controller.onSearchTapped,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'search_in_smartbuy'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySidebar(BuildContext context) {
    return Container(
      width: 90,
      color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
      child: Obx(
        () => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            final isSelected = controller.selectedCategoryIndex.value == index;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.selectCategory(index);
                },
                splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                highlightColor: AppTheme.primaryColor.withValues(alpha: 0.05),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (Get.isDarkMode
                            ? AppTheme.primaryColor.withValues(alpha: 0.15)
                            : AppTheme.backgroundColor)
                        : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with animated background
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withValues(alpha: 0.15)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          size: 24,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : (Get.isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Category label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 9,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : (Get.isDarkMode
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary),
                              letterSpacing: 0.5,
                              height: 1.2,
                            ),
                        child: Text(
                          category['name'].toString().tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubcategoriesContent(BuildContext context) {
    return Obx(
      () => Container(
        color: Get.isDarkMode ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        child: Column(
          children: [
            // Category Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.categories[controller.selectedCategoryIndex.value]['name']
                        .toString()
                        .tr
                        .capitalizeFirst!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: controller.onViewAllTapped,
                    child: Text(
                      'view_all'.tr,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Subcategories Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: controller.subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = controller.subcategories[index];
                  return _buildSubcategoryCard(context, subcategory);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(BuildContext context, Map<String, dynamic> subcategory) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.onSubcategoryTapped(subcategory['id']),
        borderRadius: BorderRadius.circular(12),
        splashColor: Color(subcategory['color']).withValues(alpha: 0.1),
        highlightColor: Color(subcategory['color']).withValues(alpha: 0.05),
        child: Ink(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(subcategory['color']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    subcategory['icon'],
                    size: 40,
                    color: Color(subcategory['color']),
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  subcategory['name'].toString().tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Subtitle
                Text(
                  subcategory['subtitle'].toString().tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
