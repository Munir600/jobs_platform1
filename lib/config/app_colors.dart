import 'package:flutter/material.dart';

class AppColors {
  static const textColor = Color(0xFF050315);
  static const backgroundColor = Color(0xFFE4EAFA);
  static const primaryColor = Color(0xFF03A8F2);
  static const secondaryColor = Color(0xFF2195F1);
  static const accentColor = Color(0xDF7AC6F6);
}
class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}