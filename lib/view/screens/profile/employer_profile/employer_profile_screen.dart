import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Added
import 'package:jobs_platform1/config/app_colors.dart';
import '../../companies/MyCompaniesScreen.dart';
import '../employer_profile/dashboard.dart';
import '../employer_profile/setting.dart';
import '../user_profile_screen.dart';
import 'EmployerJobManagementScreen.dart';
import 'employer_dashboard_stats.dart';

class CompanyProfile extends StatelessWidget {
  CompanyProfile({super.key});

  final RxInt _currentIndex = 0.obs;

  final List<Widget> _screens = [
    UserProfileScreen(),
    EmployerDashboardStatsScreen(),
    MyCompaniesScreen(),
    EmployerJobManagementScreen(),
    EmployerDashboard(),
    SettingScreen(),
  ];

  final List<String> _titles = [
    " تعديـل الملف الشخصي",
    " لوحة التحكم",
    " ادارة شركاتي",
    " ادارة الوظائف",
    " ادارة الطلبات والمقابلات ",
    " الإعدادات",
  ];

  void _openNavigationSheet(BuildContext context) {
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
                  _currentIndex.value = i;
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
      body: Obx(() => _screens[_currentIndex.value]),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => _openNavigationSheet(context),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.menu),
      ),
    );
  }
}
