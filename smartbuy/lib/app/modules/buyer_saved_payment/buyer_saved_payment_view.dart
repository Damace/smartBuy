import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'buyer_saved_payment_controller.dart';

class BuyerSavedPaymentView extends GetView<BuyerSavedPaymentController> {
  const BuyerSavedPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('saved_payment_methods'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchPaymentMethods,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Saved Cards Section
                    _buildSectionHeader(
                        'saved_cards'.tr, () => controller.addNewCard()),
                    const SizedBox(height: 12),
                    ...controller.savedCards
                        .map((card) => _buildCardItem(card)),
                    if (controller.savedCards.isEmpty)
                      _buildEmptyHint('no_saved_cards'.tr),
                    const SizedBox(height: 24),

                    // Mobile Money Section
                    _buildSectionHeader('mobile_money_tanzania'.tr, null),
                    const SizedBox(height: 12),
                    ...controller.mobileMoney
                        .map((money) => _buildMobileMoneyItem(money)),
                    const SizedBox(height: 24),

                    // UPI IDs Section
                    _buildSectionHeader(
                        'upi_ids'.tr, () => controller.addNewUpiId()),
                    const SizedBox(height: 12),
                    ...controller.upiIds
                        .map((upi) => _buildUpiItem(upi)),
                    if (controller.upiIds.isEmpty)
                      _buildEmptyHint('no_upi_ids'.tr),
                    const SizedBox(height: 24),

                    // Linked Wallets Section
                    _buildSectionHeader('linked_wallets'.tr,
                        () => controller.showLinkWalletDialog()),
                    const SizedBox(height: 12),
                    ...controller.linkedWallets
                        .map((wallet) => _buildWalletItem(wallet)),
                  ],
                ),
              ),
            ),
            // Add New Payment Method Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.addNewPaymentMethod,
                  icon: const Icon(Icons.add_card, size: 20),
                  label: Text('add_new_payment_method'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyHint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Get.isDarkMode ? Colors.grey[500] : Colors.grey[400],
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onAddPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Get.isDarkMode
                ? AppTheme.darkTextSecondary
                : AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        if (onAddPressed != null)
          TextButton.icon(
            onPressed: onAddPressed,
            icon: const Icon(Icons.add, size: 16),
            label: Text('add_new'.tr),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
      ],
    );
  }

  Widget _buildCardItem(Map<String, dynamic> card) {
    final int? cardId = card['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppTheme.darkBorderColor
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 32,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.credit_card,
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '**** **** **** ${card['lastFourDigits']}',
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (card['isPrimary'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'primary'.tr.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${'expires'.tr} ${card['expiryDate']}',
                  style: TextStyle(
                    color: Get.isDarkMode
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (cardId != null)
            Obx(() {
              final isRemoving = controller.removingIds.contains(cardId);
              return isRemoving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.chevron_right),
                      color: Get.isDarkMode
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                      onPressed: () => controller.editCard(card),
                    );
            }),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyItem(Map<String, dynamic> money) {
    final bool isConnected = money['isConnected'] == true;
    final String name = money['name'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppTheme.darkBorderColor
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone_android,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isConnected ? 'connected'.tr : 'not_linked'.tr,
                  style: TextStyle(
                    color: isConnected
                        ? AppTheme.successColor
                        : (Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isConnected)
            Obx(() {
              final isConnecting =
                  controller.connectingNames.contains(name);
              return isConnecting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => controller.linkMobileMoney(money),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'link'.tr.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
            })
          else
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
              onPressed: () => controller.linkMobileMoney(money),
            ),
        ],
      ),
    );
  }

  Widget _buildUpiItem(Map<String, dynamic> upi) {
    final int? upiItemId = upi['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppTheme.darkBorderColor
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  upi['upiId'] ?? '',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'verified'.tr,
                  style: const TextStyle(
                    color: AppTheme.successColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (upiItemId != null)
            Obx(() {
              final isRemoving =
                  controller.removingIds.contains(upiItemId);
              return PopupMenuButton<String>(
                icon: isRemoving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.more_vert,
                        color: Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                      ),
                enabled: !isRemoving,
                onSelected: (value) {
                  if (value == 'remove') {
                    controller.removePaymentMethod(upiItemId);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline,
                            color: AppTheme.errorColor, size: 18),
                        const SizedBox(width: 8),
                        Text('remove'.tr),
                      ],
                    ),
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildWalletItem(Map<String, dynamic> wallet) {
    final bool isLinked = wallet['isLinked'] == true;
    final String name = wallet['name'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.isDarkMode
              ? AppTheme.darkBorderColor
              : AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              wallet['icon'] == 'apple' ? Icons.apple : Icons.payment,
              color: Get.isDarkMode ? Colors.white : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLinked ? 'linked'.tr : 'not_connected'.tr,
                  style: TextStyle(
                    color: isLinked
                        ? AppTheme.successColor
                        : (Get.isDarkMode
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isLinked)
            Obx(() {
              final isConnecting =
                  controller.connectingNames.contains(name);
              return isConnecting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : GestureDetector(
                      onTap: () => controller.linkWallet(wallet),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'connect'.tr.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
            })
          else
            IconButton(
              icon: const Icon(Icons.chevron_right),
              color: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
              onPressed: () => controller.linkWallet(wallet),
            ),
        ],
      ),
    );
  }
}
