import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class VendorBusinessDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Loading state
  final RxBool isLoading = false.obs;

  // Business information
  final RxBool isKycVerified = false.obs;
  final RxString legalBusinessName = ''.obs;
  final RxString registrationNumber = ''.obs;
  final RxString businessType = ''.obs;
  final RxString officeAddress = ''.obs;
  final RxString verificationStatus = ''.obs;
  final RxString businessEmail = ''.obs;
  final RxString businessPhone = ''.obs;
  final RxString contactPersonName = ''.obs;
  final RxString taxId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBusinessDetails();
  }

  Future<void> fetchBusinessDetails() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorBusinessDetails);
      final vendor = response.data['vendor'];

      if (vendor != null) {
        legalBusinessName.value = vendor['business_name'] ?? '';
        registrationNumber.value = vendor['business_registration_number'] ?? '';
        businessType.value = vendor['tax_id'] ?? '';
        officeAddress.value = vendor['business_address'] ?? '';
        businessEmail.value = vendor['business_email'] ?? '';
        businessPhone.value = vendor['business_phone'] ?? '';
        contactPersonName.value = vendor['contact_person_name'] ?? '';
        taxId.value = vendor['tax_id'] ?? '';
        verificationStatus.value = vendor['verification_status'] ?? 'unverified';
        isKycVerified.value = vendor['verification_status'] == 'verified';
      }
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    legalBusinessName.value = 'Smart Buy Retail Solutions Ltd.';
    registrationNumber.value = 'BRN-987654321-2023';
    businessType.value = 'Limited Liability Company (LLC)';
    officeAddress.value =
        '102 Business Plaza, Market District\nSan Francisco, CA 94105\nUnited States';
    isKycVerified.value = true;
    verificationStatus.value = 'verified';
  }

  void editDetails() {
    Get.toNamed(Routes.VENDOR_EDIT_BUSINESS_DETAILS)?.then((_) {
      // Refresh data when returning from edit screen
      fetchBusinessDetails();
    });
  }

  void viewCertificate() {
    Helpers.showSuccess('viewing_certificate'.tr);
  }
}
