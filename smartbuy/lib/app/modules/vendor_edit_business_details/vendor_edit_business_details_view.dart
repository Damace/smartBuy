import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_edit_business_details_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorEditBusinessDetailsView extends GetView<VendorEditBusinessDetailsController> {
  const VendorEditBusinessDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('edit_business_details'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Information Header
            Text(
              'general_information'.tr.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextSecondary
                    : AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            // Legal Business Name
            _buildTextField(
              label: 'legal_business_name'.tr,
              controller: controller.legalNameController,
            ),
            const SizedBox(height: 16),

            // Business Registration Number
            _buildTextField(
              label: 'business_registration_number'.tr,
              controller: controller.registrationNumberController,
            ),
            const SizedBox(height: 16),

            // Business Type Dropdown
            Text(
              'business_type'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedBusinessType.value,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: TextStyle(
                      fontSize: 14,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                    dropdownColor: Get.isDarkMode
                        ? AppTheme.darkCardColor
                        : Colors.white,
                    items: controller.businessTypes
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: controller.setBusinessType,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Registered Office Address
            Text(
              'registered_office_address'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.officeAddressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'enter_office_address'.tr,
                hintStyle: TextStyle(
                  color: Get.isDarkMode
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary,
                ),
                filled: true,
                fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Upload Updated Business Certificate
            Text(
              'upload_updated_business_certificate'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppTheme.darkTextPrimary
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildUploadArea(),
            const SizedBox(height: 24),

            // Save Changes Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? AppTheme.darkTextPrimary
                : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Get.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.isDarkMode
                ? Colors.grey.shade700
                : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: controller.uploadedFileName.value.isEmpty
            ? Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'click_to_upload_or_drag_and_drop'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'pdf_png_or_jpeg_max_10mb'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (controller.isUploading.value)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: controller.uploadCertificate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('browse_files'.tr),
                    ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.uploadedFileName.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2 MB • Uploaded Jan 10',
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: controller.removeCertificate,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'save_changes'.tr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
