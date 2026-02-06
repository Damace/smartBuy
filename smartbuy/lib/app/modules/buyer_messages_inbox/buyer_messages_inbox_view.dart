import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/themes/app_theme.dart';
import 'buyer_messages_inbox_controller.dart';

class BuyerMessagesInboxView extends GetView<BuyerMessagesInboxController> {
  const BuyerMessagesInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? AppTheme.darkBackgroundColor
          : AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('messages'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: controller.composeNewMessage,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'search_stores_or_users'.tr,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Row(
                  children: [
                    _buildFilterChip('all', 'all'.tr),
                    const SizedBox(width: 8),
                    _buildFilterChip('orders', 'orders'.tr),
                    const SizedBox(width: 8),
                    _buildFilterChip('support', 'support'.tr),
                  ],
                )),
          ),
          const SizedBox(height: 16),

          // Conversations List
          Expanded(
            child: Obx(() {
              final conversations = controller.filteredConversations;

              if (conversations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: 64,
                        color: Get.isDarkMode
                            ? Colors.grey[600]
                            : Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_messages_found'.tr,
                        style: TextStyle(
                          color: Get.isDarkMode
                              ? AppTheme.darkTextSecondary
                              : AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Get.isDarkMode
                      ? AppTheme.darkBorderColor
                      : AppTheme.dividerColor,
                ),
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return _buildConversationItem(conversation);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, String label) {
    final isSelected = controller.selectedFilter.value == filter;
    return GestureDetector(
      onTap: () => controller.selectFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : (Get.isDarkMode ? AppTheme.darkCardColor : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (Get.isDarkMode ? Colors.white : Colors.black),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    final isUnread = conversation['isUnread'] == true;

    return InkWell(
      onTap: () => controller.openConversation(conversation),
      child: Container(
        color: Get.isDarkMode ? AppTheme.darkBackgroundColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(conversation),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name
                      Expanded(
                        child: Text(
                          conversation['name'],
                          style: TextStyle(
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Time
                      Text(
                        conversation['time'],
                        style: TextStyle(
                          color: isUnread
                              ? AppTheme.primaryColor
                              : (Get.isDarkMode
                                  ? AppTheme.darkTextSecondary
                                  : AppTheme.textSecondary),
                          fontSize: 12,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Message Preview
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation['message'],
                          style: TextStyle(
                            color: Get.isDarkMode
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> conversation) {
    final avatar = conversation['avatar'];
    final colorHex = conversation['avatarColor'];
    final Color avatarColor = Color(int.parse(colorHex));

    // If avatar is a path to an image
    if (avatar.toString().contains('assets/') ||
        avatar.toString().contains('.png') ||
        avatar.toString().contains('.jpg')) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: avatarColor,
        child: Icon(
          conversation['type'] == 'support'
              ? Icons.support_agent
              : Icons.person,
          color: Colors.white,
        ),
      );
    }

    // Otherwise, it's a letter/initial
    return CircleAvatar(
      radius: 24,
      backgroundColor: avatarColor,
      child: Text(
        avatar,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
