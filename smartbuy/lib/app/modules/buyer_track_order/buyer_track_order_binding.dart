import 'package:get/get.dart';
import 'buyer_track_order_controller.dart';

class BuyerTrackOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerTrackOrderController>(
      () => BuyerTrackOrderController(),
    );
  }
}
