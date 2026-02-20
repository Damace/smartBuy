import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/providers/api_provider.dart';
import '../../routes/app_pages.dart';

class VendorBankAccountDetailsController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();

  // Loading state
  final RxBool isLoading = false.obs;

  // Bank account information
  final RxBool isVerified = false.obs;
  final RxBool hasBankAccount = false.obs;
  final RxString accountHolderName = ''.obs;
  final RxString bankName = ''.obs;
  final RxString accountNumber = ''.obs;
  final RxString swiftCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBankAccountDetails();
  }

  Future<void> fetchBankAccountDetails() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.vendorBankAccount);
      final bankAccount = response.data['bank_account'];

      if (bankAccount != null) {
        accountHolderName.value = bankAccount['contact_person_name'] ?? '';
        bankName.value = bankAccount['bank_name'] ?? '';
        accountNumber.value = _maskAccountNumber(
          bankAccount['bank_account_number'] ?? '',
        );
        swiftCode.value = bankAccount['bank_routing_number'] ?? '';
        hasBankAccount.value = bankAccount['has_bank_account'] ?? false;
        isVerified.value = hasBankAccount.value;
      }
    } catch (e) {
      _loadMockData();
      Helpers.showError(Helpers.parseErrorMessage(e));
    } finally {
      isLoading.value = false;
    }
  }

  String _maskAccountNumber(String number) {
    if (number.length <= 4) return number;
    final visible = number.substring(number.length - 4);
    return '**** **** $visible';
  }

  void _loadMockData() {
    accountHolderName.value = 'John Doe';
    bankName.value = 'Global Tech Bank';
    accountNumber.value = '**** **** 5678';
    swiftCode.value = 'GTB0001234';
    isVerified.value = true;
    hasBankAccount.value = true;
  }

  void changeBankAccount() {
    Get.toNamed(Routes.VENDOR_EDIT_BANK_ACCOUNT_DETAILS)?.then((_) {
      fetchBankAccountDetails();
    });
  }

  String getAccountNumberMasked() {
    return accountNumber.value;
  }
}
