import 'package:get/get.dart';
import 'search_controller.dart' as custom_search;

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<custom_search.SearchController>(
      () => custom_search.SearchController(),
    );
  }
}
