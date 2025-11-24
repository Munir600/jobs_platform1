import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: const Center(
        child: Text('الوظائف المحفوظة',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
