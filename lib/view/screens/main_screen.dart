import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'companies/CompanyListScreen.dart';
import 'companies/MyCompaniesScreen.dart';
import 'jobs/CreateJobScreen.dart';
import 'jobs/JobListScreen.dart';
import 'jobs/job_alert_screen.dart';
import 'profile/employer_profile/employer_profile_screen.dart';
import 'profile/jobseeker_profile/jobseeker_profile_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainScreen extends StatefulWidget {
  final GetStorage _storage = GetStorage();
  final AuthController _authController = Get.find<AuthController>();
  final String? jobseeker = GetStorage().read('user_data')?['user_type'];
  final String? employer = GetStorage().read('user_data')?['user_type'];
   MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens {
    final auth = Get.find<AuthController>();

    return [
      JobListScreen(),
      CompanyListScreen(),
      AlertJobsScreen(),
      auth.isJobSeeker
          ? JobseekerProfileScreen()
          : CompanyProfile(),
    ];
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  Future<void> _confirmLogout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            icon: const Icon(Icons.exit_to_app),
            label: const Text('خروج'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (confirm == true) {
      final auth = Get.find<AuthController>();
      await auth.logout(); // هذا ينفّذ كل العملية
      Get.snackbar(
        '',
        'تم تسجيل الخروج',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'منـصـة التوظـيـف',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
           //onPressed: getUserType,
          onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          const PatternBackground(),
          //print usertype in sna
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الشاشة الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'بحث',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'الإشعارات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }
}