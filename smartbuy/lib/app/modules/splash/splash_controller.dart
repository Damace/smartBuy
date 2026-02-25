import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final storage = GetStorage();
  final RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Remove native splash now that Flutter splash is visible
    FlutterNativeSplash.remove();

    // Progress animation (~2s total for animations to fully play)
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 95));
      progress.value = i / 100;
    }
    progress.value = 1.0;

    // Hand off to LoadingScreen for connectivity check + API pre-loading
    Get.offNamed(Routes.LOADING_SCREEN);
  }
}
