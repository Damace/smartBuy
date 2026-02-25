import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/themes/app_theme.dart';
import 'app/core/constants/app_constants.dart';
import 'app/core/translations/app_translations.dart';
import 'app/core/utils/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // Preserve native splash until Flutter is ready to draw
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Only storage init is required before runApp (ThemeController reads from it)
  await GetStorage.init();

  Get.put(ThemeController());

  // Start the app immediately to minimize native white-screen time
  runApp(const SmartBuyApp());

  // Non-visual setup deferred after first frame
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class SmartBuyApp extends StatelessWidget {
  const SmartBuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: themeController.currentLocale.value,
        fallbackLocale: const Locale('en', 'US'),
        translations: AppTranslations(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        defaultTransition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}
