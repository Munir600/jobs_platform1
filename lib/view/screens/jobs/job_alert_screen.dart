import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class AlertJobsScreen extends StatefulWidget {
  const AlertJobsScreen({super.key});

  @override
  State<AlertJobsScreen> createState() => _AlertJobsScreenState();
}

class _AlertJobsScreenState extends State<AlertJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text(' صفحة تنبيهات الوظائف',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
