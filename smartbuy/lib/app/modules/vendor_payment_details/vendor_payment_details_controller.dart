import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/providers/api_provider.dart';

class VendorPaymentDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  
  final RxList<Map<String, dynamic>> escrowPayments = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  
  final RxDouble totalBalance = 0.0.obs;
  final RxDouble pendingBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPaymentDetails();
  }

  Future<void> loadPaymentDetails() async {
    isLoading.value = true;
    try {
      // Endpoint to fetch vendor escrow records
      final response = await _apiProvider.get('/vendor/payments/escrow');
      
      final data = response.data['data'];
      if (data is List) {
        escrowPayments.assignAll(data.cast<Map<String, dynamic>>());
        
        // Calculate balances locally for UI
        pendingBalance.value = escrowPayments
            .where((e) => e['status'] == 'pending')
            .fold(0.0, (sum, item) => sum + _toDouble(item['vendor_amount']));
            
        totalBalance.value = escrowPayments
            .where((e) => e['status'] == 'released')
            .fold(0.0, (sum, item) => sum + _toDouble(item['vendor_amount']));
      }
    } catch (e) {
      debugPrint("Error loading payment details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
