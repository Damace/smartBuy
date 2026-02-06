import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/helpers.dart';

class BuyerChatInterfaceController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  late Map<String, dynamic> conversationData;

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
    {
      'id': '1',
      'text': 'Hi! Thanks for reaching out. How can I help you with the Wireless Headphones today?',
      'sender': 'support',
      'senderName': 'Sarah',
      'time': 'Today, 10:45 AM',
      'isRead': true,
    },
    {
      'id': '2',
      'text': 'Yes, it comes with a 12-month standard manufacturer warranty that covers all technical issues.',
      'sender': 'support',
      'senderName': 'Sarah',
      'time': '10:46 AM',
      'isRead': true,
    },
    {
      'id': '3',
      'text': 'Hi Sarah, is the warranty included with this purchase?',
      'sender': 'me',
      'time': '10:45 AM',
      'isRead': true,
    },
    {
      'id': '4',
      'text': 'Great! Does it cover liquid damage?',
      'sender': 'me',
      'time': '10:47 AM',
      'isRead': true,
    },
  ].obs;

  final RxList<String> quickReplies = <String>[
    'Where is my order?',
    'Available colors?',
    'Shipping',
  ].obs;

  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      conversationData = Get.arguments as Map<String, dynamic>;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': text.trim(),
      'sender': 'me',
      'time': _getFormattedTime(),
      'isRead': false,
    };

    messages.add(newMessage);
    messageController.clear();

    // Simulate response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateResponse();
    });
  }

  void sendQuickReply(String reply) {
    sendMessage(reply);
  }

  void _simulateResponse() {
    final response = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': 'Thank you for your message. Our team will respond shortly.',
      'sender': 'support',
      'senderName': 'Sarah',
      'time': _getFormattedTime(),
      'isRead': true,
    };

    messages.add(response);
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void callStore() {
    Helpers.showInfo('calling_store'.tr);
  }

  void openMenu() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block),
              title: Text('block_user'.tr),
              onTap: () {
                Get.back();
                Helpers.showInfo('user_blocked'.tr);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: Text('report_conversation'.tr),
              onTap: () {
                Get.back();
                Helpers.showInfo('conversation_reported'.tr);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text('delete_conversation'.tr),
              onTap: () {
                Get.back();
                Helpers.showInfo('conversation_deleted'.tr);
              },
            ),
          ],
        ),
      ),
    );
  }

  void viewItems() {
    Helpers.showInfo('view_items_feature_coming_soon'.tr);
  }

  void attachFile() {
    Helpers.showInfo('attachment_feature_coming_soon'.tr);
  }

  void openEmoji() {
    Helpers.showInfo('emoji_picker_coming_soon'.tr);
  }
}
