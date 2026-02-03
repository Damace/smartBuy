import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final storage = GetStorage();
  final RxBool isDarkMode = false.obs;
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
    loadLocale();
  }

  void loadThemeMode() {
    isDarkMode.value = storage.read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void loadLocale() {
    final String? languageCode = storage.read('languageCode');
    final String? countryCode = storage.read('countryCode');

    if (languageCode != null && countryCode != null) {
      currentLocale.value = Locale(languageCode, countryCode);
      Get.updateLocale(currentLocale.value);
    }
  }

  void changeLanguage(String languageCode, String countryCode) {
    currentLocale.value = Locale(languageCode, countryCode);
    storage.write('languageCode', languageCode);
    storage.write('countryCode', countryCode);
    Get.updateLocale(currentLocale.value);
  }

  void setEnglish() {
    changeLanguage('en', 'US');
  }

  void setSwahili() {
    changeLanguage('sw', 'KE');
  }

  bool get isEnglish => currentLocale.value.languageCode == 'en';
  bool get isSwahili => currentLocale.value.languageCode == 'sw';
}
