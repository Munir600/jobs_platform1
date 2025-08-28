
import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class SplashLogo extends StatelessWidget {
  final double size;
  const SplashLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Color(0xFF08BBB5), Color(0xFFFF9800)]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: Offset(0,6))],
      ),
      child: Center(child: Image.asset('assets/icons/app_icon.png', width: size*0.6, height: size*0.6)),
    );
  }
}