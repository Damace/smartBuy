import 'package:get/get.dart';
import 'category_list_controller.dart';

class CategoryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryListController>(() => CategoryListController());
  }
}
