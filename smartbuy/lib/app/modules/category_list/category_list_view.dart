import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_list_controller.dart';

class CategoryListView extends GetView<CategoryListController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(controller.categoryName),
        leading: const BackButton(),
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilters(),
          const SizedBox(height: 8),
          _buildResultsHeader(),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.searchProducts,
        decoration: InputDecoration(
          hintText: "Search in ${controller.categoryName}",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: Obx(() {
        final selected = controller.selectedFilter.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.filters.length,
          itemBuilder: (context, index) {
            final filter = controller.filters[index];
            final isSelected = selected == filter;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => controller.changeFilter(filter),
                selectedColor: Colors.orange,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text("${controller.filteredProducts.length} Results")),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isGrid.value ? Icons.view_list : Icons.grid_view,
              ),
              onPressed: controller.toggleLayout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredProducts.isEmpty) {
        return Center(
          child: Text(
            "No ${controller.categoryName} products found",
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      if (controller.isGrid.value) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductGridItem(controller.filteredProducts[index]);
          },
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (context, index) {
          return _buildProductListItem(controller.filteredProducts[index]);
        },
      );
    });
  }

  Widget _buildProductListItem(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Product Image
          _buildProductImage(product['image'], 80, 80),

          const SizedBox(width: 12),

          /// Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                _buildRating(product['rating']),
                const SizedBox(height: 6),
                Text(
                  "\$${product['price']}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          /// Add Button
          GestureDetector(
            onTap: () => controller.addToCart(product['id']),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridItem(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Product Image
          Expanded(
            child: _buildProductImage(product['image'], double.infinity, 120),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$${product['price']}",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          _buildRating(product['rating']),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.addToCart(product['id']),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.orange,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
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

  Widget _buildProductImage(String? imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
              ),
            )
          : const Icon(Icons.image, size: 40),
    );
  }

  Widget _buildRating(dynamic rating) {
    return Row(
      children: [
        const Icon(Icons.star, size: 14, color: Colors.orange),
        const SizedBox(width: 4),
        Text("${rating ?? 0}", style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
