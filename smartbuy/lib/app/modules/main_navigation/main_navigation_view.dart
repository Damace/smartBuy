import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'main_navigation_controller.dart';
import '../home/home_view.dart';
import '../category/category_view.dart';
import '../cart/cart_view.dart';
import '../profile/profile_view.dart';
import '../../core/themes/app_theme.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const CategoryView(),
      const CartView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(controller.currentIndex.value),
            child: pages[controller.currentIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Get.isDarkMode
              ? AppTheme.darkTextSecondary
              : AppTheme.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.category_outlined),
              activeIcon: const Icon(Icons.category),
              label: 'category'.tr,
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => badges.Badge(
                  badgeContent: Text(
                    controller.cartItemCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showBadge: controller.cartItemCount.value > 0,
                  position: badges.BadgePosition.topEnd(top: -8, end: -8),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
              activeIcon: Obx(
                () => badges.Badge(
                  badgeContent: Text(
                    controller.cartItemCount.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  showBadge: controller.cartItemCount.value > 0,
                  position: badges.BadgePosition.topEnd(top: -8, end: -8),
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
              label: 'cart'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
