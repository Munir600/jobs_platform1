import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text('نظرة عامة على الوظائف',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
