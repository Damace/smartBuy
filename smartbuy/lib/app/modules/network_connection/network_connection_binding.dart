import 'package:get/get.dart';
import 'network_connection_controller.dart';

class NetworkConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkConnectionController>(
      () => NetworkConnectionController(),
    );
  }
}
