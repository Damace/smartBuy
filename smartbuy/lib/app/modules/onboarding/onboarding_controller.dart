import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_pages.dart';
import '../../core/constants/app_constants.dart';

class OnboardingController extends GetxController {
  final storage = GetStorage();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'onboarding_title_1'.tr,
      description: 'onboarding_desc_1'.tr,
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingModel(
      title: 'onboarding_title_2'.tr,
      description: 'onboarding_desc_2'.tr,
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingModel(
      title: 'onboarding_title_3'.tr,
      description: 'onboarding_desc_3'.tr,
      image: 'assets/images/onboarding3.png',
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    completeOnboarding();
  }

  void completeOnboarding() {
    storage.write(AppConstants.storageKeyIsFirstTime, false);
    Get.offNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
