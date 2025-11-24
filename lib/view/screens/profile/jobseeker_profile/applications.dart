import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';


class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
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
