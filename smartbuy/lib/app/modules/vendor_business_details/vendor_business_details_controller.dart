import 'package:get/get.dart';
import '../../core/utils/helpers.dart';
import '../../routes/app_pages.dart';

class VendorBusinessDetailsController extends GetxController {
  // Business information
  final RxBool isKycVerified = true.obs;
  final RxString legalBusinessName = 'Smart Buy Retail Solutions Ltd.'.obs;
  final RxString registrationNumber = 'BRN-987654321-2023'.obs;
  final RxString businessType = 'Limited Liability Company (LLC)'.obs;
  final RxString officeAddress = '102 Business Plaza, Market District\nSan Francisco, CA 94105\nUnited States'.obs;

  void editDetails() {
    Get.toNamed(Routes.VENDOR_EDIT_BUSINESS_DETAILS);
  }

  void viewCertificate() {
    Helpers.showSuccess('viewing_certificate'.tr);
  }
}
