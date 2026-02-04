import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class NetworkConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxBool isConnected = false.obs;
  final RxBool isChecking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Check if any of the results indicate connectivity
    final hasConnection = results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);

    isConnected.value = hasConnection;

    // If connection is restored, go back or show success message
    if (hasConnection) {
      Helpers.showSuccess('connection_restored'.tr);
      // Wait a bit before going back
      Future.delayed(const Duration(seconds: 1), () {
        if (Get.isDialogOpen == true) {
          Get.back();
        } else if (Get.currentRoute == '/network-connection') {
          Get.back();
        }
      });
    }
  }

  Future<void> retryConnection() async {
    isChecking.value = true;

    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);

      if (!isConnected.value) {
        Helpers.showError('still_no_connection'.tr);
      }
    } catch (e) {
      Helpers.showError('connection_check_failed'.tr);
    } finally {
      isChecking.value = false;
    }
  }

  void openSettings() {
    // This will open device settings
    // Note: Opening system settings requires platform-specific implementation
    // For now, we'll show a message
    Helpers.showInfo('open_settings_manually'.tr);
  }
}
