import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'vendor_shipping_partners_controller.dart';
import '../../core/themes/app_theme.dart';

class VendorShippingPartnersView extends GetView<VendorShippingPartnersController> {
  const VendorShippingPartnersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('shipping_partners'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Shipping Partner
            _buildDefaultPartnerSection(),
            const SizedBox(height: 24),

            // Available Logistics Partners
            _buildAvailablePartnersSection(),
            const SizedBox(height: 24),

            // Update Preferences Button
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPartnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'default_shipping_partner'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode
                ? AppTheme.darkTextPrimary
                : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'primary_carrier_for_automated_orders'.tr,
          style: TextStyle(
            fontSize: 13,
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
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
                value: controller.defaultPartner.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ),
                dropdownColor: Get.isDarkMode
                    ? AppTheme.darkCardColor
                    : Colors.white,
                items: controller.partners
                    .map((partner) => DropdownMenuItem<String>(
                          value: partner.id,
                          child: Text(partner.name),
                        ))
                    .toList(),
                onChanged: controller.setDefaultPartner,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'this_carrier_will_be_prioritized'.tr,
          style: TextStyle(
            fontSize: 12,
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailablePartnersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'available_logistics_partners'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode
                ? AppTheme.darkTextPrimary
                : AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.partners.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final partner = controller.partners[index];
              return _buildPartnerCard(partner);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPartnerCard(ShippingPartner partner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: Get.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                partner.logo,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Partner Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      partner.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textPrimary,
                      ),
                    ),
                    if (partner.isPopular) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'POPULAR',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  partner.deliveryTime,
                  style: TextStyle(
                    fontSize: 13,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  partner.priceFrom,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Toggle Switch
          Obx(
            () => Switch(
              value: partner.isEnabled.value,
              onChanged: (value) => controller.togglePartner(partner.id, value),
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.updatePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 20),
            const SizedBox(width: 8),
            Text(
              'update_preferences'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
