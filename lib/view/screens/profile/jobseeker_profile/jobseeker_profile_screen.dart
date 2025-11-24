import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../config/app_colors.dart';

import '../../../../controllers/auth_controller.dart';
import '../../applications/my_applications_screen.dart';
import '../../jobs/saved_jobs.dart';
import 'alert_jobs.dart';
import 'dashboard.dart';
import 'edit_jobseeker_profile.dart';
import 'edit_resume_screen.dart';
import 'setting.dart';

class JobseekerProfileScreen extends StatefulWidget {
  const JobseekerProfileScreen({super.key});

  @override
  State<JobseekerProfileScreen> createState() => _JobseekerProfileScreenState();
}

class _JobseekerProfileScreenState extends State<JobseekerProfileScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    MyApplicationsScreen(),
    SavedJobsScreen(),
    EditJobseekerProfile(),
    EditResumeScreen(),
    AlertJobsScreen(),
    SettingScreen(),
  ];

  final List<String> _titles = [
    "📊 نظرة عامة",
    "📑 طلباتي",
    "🔖 الوظائف المحفوظة",
    "👤 تعديـل الملف الشخصي",
    "📄 السيرة الذاتية",
    "🔔 تنبيهات الوظائف",
    "⚙️ الإعدادات",
  ];

  void _openNavigationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            for (int i = 0; i < _titles.length; i++)
              ListTile(
                leading: Icon(
                  i == 0
                      ? Icons.dashboard
                      : i == 1
                      ? Icons.assignment
                      : i == 2
                      ? Icons.bookmark
                      : i == 3
                      ? Icons.person
                      : i == 4
                      ? Icons.description
                      : i == 5
                      ? Icons.notifications
                      : Icons.settings,
                  color: AppColors.primaryColor,
                ),
                title: Text(_titles[i]),
                onTap: () {
                  setState(() => _currentIndex = i);
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }



  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _openNavigationSheet,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.menu),
      ),
    );
  }
}
