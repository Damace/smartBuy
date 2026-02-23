import 'package:get/get.dart';

/// Shared reactive cart item count used by HomeController and any other
/// controller that adds items to cart, so the home badge stays in sync.
final RxInt globalCartCount = 0.obs;
