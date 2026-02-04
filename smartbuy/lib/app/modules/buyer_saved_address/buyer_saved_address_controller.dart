import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class BuyerSavedAddressController extends GetxController {
  final RxList<Map<String, dynamic>> addresses = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'John Doe',
      'isDefault': true,
      'address': '123 Maple St, Springfield,\nIL 62704, United States',
      'type': 'home',
    },
    {
      'id': '2',
      'name': 'John Doe',
      'isDefault': false,
      'address': '500 Business Pkwy, Suite 20,\nChicago, IL 60601, United States',
      'type': 'work',
    },
    {
      'id': '3',
      'name': 'Jane Doe (Gift)',
      'isDefault': false,
      'address': '742 Evergreen Terrace,\nSeattle, WA 98101',
      'type': 'other',
    },
  ].obs;

  void editAddress(Map<String, dynamic> address) {
    Get.toNamed(Routes.BUYER_EDIT_ADDRESS, arguments: address);
  }

  void removeAddress(Map<String, dynamic> address) {
    Get.defaultDialog(
      title: 'remove_address'.tr,
      middleText: 'remove_address_confirmation'.tr,
      textConfirm: 'yes_remove'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        addresses.remove(address);
        Get.back();
        Helpers.showSuccess('address_removed'.tr);
      },
    );
  }

  void addNewAddress() {
    Get.toNamed(Routes.BUYER_EDIT_ADDRESS);
  }
}
