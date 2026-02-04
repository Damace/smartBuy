import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'buyer_edit_address_controller.dart';

class BuyerEditAddressView extends GetView<BuyerEditAddressController> {
  const BuyerEditAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('edit_shipping_address'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.isEditMode.value
              ? IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppTheme.errorColor),
                  onPressed: controller.deleteAddress,
                )
              : const SizedBox()),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Full Name
            Text(
              'full_name'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.fullNameController,
              validator: (value) =>
                  controller.validateRequired(value, 'full_name'.tr),
              decoration: InputDecoration(
                hintText: 'Alex Johnson',
                filled: true,
                fillColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
              ),
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Mobile Number
            Text(
              'mobile_number'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.mobileNumberController,
              validator: controller.validateMobileNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+1 5550123456',
                prefixText: '+1 ',
                filled: true,
                fillColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
              ),
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Pincode and City
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'pincode'.tr,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.pincodeController,
                        validator: controller.validatePincode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '10001',
                          filled: true,
                          fillColor: Get.isDarkMode
                              ? AppTheme.darkCardColor
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Get.isDarkMode
                                  ? AppTheme.darkBorderColor
                                  : AppTheme.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Get.isDarkMode
                                  ? AppTheme.darkBorderColor
                                  : AppTheme.borderColor,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'city'.tr,
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.cityController,
                        validator: (value) =>
                            controller.validateRequired(value, 'city'.tr),
                        decoration: InputDecoration(
                          hintText: 'New York',
                          filled: true,
                          fillColor: Get.isDarkMode
                              ? AppTheme.darkCardColor
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Get.isDarkMode
                                  ? AppTheme.darkBorderColor
                                  : AppTheme.borderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Get.isDarkMode
                                  ? AppTheme.darkBorderColor
                                  : AppTheme.borderColor,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // House No., Building Name
            Text(
              'house_no_building_name'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.houseNumberController,
              validator: (value) => controller.validateRequired(
                  value, 'house_no_building_name'.tr),
              decoration: InputDecoration(
                hintText: 'Apt 4B, Central Heights',
                filled: true,
                fillColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
              ),
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Area, Colony, Road Name
            Text(
              'area_colony_road_name'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.areaController,
              validator: (value) =>
                  controller.validateRequired(value, 'area_colony_road_name'.tr),
              decoration: InputDecoration(
                hintText: '5th Avenue, Manhattan',
                filled: true,
                fillColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Get.isDarkMode
                        ? AppTheme.darkBorderColor
                        : AppTheme.borderColor,
                  ),
                ),
              ),
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // State
            Text(
              'state'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedState.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedState.value = value;
                    }
                  },
                  items: controller.states
                      .map((state) => DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Get.isDarkMode
                            ? AppTheme.darkBorderColor
                            : AppTheme.borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Get.isDarkMode
                            ? AppTheme.darkBorderColor
                            : AppTheme.borderColor,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  dropdownColor:
                      Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                )),
            const SizedBox(height: 16),

            // Address Type
            Text(
              'address_type'.tr,
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Row(
                  children: [
                    _buildAddressTypeButton('home', Icons.home),
                    const SizedBox(width: 12),
                    _buildAddressTypeButton('work', Icons.work),
                    const SizedBox(width: 12),
                    _buildAddressTypeButton('other', Icons.location_on),
                  ],
                )),
            const SizedBox(height: 32),

            // Update Address Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.updateAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('update_address'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeButton(String type, IconData icon) {
    final isSelected = controller.selectedAddressType.value == type;
    return Expanded(
      child: InkWell(
        onTap: () => controller.selectAddressType(type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : (Get.isDarkMode ? AppTheme.darkCardColor : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryColor
                  : (Get.isDarkMode
                      ? AppTheme.darkBorderColor
                      : AppTheme.borderColor),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryColor
                    : (Get.isDarkMode ? Colors.grey : Colors.grey[600]),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                type.tr.capitalizeFirst!,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : (Get.isDarkMode ? Colors.white : Colors.black),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
