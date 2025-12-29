import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset('assets/animation/BusinessAnalysis.json'),
      ),
      duration: 4500,
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
  @override
  void initState() {
    super.initState();
    _navigate();
  }
  Future<void> _navigate() async {
    final token = await StorageService.getToken();
    if (!mounted) return;
    final route = token != null ? AppRoutes.mainScreen : AppRoutes.login;
    Navigator.pushReplacementNamed(context, route);
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
