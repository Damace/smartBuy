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
    // Quick progress animation (total ~800ms for branding visibility)
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 8));
      progress.value = i / 100;
    }
    progress.value = 1.0;

    // Check if user is logged in
    final token = storage.read(AppConstants.storageKeyToken);
    final isFirstTime = storage.read(AppConstants.storageKeyIsFirstTime);

    if (token != null) {
      // Check user data for type
      final userData = storage.read(AppConstants.storageKeyUser);
      final userType = (userData is Map) ? userData['role'] : null;
      if (userType == 'vendor') {
        Get.offNamed(Routes.VENDOR_HOME);
      } else {
        Get.offNamed(Routes.HOME);
      }
    } else if (isFirstTime != false) {
      // Get.offNamed(Routes.ONBOARDING); Remind me to edit here
      Get.offNamed(Routes.LOGIN);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}
