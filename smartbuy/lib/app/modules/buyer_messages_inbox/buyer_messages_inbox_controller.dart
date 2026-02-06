import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class BuyerMessagesInboxController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'all'.obs;

  final RxList<Map<String, dynamic>> conversations = <Map<String, dynamic>>[
    {
      'id': '1',
      'type': 'store',
      'name': 'TechZone Store',
      'avatar': 'T',
      'message': 'Your order #48-8021 has been shipped and is on its way!',
      'time': '5m ago',
      'isUnread': true,
      'category': 'orders',
      'avatarColor': '0xFF2D7A7A',
    },
    {
      'id': '2',
      'type': 'user',
      'name': 'John Doe',
      'avatar': 'assets/images/user.png',
      'message': 'Hi there! How\'s the monitor working? I\'m interested in...',
      'time': '1h ago',
      'isUnread': false,
      'category': 'all',
      'avatarColor': '0xFF6B8E23',
    },
    {
      'id': '3',
      'type': 'store',
      'name': 'Aura Fashion',
      'avatar': 'A',
      'message': 'We\'ve restocked the silk scarf you liked! Check it out.',
      'time': '2h ago',
      'isUnread': true,
      'category': 'all',
      'avatarColor': '0xFFE8A87C',
    },
    {
      'id': '4',
      'type': 'store',
      'name': 'Urban Living',
      'avatar': 'U',
      'message': 'Thank you for your feedback on the coffee table.',
      'time': 'Yesterday',
      'isUnread': false,
      'category': 'all',
      'avatarColor': '0xFF808080',
    },
    {
      'id': '5',
      'type': 'support',
      'name': 'Sarah (Support)',
      'avatar': 'assets/images/support.png',
      'message': 'Your issue has been resolved. Feel free to reach out...',
      'time': 'Mon',
      'isUnread': false,
      'category': 'support',
      'avatarColor': '0xFF9370DB',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<Map<String, dynamic>> get filteredConversations {
    var filtered = conversations.where((conversation) {
      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final name = conversation['name'].toString().toLowerCase();
        final message = conversation['message'].toString().toLowerCase();
        if (!name.contains(query) && !message.contains(query)) {
          return false;
        }
      }

      // Apply category filter
      if (selectedFilter.value == 'all') {
        return true;
      } else if (selectedFilter.value == 'orders') {
        return conversation['category'] == 'orders';
      } else if (selectedFilter.value == 'support') {
        return conversation['category'] == 'support';
      }

      return true;
    }).toList();

    return filtered;
  }

  void openConversation(Map<String, dynamic> conversation) {
    Get.toNamed(Routes.BUYER_CHAT_INTERFACE, arguments: conversation);
  }

  void composeNewMessage() {
    // Navigate to new message screen or show dialog
    Get.snackbar(
      'compose_new_message'.tr,
      'feature_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
