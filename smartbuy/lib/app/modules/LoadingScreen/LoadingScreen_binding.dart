import 'package:get/get.dart';
import 'LoadingScreen_controller.dart';

class LoadingScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingScreenController>(() => LoadingScreenController());
  }
}
