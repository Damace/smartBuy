import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../core/constants/app_constants.dart';
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
    // Simulate initialization process
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 5));
      progress.value = i / 100;
    }

    // Check if user is logged in
    final token = storage.read(AppConstants.storageKeyToken);
    if (token != null) {
      // Navigate to home
      Get.offNamed(Routes.HOME);
    } else {
      // Navigate to login
      Get.offNamed(Routes.LOGIN);
    }
  }
}
