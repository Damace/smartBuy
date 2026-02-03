import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class VendorStatusController extends GetxController {
  final RxString applicationStatus = 'under_review'.obs;
  final RxList<ProgressStep> progressSteps = <ProgressStep>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProgressSteps();
  }

  void _initializeProgressSteps() {
    progressSteps.value = [
      ProgressStep(
        title: 'account_created'.tr,
        description: 'account_created_desc'.tr,
        status: StepStatus.completed,
      ),
      ProgressStep(
        title: 'verification_in_progress'.tr,
        description: 'verification_in_progress_desc'.tr,
        status: StepStatus.inProgress,
      ),
      ProgressStep(
        title: 'store_launch'.tr,
        description: 'store_launch_desc'.tr,
        status: StepStatus.pending,
      ),
    ];
  }

  void contactSupport() {
    // Navigate to support or show contact options
    Get.snackbar(
      'Contact Support',
      'Opening support channel...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void backToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}

class ProgressStep {
  final String title;
  final String description;
  final StepStatus status;

  ProgressStep({
    required this.title,
    required this.description,
    required this.status,
  });
}

enum StepStatus {
  completed,
  inProgress,
  pending,
}
