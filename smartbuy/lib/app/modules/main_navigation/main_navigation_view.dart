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
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey<int>(controller.currentIndex.value),
            child: pages[controller.currentIndex.value],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Obx(
            () => BottomNavigationBar(
              currentIndex: _mapToNavIndex(controller.currentIndex.value),
              onTap: (index) {
                if (index == 2) return;
                controller.changePage(_mapToPageIndex(index));
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Get.isDarkMode
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
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
                // Spacer for center button
                const BottomNavigationBarItem(
                  icon: SizedBox(height: 24),
                  label: '',
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
          Positioned(top: -22, child: _centerButton()),
        ],
      ),
    );
  }

  int _mapToNavIndex(int pageIndex) {
    if (pageIndex >= 2) return pageIndex + 1;
    return pageIndex;
  }

  int _mapToPageIndex(int navIndex) {
    if (navIndex > 2) return navIndex - 1;
    return navIndex;
  }

  Widget _centerButton() {
    return GestureDetector(
      onTap: () => controller.currentIndex,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
