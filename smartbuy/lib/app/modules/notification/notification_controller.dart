import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/api_constants.dart';
import '../../data/providers/api_provider.dart';

class NotificationController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final response = await _apiProvider.get(ApiConstants.notifications);
      final data = response.data['data'] ?? response.data;
      
      if (data is List) {
        notifications.assignAll(data.map((n) => <String, dynamic>{
          'id': n['id'].toString(),
          'title': n['title'] ?? '',
          'message': n['message'] ?? n['body'] ?? '',
          'time': n['created_at_human'] ?? n['time'] ?? '',
          'isRead': n['read_at'] != null || n['is_read'] == true,
          'type': n['type'] ?? 'info',
        }).toList());
      }
      _updateUnreadCount();
    } catch (e) {
      debugPrint("Error loading notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1 && notifications[index]['isRead'] == false) {
      try {
        await _apiProvider.post(
          ApiConstants.markNotificationRead.replaceAll('{id}', notificationId),
        );
        notifications[index]['isRead'] = true;
        notifications.refresh();
        _updateUnreadCount();
      } catch (e) {
        debugPrint("Error marking notification as read: $e");
      }
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0) return;
    
    try {
      await _apiProvider.post(ApiConstants.markAllNotificationsRead);
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
      notifications.refresh();
      _updateUnreadCount();
    } catch (e) {
      debugPrint("Error marking all notifications as read: $e");
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n['isRead'] == false).length;
  }
}
