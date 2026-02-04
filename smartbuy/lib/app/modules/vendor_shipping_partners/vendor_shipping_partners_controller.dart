import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class ShippingPartner {
  final String id;
  final String name;
  final String deliveryTime;
  final String priceFrom;
  final String logo;
  final bool isPopular;
  final RxBool isEnabled;

  ShippingPartner({
    required this.id,
    required this.name,
    required this.deliveryTime,
    required this.priceFrom,
    required this.logo,
    this.isPopular = false,
    bool enabled = false,
  }) : isEnabled = enabled.obs;
}

class VendorShippingPartnersController extends GetxController {
  final RxString defaultPartner = 'dhl'.obs;

  final RxList<ShippingPartner> partners = <ShippingPartner>[
    ShippingPartner(
      id: 'dhl',
      name: 'DHL Express',
      deliveryTime: '2-3 Business Days',
      priceFrom: 'From \$15.00',
      logo: '📦',
      isPopular: true,
      enabled: true,
    ),
    ShippingPartner(
      id: 'fedex',
      name: 'FedEx Priority',
      deliveryTime: '1-2 Business Days',
      priceFrom: 'From \$24.50',
      logo: '📦',
      enabled: true,
    ),
    ShippingPartner(
      id: 'local_post',
      name: 'Local Standard Post',
      deliveryTime: '5-7 Business Days',
      priceFrom: 'From \$6.20',
      logo: '📦',
      enabled: false,
    ),
    ShippingPartner(
      id: 'ups',
      name: 'UPS Ground',
      deliveryTime: '3-5 Business Days',
      priceFrom: 'From \$11.00',
      logo: '📦',
      enabled: true,
    ),
  ].obs;

  void setDefaultPartner(String? partnerId) {
    if (partnerId != null) {
      defaultPartner.value = partnerId;
    }
  }

  void togglePartner(String partnerId, bool value) {
    final partner = partners.firstWhere((p) => p.id == partnerId);
    partner.isEnabled.value = value;
  }

  void updatePreferences() {
    Helpers.showSuccess('shipping_preferences_updated'.tr);
  }
}
