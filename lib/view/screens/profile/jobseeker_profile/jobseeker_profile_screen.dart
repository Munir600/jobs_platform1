import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jobs_platform1/view/screens/profile/jobseeker_profile/saved_jobs.dart';
import '../../../../config/app_colors.dart';
import '../../../../controllers/profile_navigation_controller.dart';
import '../../companies/FollowedCompaniesScreen.dart';
import '../user_profile_screen.dart';
import 'JobSeekerProfileScreen.dart' as resume;
import 'dashboard.dart';
import 'setting.dart';


class JobseekerProfileScreen extends StatelessWidget {
   JobseekerProfileScreen({super.key});

  final ProfileNavigationController _navController = Get.find<ProfileNavigationController>();

  final List<String> _titles = [
    " تعديـل الملف الشخصي",
    " الوظائف المحفوظة",
    "الشركات المتابعة",
    " لوحة التحكم",
    "الإعدادات",
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
                  _getIcon(i),
                  color: AppColors.primaryColor,
                ),
                title: Text(_titles[i]),
                onTap: () {
                  _navController.setJobseekerIndex(i);
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline;
      case 1:
        return Icons.bookmark_border;
      case 2:
        return Icons.business;
      case 3:
        return Icons.dashboard_outlined;
      case 4:
        return Icons.settings_outlined;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        switch(_navController.jobseekerIndex.value) {
            case 0: return UserProfileScreen();
            case 1: return SavedJobsScreen();
            case 2: return FollowedCompaniesScreen();
            case 3: return JobSeekerDashboard();
            case 4: return SettingScreen();
            default:
                 return resume.JobSeekerProfileScreen();
        }
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => _openNavigationSheet(context),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.menu),
      ),
    );
  }
}

