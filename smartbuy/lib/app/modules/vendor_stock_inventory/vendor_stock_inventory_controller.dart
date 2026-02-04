import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String warehouse;
  final String image;
  final RxInt quantity;
  final String status;
  final RxBool autoMarkOutOfStock;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.warehouse,
    required this.image,
    required int quantity,
    required this.status,
    bool autoMark = false,
  })  : quantity = quantity.obs,
        autoMarkOutOfStock = autoMark.obs;
}

class VendorStockInventoryController extends GetxController {
  final RxString selectedFilter = 'low_stock'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Inventory items
  final RxList<InventoryItem> inventory = <InventoryItem>[
    InventoryItem(
      id: '1',
      name: 'Wireless Headphones G5',
      sku: 'SM-8829',
      warehouse: 'NORTH A1',
      image: '🎧',
      quantity: 3,
      status: 'low_stock',
      autoMark: true,
    ),
    InventoryItem(
      id: '2',
      name: 'Pro-Fit Mouse X1',
      sku: 'MS-4412',
      warehouse: 'WEST B2',
      image: '🖱️',
      quantity: 12,
      status: 'healthy',
      autoMark: false,
    ),
    InventoryItem(
      id: '3',
      name: 'RGB Mech Keyboard K1',
      sku: 'KB-1109',
      warehouse: 'NORTH A4',
      image: '⌨️',
      quantity: 0,
      status: 'out_of_stock',
      autoMark: true,
    ),
  ].obs;

  // Filtered inventory based on selected filter and search
  List<InventoryItem> get filteredInventory {
    var filtered = inventory.where((item) {
      // Filter by status
      bool matchesFilter = selectedFilter.value == 'low_stock'
          ? item.status == 'low_stock'
          : item.status == 'out_of_stock';

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return matchesFilter &&
            (item.name.toLowerCase().contains(query) ||
                item.sku.toLowerCase().contains(query));
      }

      return matchesFilter;
    }).toList();

    return filtered;
  }

  // Get counts
  int get lowStockCount =>
      inventory.where((item) => item.status == 'low_stock').length;
  int get outOfStockCount =>
      inventory.where((item) => item.status == 'out_of_stock').length;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void incrementQuantity(InventoryItem item) {
    item.quantity.value++;
    updateItemStatus(item);
  }

  void decrementQuantity(InventoryItem item) {
    if (item.quantity.value > 0) {
      item.quantity.value--;
      updateItemStatus(item);
    }
  }

  void updateItemStatus(InventoryItem item) {
    // Update status based on quantity
    final index = inventory.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      String newStatus;
      if (item.quantity.value == 0) {
        newStatus = 'out_of_stock';
      } else if (item.quantity.value <= 5) {
        newStatus = 'low_stock';
      } else {
        newStatus = 'healthy';
      }

      // Update the item
      inventory[index] = InventoryItem(
        id: item.id,
        name: item.name,
        sku: item.sku,
        warehouse: item.warehouse,
        image: item.image,
        quantity: item.quantity.value,
        status: newStatus,
        autoMark: item.autoMarkOutOfStock.value,
      );
    }
  }

  void toggleAutoMark(InventoryItem item) {
    item.autoMarkOutOfStock.toggle();
  }

  void addNewInventoryItem() {
    Helpers.showInfo('add_inventory_item_feature_coming_soon'.tr);
  }

  void showItemOptions(InventoryItem item) {
    // Show options menu
    Helpers.showInfo('item_options_coming_soon'.tr);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
