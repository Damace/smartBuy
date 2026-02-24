import 'dart:async';
import 'package:SmartBuy/app/routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  final RxBool isOnline = true.obs;
  final RxBool isChecking = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _listenToConnectivity();
  }

  /// 🔹 Initial check (app launch)
  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _handleStatus(results);
  }

  /// 🔹 Listen to changes (WiFi / Mobile / None)
  void _listenToConnectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_handleStatus);
  }

  /// 🔹 Central logic (THIS CONTROLS THE SCREEN)
  void _handleStatus(List<ConnectivityResult> results) {
    final hasInternet = !results.contains(ConnectivityResult.none);

    isOnline.value = hasInternet;

    if (!hasInternet) {
      // 🚨 NO INTERNET → SHOW SCREEN
      if (Get.currentRoute != Get.toNamed(Routes.SYSTEM_STATUS)) {
        Get.toNamed(Routes.SYSTEM_STATUS);
      }
    } else {
      // ✅ INTERNET RESTORED → CLOSE SCREEN
      if (Get.currentRoute == Get.toNamed(Routes.SYSTEM_STATUS)) {
        Get.back();
      }
    }
  }

  /// 🔁 Manual retry button
  Future<void> checkNow() async {
    isChecking.value = true;
    final results = await _connectivity.checkConnectivity();
    _handleStatus(results);
    isChecking.value = false;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
