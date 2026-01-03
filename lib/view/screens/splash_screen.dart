import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../routes/app_routes.dart';
import '../../core/api_service.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/animation/BusinessAnalysis.json'),
      ),
      duration: 2000,
      splashIconSize: 1000,
      backgroundColor: const Color(0xFFACD6F7),
      splashTransition: SplashTransition.fadeTransition,
      nextScreen: const _NextScreenDecider(),
    );
  }
}
class _NextScreenDecider extends StatefulWidget {
  const _NextScreenDecider();
  @override
  State<_NextScreenDecider> createState() => _NextScreenDeciderState();
}
class _NextScreenDeciderState extends State<_NextScreenDecider> {
  final ApiService _apiService = Get.find();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }
  void _navigate() {
    final token = _apiService.authToken;
    final route = token != null ? AppRoutes.mainScreen : AppRoutes.login;
    Get.offAllNamed(route);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFACD6F7),
      child: Center(
        child: Lottie.asset('assets/animation/BusinessAnalysis.json'),
      ),
    );
  }
}
