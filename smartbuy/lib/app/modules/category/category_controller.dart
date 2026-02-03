import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxList<Map<String, dynamic>> subcategories = <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadSubcategories(0);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadCategories() {
    // Mock data - replace with API call
    categories.value = [
      {
        'id': '1',
        'name': 'electronics',
        'icon': Icons.devices,
        'color': 0xFFEF8D32,
      },
      {
        'id': '2',
        'name': 'fashion',
        'icon': Icons.checkroom,
        'color': 0xFFEF8D32,
      },
      {
        'id': '3',
        'name': 'home_category',
        'icon': Icons.home,
        'color': 0xFFEF8D32,
      },
      {
        'id': '4',
        'name': 'beauty',
        'icon': Icons.face,
        'color': 0xFFEF8D32,
      },
      {
        'id': '5',
        'name': 'groceries',
        'icon': Icons.shopping_basket,
        'color': 0xFFEF8D32,
      },
      {
        'id': '6',
        'name': 'toys',
        'icon': Icons.toys,
        'color': 0xFFEF8D32,
      },
      {
        'id': '7',
        'name': 'sports',
        'icon': Icons.sports_basketball,
        'color': 0xFFEF8D32,
      },
    ];
  }

  void loadSubcategories(int categoryIndex) {
    selectedCategoryIndex.value = categoryIndex;
    final categoryId = categories[categoryIndex]['id'];

    // Mock subcategories data - replace with API call
    switch (categoryId) {
      case '1': // Electronics
        subcategories.value = [
          {
            'id': '1-1',
            'name': 'mobiles',
            'subtitle': 'phones_tablets',
            'icon': Icons.phone_android,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '1-2',
            'name': 'laptops',
            'subtitle': 'computing',
            'icon': Icons.laptop,
            'color': 0xFF95E1D3,
          },
          {
            'id': '1-3',
            'name': 'audio',
            'subtitle': 'headphones_speakers',
            'icon': Icons.headphones,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '1-4',
            'name': 'cameras',
            'subtitle': 'photography',
            'icon': Icons.camera_alt,
            'color': 0xFF2D3436,
          },
          {
            'id': '1-5',
            'name': 'wearables',
            'subtitle': 'smart_watches',
            'icon': Icons.watch,
            'color': 0xFFFF6B6B,
          },
          {
            'id': '1-6',
            'name': 'gaming',
            'subtitle': 'consoles_accessories',
            'icon': Icons.sports_esports,
            'color': 0xFF4834D4,
          },
        ];
        break;
      case '2': // Fashion
        subcategories.value = [
          {
            'id': '2-1',
            'name': 'mens_clothing',
            'subtitle': 'shirts_pants_suits',
            'icon': Icons.checkroom,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '2-2',
            'name': 'womens_clothing',
            'subtitle': 'dresses_tops_skirts',
            'icon': Icons.woman,
            'color': 0xFF95E1D3,
          },
          {
            'id': '2-3',
            'name': 'shoes',
            'subtitle': 'footwear_sneakers',
            'icon': Icons.directions_run,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '2-4',
            'name': 'accessories',
            'subtitle': 'bags_jewelry',
            'icon': Icons.shopping_bag,
            'color': 0xFF2D3436,
          },
        ];
        break;
      case '3': // Home
        subcategories.value = [
          {
            'id': '3-1',
            'name': 'furniture',
            'subtitle': 'sofas_tables_chairs',
            'icon': Icons.weekend,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '3-2',
            'name': 'kitchen',
            'subtitle': 'appliances_utensils',
            'icon': Icons.kitchen,
            'color': 0xFF95E1D3,
          },
          {
            'id': '3-3',
            'name': 'decor',
            'subtitle': 'lighting_rugs',
            'icon': Icons.lightbulb,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '3-4',
            'name': 'bedding',
            'subtitle': 'sheets_pillows',
            'icon': Icons.bed,
            'color': 0xFF2D3436,
          },
        ];
        break;
      case '4': // Beauty
        subcategories.value = [
          {
            'id': '4-1',
            'name': 'skincare',
            'subtitle': 'creams_serums',
            'icon': Icons.face_retouching_natural,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '4-2',
            'name': 'makeup',
            'subtitle': 'cosmetics',
            'icon': Icons.color_lens,
            'color': 0xFF95E1D3,
          },
          {
            'id': '4-3',
            'name': 'haircare',
            'subtitle': 'shampoos_conditioners',
            'icon': Icons.content_cut,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '4-4',
            'name': 'fragrance',
            'subtitle': 'perfumes_colognes',
            'icon': Icons.local_florist,
            'color': 0xFF2D3436,
          },
        ];
        break;
      case '5': // Groceries
        subcategories.value = [
          {
            'id': '5-1',
            'name': 'fresh_produce',
            'subtitle': 'fruits_vegetables',
            'icon': Icons.food_bank,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '5-2',
            'name': 'beverages',
            'subtitle': 'drinks_juices',
            'icon': Icons.local_drink,
            'color': 0xFF95E1D3,
          },
          {
            'id': '5-3',
            'name': 'snacks',
            'subtitle': 'chips_cookies',
            'icon': Icons.fastfood,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '5-4',
            'name': 'pantry',
            'subtitle': 'grains_canned_goods',
            'icon': Icons.inventory_2,
            'color': 0xFF2D3436,
          },
        ];
        break;
      case '6': // Toys
        subcategories.value = [
          {
            'id': '6-1',
            'name': 'action_figures',
            'subtitle': 'collectibles',
            'icon': Icons.toys,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '6-2',
            'name': 'dolls',
            'subtitle': 'plush_toys',
            'icon': Icons.child_care,
            'color': 0xFF95E1D3,
          },
          {
            'id': '6-3',
            'name': 'educational',
            'subtitle': 'learning_toys',
            'icon': Icons.school,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '6-4',
            'name': 'outdoor_toys',
            'subtitle': 'bikes_scooters',
            'icon': Icons.directions_bike,
            'color': 0xFF2D3436,
          },
        ];
        break;
      case '7': // Sports
        subcategories.value = [
          {
            'id': '7-1',
            'name': 'fitness',
            'subtitle': 'gym_equipment',
            'icon': Icons.fitness_center,
            'color': 0xFF4ECDC4,
          },
          {
            'id': '7-2',
            'name': 'team_sports',
            'subtitle': 'soccer_basketball',
            'icon': Icons.sports_soccer,
            'color': 0xFF95E1D3,
          },
          {
            'id': '7-3',
            'name': 'outdoor_sports',
            'subtitle': 'camping_hiking',
            'icon': Icons.terrain,
            'color': 0xFF6C5CE7,
          },
          {
            'id': '7-4',
            'name': 'sportswear',
            'subtitle': 'athletic_clothing',
            'icon': Icons.checkroom,
            'color': 0xFF2D3436,
          },
        ];
        break;
      default:
        subcategories.value = [];
    }
  }

  void selectCategory(int index) {
    if (selectedCategoryIndex.value != index) {
      selectedCategoryIndex.value = index;
      loadSubcategories(index);
    }
  }

  void onSearchTapped() {
    // Navigate to search screen
    Get.toNamed('/search');
  }

  void onSubcategoryTapped(String subcategoryId) {
    // Navigate to products screen for this subcategory
    print('Subcategory tapped: $subcategoryId');
  }

  void onViewAllTapped() {
    // Navigate to all products for this category
    print('View all tapped for category: ${categories[selectedCategoryIndex.value]['name']}');
  }
}
