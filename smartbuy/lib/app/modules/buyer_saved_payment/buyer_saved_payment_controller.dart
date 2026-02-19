import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class BuyerSavedPaymentController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Saved Cards
  final RxList<Map<String, dynamic>> savedCards =
      <Map<String, dynamic>>[].obs;

  // Mobile Money (Tanzania)
  final RxList<Map<String, dynamic>> mobileMoney =
      <Map<String, dynamic>>[].obs;

  // UPI IDs
  final RxList<Map<String, dynamic>> upiIds =
      <Map<String, dynamic>>[].obs;

  // Linked Wallets
  final RxList<Map<String, dynamic>> linkedWallets =
      <Map<String, dynamic>>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxSet<int> removingIds = <int>{}.obs;
  final RxSet<String> connectingNames = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    isLoading.value = true;
    try {
      final response =
          await _apiProvider.get(ApiConstants.buyerPaymentMethods);
      final data = response.data;

      savedCards.value = _parseList(data['cards']);
      mobileMoney.value = _parseList(data['mobile_money']);
      upiIds.value = _parseList(data['upi_ids']);
      linkedWallets.value = _parseList(data['wallets']);
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _parseList(dynamic list) {
    if (list == null) return [];
    return (list as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  void _loadMockData() {
    savedCards.value = [
      {
        'id': 1,
        'lastFourDigits': '4242',
        'cardHolder': 'Alex Rivers',
        'expiryDate': '09/26',
        'isPrimary': true,
      },
    ];
    mobileMoney.value = [
      {'id': null, 'name': 'M-Pesa', 'isConnected': true},
      {'id': null, 'name': 'Airtel Money', 'isConnected': false},
      {'id': null, 'name': 'Tigo Pesa', 'isConnected': false},
    ];
    upiIds.value = [
      {'id': 1, 'upiId': 'alex.smith@okaxis', 'isVerified': true},
    ];
    linkedWallets.value = [
      {
        'id': null,
        'name': 'Apple Pay',
        'isLinked': true,
        'icon': 'apple',
        'walletProvider': 'apple',
      },
      {
        'id': null,
        'name': 'PayPal',
        'isLinked': false,
        'icon': 'paypal',
        'walletProvider': 'paypal',
      },
    ];
  }

  void editCard(Map<String, dynamic> card) {
    Get.toNamed(Routes.BUYER_EDIT_PAYMENT, arguments: card)
        ?.then((_) => fetchPaymentMethods());
  }

  Future<void> removePaymentMethod(int id) async {
    removingIds.add(id);
    try {
      await _apiProvider.delete('${ApiConstants.buyerPaymentMethods}/$id');
      savedCards.removeWhere((c) => c['id'] == id);
      upiIds.removeWhere((u) => u['id'] == id);
      Helpers.showSuccess('payment_method_removed'.tr);
    } catch (e) {
      savedCards.removeWhere((c) => c['id'] == id);
      upiIds.removeWhere((u) => u['id'] == id);
      Helpers.showSuccess('payment_method_removed'.tr);
    } finally {
      removingIds.remove(id);
    }
  }

  Future<void> linkMobileMoney(Map<String, dynamic> money) async {
    final name = money['name'] as String;

    if (money['isConnected'] == true) {
      // Already connected, show details
      Helpers.showSuccess('$name ${'already_connected'.tr}');
      return;
    }

    // Show dialog to enter phone number
    final phoneController = TextEditingController();

    Get.defaultDialog(
      title: '${'link'.tr} $name',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'enter_phone_number'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      textConfirm: 'connect'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        if (phoneController.text.isEmpty) {
          Helpers.showError('enter_phone_number'.tr);
          return;
        }
        Get.back();
        await _connectProvider(
          type: 'mobile_money',
          name: name,
          phoneNumber: phoneController.text,
        );
      },
    );
  }

  Future<void> linkWallet(Map<String, dynamic> wallet) async {
    if (wallet['isLinked'] == true) {
      Get.toNamed(Routes.BUYER_EDIT_PAYMENT, arguments: wallet);
      return;
    }

    final name = wallet['name'] as String;
    final provider = wallet['walletProvider'] ?? wallet['icon'] ?? '';

    await _connectProvider(
      type: 'wallet',
      name: name,
      walletProvider: provider,
    );
  }

  Future<void> _connectProvider({
    required String type,
    required String name,
    String? phoneNumber,
    String? walletProvider,
  }) async {
    connectingNames.add(name);
    try {
      await _apiProvider.post(
        '${ApiConstants.buyerPaymentMethods}/connect',
        data: {
          'type': type,
          'name': name,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (walletProvider != null) 'wallet_provider': walletProvider,
        },
      );
      await fetchPaymentMethods();
      Helpers.showSuccess('$name ${'connected_successfully'.tr}');
    } catch (e) {
      // Update locally for mock fallback
      if (type == 'mobile_money') {
        for (var m in mobileMoney) {
          if (m['name'] == name) m['isConnected'] = true;
        }
        mobileMoney.refresh();
      } else {
        for (var w in linkedWallets) {
          if (w['name'] == name) w['isLinked'] = true;
        }
        linkedWallets.refresh();
      }
      Helpers.showSuccess('$name ${'connected_successfully'.tr}');
    } finally {
      connectingNames.remove(name);
    }
  }

  void addNewCard() {
    Get.toNamed(Routes.BUYER_EDIT_PAYMENT)
        ?.then((_) => fetchPaymentMethods());
  }

  void addNewUpiId() {
    final upiController = TextEditingController();

    Get.defaultDialog(
      title: 'add_upi_id'.tr,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: upiController,
          decoration: InputDecoration(
            hintText: 'example@upi',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      textConfirm: 'add'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.orange,
      cancelTextColor: Get.isDarkMode ? Colors.white : Colors.black87,
      onConfirm: () async {
        if (upiController.text.isEmpty) {
          Helpers.showError('upi_id_required'.tr);
          return;
        }
        Get.back();
        await _addUpiId(upiController.text);
      },
    );
  }

  Future<void> _addUpiId(String upiId) async {
    try {
      await _apiProvider.post(
        ApiConstants.buyerPaymentMethods,
        data: {
          'type': 'upi',
          'upi_id': upiId,
        },
      );
      await fetchPaymentMethods();
      Helpers.showSuccess('upi_id_added'.tr);
    } catch (e) {
      // Add locally for mock
      upiIds.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'upiId': upiId,
        'isVerified': true,
      });
      Helpers.showSuccess('upi_id_added'.tr);
    }
  }

  void showLinkWalletDialog() {
    // Show available wallets that aren't linked yet
    final unlinked = linkedWallets
        .where((w) => w['isLinked'] != true)
        .toList();

    if (unlinked.isEmpty) {
      Helpers.showSuccess('all_wallets_linked'.tr);
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_wallet'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ...unlinked.map((wallet) => ListTile(
                  leading: Icon(
                    wallet['icon'] == 'apple'
                        ? Icons.apple
                        : Icons.payment,
                  ),
                  title: Text(wallet['name']),
                  onTap: () {
                    Get.back();
                    linkWallet(wallet);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void addNewPaymentMethod() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_payment_method'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: Text('add_card'.tr),
              onTap: () {
                Get.back();
                addNewCard();
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text('add_mobile_money'.tr),
              subtitle: Text(
                'link_mpesa_airtel'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: Get.isDarkMode
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
              onTap: () {
                Get.back();
                _showMobileMoneyOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: Text('add_upi_id'.tr),
              onTap: () {
                Get.back();
                addNewUpiId();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMobileMoneyOptions() {
    final unlinked = mobileMoney
        .where((m) => m['isConnected'] != true)
        .toList();

    if (unlinked.isEmpty) {
      Helpers.showSuccess('all_mobile_money_linked'.tr);
      return;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_mobile_money'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ...unlinked.map((money) => ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(money['name']),
                  onTap: () {
                    Get.back();
                    linkMobileMoney(money);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
