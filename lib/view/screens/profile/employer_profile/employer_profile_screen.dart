import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

import '../../companies/MyCompaniesScreen.dart';
import '../../jobs/saved_jobs.dart';
import '../jobseeker_profile/applications.dart';
import '../jobseeker_profile/dashboard.dart';
import '../jobseeker_profile/setting.dart';
import '../user_profile_screen.dart';


class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UserProfileScreen(),
    DashboardScreen(),
    MyCompaniesScreen(),
    SavedJobsScreen(),
    SettingScreen(),
  ];

  final List<String> _titles = [
    "👤 تعديـل الملف الشخصي",
    "📊 نظرة عامة",
    "📑 شركاتي",
    "🔖 الوظائف المحفوظة",
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
