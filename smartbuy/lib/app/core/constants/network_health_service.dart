import 'package:get/get.dart';

class NetworkHealthService extends GetxService {
  final GetConnect _client = GetConnect();
  final RxBool apiReachable = true.obs;

  Future<void> checkApiHealth() async {
    try {
      final response = await _client
          .get('https://gasalert.sutech.co.tz')
          .timeout(const Duration(seconds: 3));

      apiReachable.value = response.isOk;
    } catch (_) {
      apiReachable.value = false;
    }
  }
}
