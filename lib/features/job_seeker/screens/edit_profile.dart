import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text(' الملف الشخصي ',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
