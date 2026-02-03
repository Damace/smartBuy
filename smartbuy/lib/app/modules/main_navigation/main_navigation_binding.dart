import 'package:get/get.dart';
import 'main_navigation_controller.dart';
import '../home/home_controller.dart';
import '../category/category_controller.dart';
import '../cart/cart_controller.dart';
import '../notification/notification_controller.dart';
import '../profile/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
