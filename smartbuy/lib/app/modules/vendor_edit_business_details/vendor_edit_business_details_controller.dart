import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class VendorEditBusinessDetailsController extends GetxController {
  final TextEditingController legalNameController = TextEditingController(
    text: 'SmartBuy Solutions Ltd.',
  );
  final TextEditingController registrationNumberController =
      TextEditingController(
    text: 'REG-88829-001',
  );
  final TextEditingController officeAddressController = TextEditingController(
    text: '123 Tech Avenue, Silicon Valley, CA 94025, United States',
  );

  final RxString selectedBusinessType = 'Limited Liability Company (LLC)'.obs;
  final RxString uploadedFileName = ''.obs;
  final RxBool isUploading = false.obs;

  final List<String> businessTypes = [
    'Limited Liability Company (LLC)',
    'Sole Proprietorship',
    'Partnership',
    'Corporation',
    'Non-Profit Organization',
  ];

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

  void saveChanges() {
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

    // Save changes
    Helpers.showSuccess('business_details_updated_successfully'.tr);
    Get.back();
  }

  @override
  void onClose() {
    legalNameController.dispose();
    registrationNumberController.dispose();
    officeAddressController.dispose();
    super.onClose();
  }
}
