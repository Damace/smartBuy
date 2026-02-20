import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';

class BuyerNotificationPreferencesController extends GetxController {
  final storage = GetStorage();
  final ApiProvider _apiProvider = ApiProvider();

  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  // Order Status Updates
  final RxBool orderStatusPush = true.obs;
  final RxBool orderStatusEmail = true.obs;
  final RxBool orderStatusSms = false.obs;

  // Promotional Offers
  final RxBool promotionalPush = true.obs;
  final RxBool promotionalEmail = false.obs;

  // Payment Alerts
  final RxBool paymentPush = true.obs;

  // Wallet Balance Alerts
  final RxBool walletPush = true.obs;
  final RxBool walletSms = true.obs;

  // Messages
  final RxBool messagesPush = true.obs;
  final RxBool messagesEmail = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPreferences();
  }

  Future<void> fetchPreferences() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(
        ApiConstants.buyerNotificationPreferences,
      );
      final prefs = response.data['preferences'];
      if (prefs != null) {
        orderStatusPush.value = prefs['order_status_push'] ?? true;
        orderStatusEmail.value = prefs['order_status_email'] ?? true;
        orderStatusSms.value = prefs['order_status_sms'] ?? false;
        promotionalPush.value = prefs['promotional_push'] ?? true;
        promotionalEmail.value = prefs['promotional_email'] ?? false;
        paymentPush.value = prefs['payment_push'] ?? true;
        walletPush.value = prefs['wallet_push'] ?? true;
        walletSms.value = prefs['wallet_sms'] ?? true;
        messagesPush.value = prefs['messages_push'] ?? true;
        messagesEmail.value = prefs['messages_email'] ?? false;
      }
    } catch (_) {
      // Load from local storage as fallback
      _loadFromLocalStorage();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadFromLocalStorage() {
    orderStatusPush.value = storage.read('orderStatusPush') ?? true;
    orderStatusEmail.value = storage.read('orderStatusEmail') ?? true;
    orderStatusSms.value = storage.read('orderStatusSms') ?? false;
    promotionalPush.value = storage.read('promotionalPush') ?? true;
    promotionalEmail.value = storage.read('promotionalEmail') ?? false;
    paymentPush.value = storage.read('paymentPush') ?? true;
    walletPush.value = storage.read('walletPush') ?? true;
    walletSms.value = storage.read('walletSms') ?? true;
    messagesPush.value = storage.read('messagesPush') ?? true;
    messagesEmail.value = storage.read('messagesEmail') ?? false;
  }

  Future<void> saveAllChanges() async {
    if (isSaving.value) return;
    isSaving.value = true;

    final prefsData = {
      'order_status_push': orderStatusPush.value,
      'order_status_email': orderStatusEmail.value,
      'order_status_sms': orderStatusSms.value,
      'promotional_push': promotionalPush.value,
      'promotional_email': promotionalEmail.value,
      'payment_push': paymentPush.value,
      'wallet_push': walletPush.value,
      'wallet_sms': walletSms.value,
      'messages_push': messagesPush.value,
      'messages_email': messagesEmail.value,
    };

    try {
      await _apiProvider.put(
        ApiConstants.buyerNotificationPreferences,
        data: prefsData,
      );

      // Also save locally
      _saveToLocalStorage();

      Helpers.showSuccess('notification_preferences_saved'.tr);
    } catch (e) {
      // Save locally as fallback
      _saveToLocalStorage();
      Helpers.showSuccess('notification_preferences_saved'.tr);
    } finally {
      isSaving.value = false;
    }
  }

  void _saveToLocalStorage() {
    storage.write('orderStatusPush', orderStatusPush.value);
    storage.write('orderStatusEmail', orderStatusEmail.value);
    storage.write('orderStatusSms', orderStatusSms.value);
    storage.write('promotionalPush', promotionalPush.value);
    storage.write('promotionalEmail', promotionalEmail.value);
    storage.write('paymentPush', paymentPush.value);
    storage.write('walletPush', walletPush.value);
    storage.write('walletSms', walletSms.value);
    storage.write('messagesPush', messagesPush.value);
    storage.write('messagesEmail', messagesEmail.value);
  }
}
