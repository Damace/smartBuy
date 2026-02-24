import 'package:SmartBuy/app/core/constants/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemStatusView extends StatelessWidget {
  const SystemStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: const BackButton(color: Colors.white),
      //   title: const Text(
      //     "System Status",
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _statusIcon(),
            const PulseLoader(),

            const SizedBox(height: 24),

            const Text(
              "Connection Lost",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "We cannot monitor gas levels in real-time.\n"
              "Please restore your internet connection immediately "
              "to receive safety alerts.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 16),

            _offlineBadge(),

            const SizedBox(height: 32),

            _retryButton(),

            const SizedBox(height: 12),

            _settingsButton(),
          ],
        ),
      ),
    );
  }

  /// 🔴 Animated Radar / Icon
  Widget _statusIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent.withOpacity(0.08),
          ),
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent.withOpacity(0.12),
          ),
        ),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(Icons.wifi_off, size: 36, color: Colors.blueAccent),
        ),
        const Positioned(
          top: 38,
          right: 42,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.priority_high, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// 🔴 Offline Badge
  Widget _offlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Offline Mode Active",
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 🔁 Retry Button
  Widget _retryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final connectivity = Get.find<ConnectivityService>();

          // Force a re-check
          await connectivity.checkNow();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text("Retry Connection"),
      ),
    );
  }

  /// ⚙️ Open System Settingscd
  Widget _settingsButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          //AppSettings.openAppSettings();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          "Open Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class PulseLoader extends StatefulWidget {
  const PulseLoader({super.key});

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent.withOpacity(
              0.15 * (1 - _controller.value),
            ),
          ),
          child: const Icon(Icons.wifi_off, color: Colors.blueAccent, size: 40),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
