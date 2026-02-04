import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/helpers.dart';

class BuyerNotificationPreferencesController extends GetxController {
  final storage = GetStorage();

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
    loadPreferences();
  }

  void loadPreferences() {
    // Load saved preferences
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

  void saveAllChanges() {
    // Save all preferences
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

    Helpers.showSuccess('notification_preferences_saved'.tr);
  }
}
