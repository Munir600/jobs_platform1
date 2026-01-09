import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobs_platform1/config/app_colors.dart';
import '../../../../controllers/profile_navigation_controller.dart';
import '../../companies/MyCompaniesScreen.dart';
import '../../companies/job_forms/job_forms_screen.dart';
import '../../interview/InterviewListScreen.dart';
import '../employer_profile/setting.dart';
import '../user_profile_screen.dart';
import 'EmployerApplicationsScreen.dart';
import 'EmployerJobManagementScreen.dart';
import 'employer_dashboard_stats.dart';

class CompanyProfile extends StatelessWidget {
  CompanyProfile({super.key});

  final ProfileNavigationController _navController = Get.find<ProfileNavigationController>();

  final List<Widget> _screens = [
    UserProfileScreen(),
    EmployerDashboardStatsScreen(),
    MyCompaniesScreen(),
    EmployerJobManagementScreen(),
    const EmployerApplicationsScreen(),
    const InterviewListScreen(),
    JobFormsScreen(),
    SettingScreen(),
  ];

  final List<String> _titles = [
    " تعديـل الملف الشخصي",
    " لوحة التحكم",
    " ادارة شركاتي",
    " ادارة الوظائف",
    " ادارة الطلبات ",
    " إدارة المقابلات ",
    "ادارة نماذج التقديم",
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
                      : i == 4
                      ? Icons.folder_shared
                      : i == 5
                      ? Icons.event_note
                      : i == 6
                      ? Icons.description
                      : Icons.settings,
                  color: AppColors.primaryColor,
                ),
                title: Text(_titles[i]),
                onTap: () {
                  _navController.setEmployerIndex(i);
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
      body: Obx(() => _screens[_navController.employerIndex.value]),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => _openNavigationSheet(context),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.menu),
      ),
    );
  }
}
