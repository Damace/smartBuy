import 'package:get/get.dart';
import 'en_us.dart';
import 'sw_ke.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'sw_KE': swKE,
      };
}
