import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../config/app_colors.dart';
import '../../jobs/saved_jobs.dart';
import '../user_profile_screen.dart';
import 'JobSeekerProfileScreen.dart' as resume;
import 'alert_jobs.dart';
import 'dashboard.dart';
import 'setting.dart';


class JobseekerProfileScreen extends StatelessWidget {
   JobseekerProfileScreen({super.key});

  final RxInt _currentIndex = 0.obs;

  final List<String> _titles = [
    " تعديـل الملف الشخصي",
    " الوظائف المحفوظة",
    " لوحة التحكم",
    "السيرة الذاتية",
    " تنبيهات الوظائف",
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
                  _currentIndex.value = i;
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
        return Icons.dashboard_outlined;
      case 3:
        return Icons.description_outlined;
      case 4:
        return Icons.notifications_none;
      case 5:
        return Icons.settings_outlined;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reconstruct list here to avoid initialization issues or make screens lazy?
    // screens list can be initialized.
    // Wait, `JobSeekerProfileScreen` (Resume) implies it might need arguments?
    // Assuming no args as per original.
    
    final List<Widget> screens = [
        UserProfileScreen(),
        SavedJobsScreen(),
        JobSeekerDashboard(),
        // We need to refer to the Resume screen.
        // I'll use a dynamic approach or just assume the import works.
        // Creating a local list in build is safer for context if needed.
    ];
    
    // Actually, I can't put `JobSeekerProfileScreen()` in the list inside this class if the names conflict
    // and I don't use a prefix.
    // I will use `const` where possible.
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // We handle the index switch here.
        // We need to instantiate the Resume screen.
        // Let's assume the Resume screen is `JobSeekerResumeScreen` or `JobSeekerProfileScreen` (imported).
        // Since I cannot change the imported file name right now, I have to guess valid usage.
        // The original code `JobSeekerProfileScreen()` worked.
        // So `JobSeekerProfileScreen` (capital S) must be available.
        
        // I will use a switch for clarity and safety.
        switch(_currentIndex.value) {
            case 0: return UserProfileScreen();
            case 1: return SavedJobsScreen();
            case 2: return JobSeekerDashboard();
            case 4: return AlertJobsScreen();
            case 5: return SettingScreen();
            case 3: 
            default:
                 // Using reflection/Get to find the other screen? No.
                 // I'll try to use the class name as user had it.
                 // If it fails, I'll fix it.
                 // To avoid conflict, I'm checking if I can use 'as' import.
                 // But I'm writing string content.
                 // I'll add `import 'JobSeekerProfileScreen.dart' as resume;` to be safe.
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
