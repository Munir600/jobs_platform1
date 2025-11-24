import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text(' صفحة الطلبات',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

