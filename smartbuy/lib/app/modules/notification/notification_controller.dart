import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[].obs;
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    // Mock data - replace with API call
    notifications.value = [
      {
        'id': '1',
        'title': 'Order Shipped',
        'message': 'Your order #12345 has been shipped and is on the way',
        'time': '2 hours ago',
        'isRead': false,
        'type': 'order',
      },
      {
        'id': '2',
        'title': 'Special Offer',
        'message': 'Get 25% off on your next purchase. Use code: SAVE25',
        'time': '5 hours ago',
        'isRead': false,
        'type': 'promo',
      },
      {
        'id': '3',
        'title': 'Payment Confirmed',
        'message': 'Your payment of \$199.00 has been received',
        'time': '1 day ago',
        'isRead': true,
        'type': 'payment',
      },
    ];
    _updateUnreadCount();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    notifications.refresh();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n['isRead'] == false).length;
  }
}
