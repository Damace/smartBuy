import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class ShippingPartner {
  final String id;
  final String name;
  final String code;
  final String deliveryTime;
  final String priceFrom;
  final String logo;
  final bool isPopular;
  final RxBool isEnabled;

  ShippingPartner({
    required this.id,
    required this.name,
    this.code = '',
    required this.deliveryTime,
    required this.priceFrom,
    required this.logo,
    this.isPopular = false,
    bool enabled = false,
  }) : isEnabled = enabled.obs;
}

class VendorShippingPartnersController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  final RxString defaultPartner = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  final RxList<ShippingPartner> partners = <ShippingPartner>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchShippingPartners();
  }

  Future<void> fetchShippingPartners() async {
    isLoading.value = true;
    try {
      final response =
          await _apiProvider.get(ApiConstants.vendorShippingPartners);
      final data = response.data;
      final partnersList = data['partners'] as List? ?? [];
      final defaultId = data['default_partner_id'];

      if (defaultId != null) {
        defaultPartner.value = defaultId.toString();
      }

      partners.value = partnersList.map((p) {
        final baseRate = p['base_rate'] ?? 0;
        return ShippingPartner(
          id: p['id'].toString(),
          name: p['name'] ?? '',
          code: p['code'] ?? '',
          deliveryTime: '2-5 Business Days',
          priceFrom: 'From \$$baseRate',
          logo: '📦',
          isPopular: p['code'] == 'dhl',
          enabled: p['is_enabled'] ?? false,
        );
      }).toList();

      if (defaultPartner.value.isEmpty && partners.isNotEmpty) {
        defaultPartner.value = partners.first.id;
      }
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockData() {
    partners.value = [
      ShippingPartner(
        id: '1',
        name: 'DHL Express',
        deliveryTime: '2-3 Business Days',
        priceFrom: 'From \$15.00',
        logo: '📦',
        isPopular: true,
        enabled: true,
      ),
      ShippingPartner(
        id: '2',
        name: 'FedEx Priority',
        deliveryTime: '1-2 Business Days',
        priceFrom: 'From \$24.50',
        logo: '📦',
        enabled: true,
      ),
      ShippingPartner(
        id: '3',
        name: 'Local Standard Post',
        deliveryTime: '5-7 Business Days',
        priceFrom: 'From \$6.20',
        logo: '📦',
        enabled: false,
      ),
      ShippingPartner(
        id: '4',
        name: 'UPS Ground',
        deliveryTime: '3-5 Business Days',
        priceFrom: 'From \$11.00',
        logo: '📦',
        enabled: true,
      ),
    ];
    defaultPartner.value = '1';
  }

  void setDefaultPartner(String? partnerId) {
    if (partnerId != null) {
      defaultPartner.value = partnerId;
    }
  }

  void togglePartner(String partnerId, bool value) {
    final partner = partners.firstWhere((p) => p.id == partnerId);
    partner.isEnabled.value = value;
  }

  Future<void> updatePreferences() async {
    isSaving.value = true;
    try {
      final partnerData = partners.map((p) {
        return {
          'id': int.tryParse(p.id) ?? p.id,
          'is_enabled': p.isEnabled.value,
        };
      }).toList();

      await _apiProvider.put(
        ApiConstants.vendorShippingPartners,
        data: {
          'partners': partnerData,
          'default_partner_id':
              int.tryParse(defaultPartner.value) ?? defaultPartner.value,
        },
      );
      Helpers.showSuccess('shipping_preferences_updated'.tr);
    } catch (e) {
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isSaving.value = false;
    }
  }
}
