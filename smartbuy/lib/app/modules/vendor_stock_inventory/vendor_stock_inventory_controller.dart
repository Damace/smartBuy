import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String warehouse;
  final String image;
  final RxInt quantity;
  String status;
  final RxBool autoMarkOutOfStock;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    this.warehouse = '',
    required this.image,
    required int quantity,
    required this.status,
    bool autoMark = false,
  })  : quantity = quantity.obs,
        autoMarkOutOfStock = autoMark.obs;
}

class VendorStockInventoryController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxString selectedFilter = 'low_stock'.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoading = false.obs;

  // Inventory items
  final RxList<InventoryItem> inventory = <InventoryItem>[].obs;

  // Counts from API
  final RxInt _lowStockCount = 0.obs;
  final RxInt _outOfStockCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    isLoading.value = true;
    try {
      final queryParams = <String, dynamic>{
        'status': selectedFilter.value,
      };
      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      final response = await _apiProvider.get(
        ApiConstants.vendorInventory,
        queryParameters: queryParams,
      );

      final data = response.data;
      final items = data['inventory'] as List? ?? [];
      final counts = data['counts'] as Map<String, dynamic>? ?? {};

      _lowStockCount.value = counts['low_stock'] ?? 0;
      _outOfStockCount.value = counts['out_of_stock'] ?? 0;

      inventory.value = items.map((item) {
        return InventoryItem(
          id: item['id'].toString(),
          name: item['name'] ?? '',
          sku: item['sku'] ?? '',
          image: item['image'] ?? '',
          quantity: item['quantity'] ?? 0,
          status: item['status'] ?? 'healthy',
        );
      }).toList();
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    inventory.value = [
      InventoryItem(
        id: '1',
        name: 'Wireless Headphones G5',
        sku: 'SM-8829',
        warehouse: 'NORTH A1',
        image: '',
        quantity: 3,
        status: 'low_stock',
        autoMark: true,
      ),
      InventoryItem(
        id: '2',
        name: 'Pro-Fit Mouse X1',
        sku: 'MS-4412',
        warehouse: 'WEST B2',
        image: '',
        quantity: 12,
        status: 'healthy',
      ),
      InventoryItem(
        id: '3',
        name: 'RGB Mech Keyboard K1',
        sku: 'KB-1109',
        warehouse: 'NORTH A4',
        image: '',
        quantity: 0,
        status: 'out_of_stock',
        autoMark: true,
      ),
    ];
    _lowStockCount.value = 1;
    _outOfStockCount.value = 1;
  }

  // Filtered inventory — API already returns filtered results
  List<InventoryItem> get filteredInventory {
    return inventory.toList();
  }

  // Get counts
  int get lowStockCount => _lowStockCount.value;
  int get outOfStockCount => _outOfStockCount.value;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
    fetchInventory();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    fetchInventory();
  }

  Future<void> _updateStockOnServer(InventoryItem item) async {
    try {
      await _apiProvider.put(
        '${ApiConstants.vendorInventory}/${item.id}',
        data: {'quantity': item.quantity.value},
      );
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    }
  }

  void incrementQuantity(InventoryItem item) {
    item.quantity.value++;
    _updateLocalStatus(item);
    _updateStockOnServer(item);
  }

  void decrementQuantity(InventoryItem item) {
    if (item.quantity.value > 0) {
      item.quantity.value--;
      _updateLocalStatus(item);
      _updateStockOnServer(item);
    }
  }

  void _updateLocalStatus(InventoryItem item) {
    if (item.quantity.value == 0) {
      item.status = 'out_of_stock';
    } else if (item.quantity.value <= 5) {
      item.status = 'low_stock';
    } else {
      item.status = 'healthy';
    }
    inventory.refresh();
  }

  void toggleAutoMark(InventoryItem item) {
    item.autoMarkOutOfStock.toggle();
  }

  void addNewInventoryItem() {
    Helpers.showInfo('add_inventory_item_feature_coming_soon'.tr);
  }

  void showItemOptions(InventoryItem item) {
    Helpers.showInfo('item_options_coming_soon'.tr);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
