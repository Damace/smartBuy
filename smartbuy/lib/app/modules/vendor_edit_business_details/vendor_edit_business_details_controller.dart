import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class VendorEditBusinessDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final TextEditingController legalNameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController officeAddressController = TextEditingController();

  final RxString selectedBusinessType = 'Limited Liability Company (LLC)'.obs;
  final RxString uploadedFileName = ''.obs;
  final RxBool isUploading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isLoading = false.obs;

  final List<String> businessTypes = [
    'Limited Liability Company (LLC)',
    'Sole Proprietorship',
    'Partnership',
    'Corporation',
    'Non-Profit Organization',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCurrentDetails();
  }

  Future<void> _loadCurrentDetails() async {
    isLoading.value = true;
    try {
      final response =
          await _apiProvider.get(ApiConstants.vendorBusinessDetails);
      final vendor = response.data['vendor'];

      if (vendor != null) {
        legalNameController.text = vendor['business_name'] ?? '';
        registrationNumberController.text =
            vendor['business_registration_number'] ?? '';
        officeAddressController.text = vendor['business_address'] ?? '';

        final taxId = vendor['tax_id'] ?? '';
        if (businessTypes.contains(taxId)) {
          selectedBusinessType.value = taxId;
        }

        if (vendor['business_proof_document'] != null) {
          uploadedFileName.value =
              vendor['business_proof_document'].toString().split('/').last;
        }
      }
    } catch (e) {
      // Fall back to mock data
      legalNameController.text = 'SmartBuy Solutions Ltd.';
      registrationNumberController.text = 'REG-88829-001';
      officeAddressController.text =
          '123 Tech Avenue, Silicon Valley, CA 94025, United States';
    } finally {
      isLoading.value = false;
    }
  }

  void setBusinessType(String? type) {
    if (type != null) {
      selectedBusinessType.value = type;
    }
  }

  void uploadCertificate() {
    // Simulate file upload
    isUploading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      uploadedFileName.value = 'current_certificate_2023.pdf';
      isUploading.value = false;
      Helpers.showSuccess('certificate_uploaded_successfully'.tr);
    });
  }

  void removeCertificate() {
    uploadedFileName.value = '';
    Helpers.showInfo('certificate_removed'.tr);
  }

  Future<void> saveChanges() async {
    // Validate fields
    if (legalNameController.text.isEmpty) {
      Helpers.showError('legal_name_required'.tr);
      return;
    }
    if (registrationNumberController.text.isEmpty) {
      Helpers.showError('registration_number_required'.tr);
      return;
    }
    if (officeAddressController.text.isEmpty) {
      Helpers.showError('office_address_required'.tr);
      return;
    }

    isSaving.value = true;
    try {
      await _apiProvider.put(
        ApiConstants.vendorBusinessDetails,
        data: {
          'business_name': legalNameController.text.trim(),
          'business_registration_number':
              registrationNumberController.text.trim(),
          'business_address': officeAddressController.text.trim(),
          'tax_id': selectedBusinessType.value,
        },
      );
      Helpers.showSuccess('business_details_updated_successfully'.tr);
      Get.back();
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    legalNameController.dispose();
    registrationNumberController.dispose();
    officeAddressController.dispose();
    super.onClose();
  }
}
