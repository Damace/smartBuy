import 'package:get/get.dart';

class VendorMainNavigationController extends GetxController {
  final RxInt currentIndex = 1.obs; // Start with Profile tab

  void changePage(int index) {
    currentIndex.value = index;
  }
}
