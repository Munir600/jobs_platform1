import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text(' الإعدادات ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
