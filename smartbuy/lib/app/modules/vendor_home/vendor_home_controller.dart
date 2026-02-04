import 'package:get/get.dart';

class VendorHomeController extends GetxController {
  // User Info
  final RxString vendorName = 'Alex Rivera'.obs;

  // Earnings
  final RxDouble totalEarnings = 12450.00.obs;
  final RxDouble earningsGrowth = 6.4.obs;

  // Statistics
  final RxInt pendingOrders = 8.obs;
  final RxInt performanceScore = 98.obs;

  // Sales Trend
  final RxString salesTrendPeriod = '7 Days'.obs;
  final RxDouble salesTrendAmount = 3200.0.obs;
  final RxDouble salesTrendGrowth = 12.0.obs;

  // Chart Data (7 days)
  final RxList<double> chartData = [2800.0, 3100.0, 2900.0, 3400.0, 3000.0, 3800.0, 3200.0].obs;

  // Recent Orders
  final RxList<Map<String, dynamic>> recentOrders = <Map<String, dynamic>>[
    {
      'id': '#GB-8994',
      'productName': 'Premium Headphones',
      'customer': 'Sarah Miller',
      'price': 299.00,
      'status': 'processing',
      'image': 'headphones',
    },
    {
      'id': '#GB-8994',
      'productName': 'Ultrawide Monitor',
      'customer': 'Sarah Miller',
      'price': 899.00,
      'status': 'processing',
      'image': 'monitor',
    },
    {
      'id': '#GB-8992',
      'productName': 'Ergo Office Chair',
      'customer': 'James Wilson',
      'price': 420.00,
      'status': 'shipped',
      'image': 'chair',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadVendorData();
  }

  void loadVendorData() {
    // Load vendor dashboard data
    // This would typically fetch from an API
  }

  void viewAllOrders() {
    // Navigate to all orders screen
    print('Navigate to all orders');
  }

  void viewOrderDetails(Map<String, dynamic> order) {
    // Navigate to order details
    print('View order: ${order['id']}');
  }
}
