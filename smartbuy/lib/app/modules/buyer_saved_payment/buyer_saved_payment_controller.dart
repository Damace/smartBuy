import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class BuyerSavedPaymentController extends GetxController {
  // Saved Cards
  final RxList<Map<String, dynamic>> savedCards = <Map<String, dynamic>>[
    {
      'id': '1',
      'lastFourDigits': '4242',
      'cardHolder': 'Alex Rivers',
      'expiryDate': '09/26',
      'isPrimary': true,
    },
  ].obs;

  // Mobile Money (Tanzania)
  final RxList<Map<String, dynamic>> mobileMoney = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'M-Pesa',
      'isConnected': true,
      'status': 'connected',
    },
    {
      'id': '2',
      'name': 'Airtel Money',
      'isConnected': false,
      'status': 'not_linked',
    },
    {
      'id': '3',
      'name': 'Tigo Pessa',
      'isConnected': false,
      'status': 'not_linked',
    },
  ].obs;

  // UPI IDs
  final RxList<Map<String, dynamic>> upiIds = <Map<String, dynamic>>[
    {
      'id': '1',
      'upiId': 'alex.smith@okaxis',
      'isVerified': true,
    },
  ].obs;

  // Linked Wallets
  final RxList<Map<String, dynamic>> linkedWallets = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Apple Pay',
      'isLinked': true,
      'icon': 'apple',
    },
    {
      'id': '2',
      'name': 'PayPal',
      'isLinked': false,
      'icon': 'paypal',
    },
  ].obs;

  void editCard(Map<String, dynamic> card) {
    Get.toNamed(Routes.BUYER_EDIT_PAYMENT, arguments: card);
  }

  void linkMobileMoney(Map<String, dynamic> mobileMoney) {
    Helpers.showSuccess('linking_${mobileMoney['name'].toString().toLowerCase().replaceAll(' ', '_')}'.tr);
  }

  void linkWallet(Map<String, dynamic> wallet) {
    if (wallet['isLinked'] == true) {
      // Navigate to wallet details
      Get.toNamed(Routes.BUYER_EDIT_PAYMENT, arguments: wallet);
    } else {
      // Initiate linking
      Helpers.showSuccess('connecting_${wallet['name'].toString().toLowerCase()}'.tr);
    }
  }

  void addNewCard() {
    Get.toNamed(Routes.BUYER_EDIT_PAYMENT);
  }

  void addNewUpiId() {
    // Show dialog to add UPI ID
    Helpers.showSuccess('add_upi_feature_coming_soon'.tr);
  }

  void showLinkWalletDialog() {
    // Show dialog to link wallet
    Helpers.showSuccess('link_wallet_feature_coming_soon'.tr);
  }

  void addNewPaymentMethod() {
    // Show bottom sheet with payment method options
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
              onTap: () {
                Get.back();
                Helpers.showSuccess('add_mobile_money_feature_coming_soon'.tr);
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
}
