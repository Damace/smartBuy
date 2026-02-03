import 'package:get/get.dart';
import '../cart/cart_controller.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  // Get cart item count from CartController
  RxInt get cartItemCount {
    try {
      final cartController = Get.find<CartController>();
      return cartController.cartItemCount.obs;
    } catch (e) {
      return 0.obs;
    }
  }
}
