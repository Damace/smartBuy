import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';
import '../../core/themes/app_theme.dart';
import '../../core/constants/app_constants.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _bottomController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoShadow;
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _bottomFade;

  final SplashController controller = Get.find<SplashController>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // --- Logo: scale bounce + fade (0–700ms) ---
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );
    _logoShadow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // --- Text: slide-up + fade (starts at 350ms) ---
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _nameFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.35, 1.0, curve: Curves.easeOut),
      ),
    );

    // --- Bottom progress: fade in (starts at 650ms) ---
    _bottomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bottomFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bottomController, curve: Curves.easeIn),
    );

    // Staggered start sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) _bottomController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ── Logo ──────────────────────────────────────
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) => FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor
                                .withValues(alpha: 0.38 * _logoShadow.value),
                            blurRadius: 36,
                            spreadRadius: 2,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_cart_rounded,
                        size: 58,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ── App Name ──────────────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) => FadeTransition(
                  opacity: _nameFade,
                  child: SlideTransition(
                    position: _nameSlide,
                    child: Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Tagline ───────────────────────────────────
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) => FadeTransition(
                  opacity: _taglineFade,
                  child: Text(
                    'app_tagline'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // ── Progress section ──────────────────────────
              FadeTransition(
                opacity: _bottomFade,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      Text(
                        'initializing'.tr,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 2,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                ),
                      ),
                      const SizedBox(height: 14),
                      Obx(
                        () => TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0, end: controller.progress.value),
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          builder: (context, value, child) => LinearProgressIndicator(
                            value: value,
                            backgroundColor: AppTheme.borderColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
