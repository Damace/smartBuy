import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../themes/app_theme.dart';

class Helpers {
  Helpers._();

  // Show Snackbar
  static void showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: duration,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // Show Success Message
  static void showSuccess(String message) {
    showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
    );
  }

  // Show Error Message
  static void showError(String message) {
    showSnackbar(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red,
    );
  }

  // Show Info Message
  static void showInfo(String message) {
    showSnackbar(
      title: 'Info',
      message: message,
      backgroundColor: Colors.blue,
    );
  }

  // Show Warning Message
  static void showWarning(String message) {
    showSnackbar(
      title: 'Warning',
      message: message,
      backgroundColor: Colors.orange,
    );
  }

  // Show Bottom Sheet - Generic
  static void showBottomSheet({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    String buttonText = 'Okay',
    VoidCallback? onButtonPressed,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppTheme.darkCardColor : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Get.isDarkMode ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  onButtonPressed?.call();
                },
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  // Show Success Bottom Sheet
  static void showSuccessSheet(String message, {String? title, VoidCallback? onClose}) {
    showBottomSheet(
      title: title ?? 'Success!',
      message: message,
      icon: Icons.check_circle,
      iconColor: AppTheme.successColor,
      buttonText: 'Great!',
      onButtonPressed: onClose,
    );
  }

  // Show Error Bottom Sheet
  static void showErrorSheet(String message, {String? title, VoidCallback? onClose}) {
    showBottomSheet(
      title: title ?? 'Error!',
      message: message,
      icon: Icons.error,
      iconColor: AppTheme.errorColor,
      buttonText: 'Okay',
      onButtonPressed: onClose,
    );
  }

  // Show Info Bottom Sheet
  static void showInfoSheet(String message, {String? title, VoidCallback? onClose}) {
    showBottomSheet(
      title: title ?? 'Information',
      message: message,
      icon: Icons.info,
      iconColor: AppTheme.infoColor,
      buttonText: 'Got it',
      onButtonPressed: onClose,
    );
  }

  // Show Warning Bottom Sheet
  static void showWarningSheet(String message, {String? title, VoidCallback? onClose}) {
    showBottomSheet(
      title: title ?? 'Warning!',
      message: message,
      icon: Icons.warning,
      iconColor: AppTheme.warningColor,
      buttonText: 'Understood',
      onButtonPressed: onClose,
    );
  }

  // Format Currency
  static String formatCurrency(double amount) {
    return '${AppConstants.currencySymbol}${amount.toStringAsFixed(2)}';
  }

  // Format Date
  static String formatDate(DateTime date, {String? format}) {
    return DateFormat(format ?? AppConstants.dateFormat).format(date);
  }

  // Format DateTime
  static String formatDateTime(DateTime dateTime, {String? format}) {
    return DateFormat(format ?? AppConstants.dateTimeFormat).format(dateTime);
  }

  // Format Time
  static String formatTime(DateTime time, {String? format}) {
    return DateFormat(format ?? AppConstants.timeFormat).format(time);
  }

  // Parse Date String
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Email Validator
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailPattern).hasMatch(email);
  }

  // Phone Validator
  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phonePattern).hasMatch(phone);
  }

  // Password Validator
  static bool isValidPassword(String password) {
    return password.length >= AppConstants.minPasswordLength;
  }

  // Get Time Ago
  static String getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  // Show Loading Dialog
  static void showLoadingDialog({String message = 'Loading...'}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(message),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Hide Loading Dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // Show Confirmation Dialog
  static Future<bool> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Calculate Discount Percentage
  static double calculateDiscountPercentage(double originalPrice, double discountedPrice) {
    if (originalPrice == 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  // Format Discount Percentage
  static String formatDiscountPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}% OFF';
  }

  // Capitalize First Letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Truncate Text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Get Order Status Color
  static Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Parse Error Message from Exception
  static String parseErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }
}
