import 'package:get/get.dart';
import 'buyer_notification_preferences_controller.dart';

class BuyerNotificationPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerNotificationPreferencesController>(
      () => BuyerNotificationPreferencesController(),
    );
  }
}
