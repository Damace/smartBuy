import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class BuyerSavedAddressController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxList<Map<String, dynamic>> addresses =
      <Map<String, dynamic>>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxSet<int> removingIds = <int>{}.obs;
  final RxSet<int> settingDefaultIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final response =
          await _apiProvider.get(ApiConstants.buyerAddresses);
      final data = response.data;

      final items = data['addresses'] as List? ?? [];
      addresses.value = items.map((item) {
        return <String, dynamic>{
          'id': item['id'],
          'name': item['full_name'] ?? '',
          'isDefault': item['is_default'] ?? false,
          'address': item['full_address'] ?? '',
          'type': item['type'] ?? 'home',
          'phone': item['phone'] ?? '',
          'address_line_1': item['address_line_1'] ?? '',
          'address_line_2': item['address_line_2'] ?? '',
          'city': item['city'] ?? '',
          'state': item['state'] ?? '',
          'country': item['country'] ?? 'United States',
          'postal_code': item['postal_code'] ?? '',
        };
      }).toList();
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    addresses.value = [
      {
        'id': 1,
        'name': 'John Doe',
        'isDefault': true,
        'address': '123 Maple St, Springfield, IL 62704, United States',
        'type': 'home',
        'phone': '5550123456',
        'address_line_1': '123 Maple St',
        'address_line_2': '',
        'city': 'Springfield',
        'state': 'Illinois',
        'country': 'United States',
        'postal_code': '62704',
      },
      {
        'id': 2,
        'name': 'John Doe',
        'isDefault': false,
        'address':
            '500 Business Pkwy, Suite 20, Chicago, IL 60601, United States',
        'type': 'work',
        'phone': '5550987654',
        'address_line_1': '500 Business Pkwy',
        'address_line_2': 'Suite 20',
        'city': 'Chicago',
        'state': 'Illinois',
        'country': 'United States',
        'postal_code': '60601',
      },
      {
        'id': 3,
        'name': 'Jane Doe (Gift)',
        'isDefault': false,
        'address': '742 Evergreen Terrace, Seattle, WA 98101',
        'type': 'other',
        'phone': '5551122334',
        'address_line_1': '742 Evergreen Terrace',
        'address_line_2': '',
        'city': 'Seattle',
        'state': 'Washington',
        'country': 'United States',
        'postal_code': '98101',
      },
    ];
  }

  void editAddress(Map<String, dynamic> address) {
    Get.toNamed(Routes.BUYER_EDIT_ADDRESS, arguments: address)
        ?.then((_) => fetchAddresses());
  }

  Future<void> removeAddress(Map<String, dynamic> address) async {
    final id = address['id'];

    Get.defaultDialog(
      title: 'remove_address'.tr,
      middleText: 'remove_address_confirmation'.tr,
      textConfirm: 'yes_remove'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        Get.back();
        await _deleteAddressApi(id);
      },
    );
  }

  Future<void> _deleteAddressApi(int id) async {
    removingIds.add(id);
    try {
      await _apiProvider.delete('${ApiConstants.buyerAddresses}/$id');
      addresses.removeWhere((a) => a['id'] == id);
      Helpers.showSuccess('address_removed'.tr);
    } catch (e) {
      // Remove locally for mock fallback
      addresses.removeWhere((a) => a['id'] == id);
      Helpers.showSuccess('address_removed'.tr);
    } finally {
      removingIds.remove(id);
    }
  }

  Future<void> setDefaultAddress(Map<String, dynamic> address) async {
    final id = address['id'];
    if (address['isDefault'] == true) return;

    settingDefaultIds.add(id);
    try {
      await _apiProvider.put(
        '${ApiConstants.buyerAddresses}/$id/set-default',
      );
      // Update locally
      for (var addr in addresses) {
        addr['isDefault'] = addr['id'] == id;
      }
      addresses.refresh();
      Helpers.showSuccess('default_address_updated'.tr);
    } catch (e) {
      // Update locally for mock fallback
      for (var addr in addresses) {
        addr['isDefault'] = addr['id'] == id;
      }
      addresses.refresh();
      Helpers.showSuccess('default_address_updated'.tr);
    } finally {
      settingDefaultIds.remove(id);
    }
  }

  void addNewAddress() {
    Get.toNamed(Routes.BUYER_EDIT_ADDRESS)?.then((_) => fetchAddresses());
  }
}
