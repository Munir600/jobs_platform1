import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'companies/CompanyListScreen.dart';
import 'jobs/JobListScreen.dart';
import 'messages/MessagesScreen.dart';
import 'profile/employer_profile/employer_profile_screen.dart';
import 'profile/jobseeker_profile/jobseeker_profile_screen.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    // Note: Creating screens list inside build is fine for Stateless as long as they are const or lightweight. 
    // However, recreating them on every build isn't ideal if they hold state. 
    // IndexedStack preserves state of children. Using 'const' constructors where possible is key.
    // Since screens are mostly GetView/Stateless, this is efficient.
    
    final List<Widget> screens = [
      JobListScreen(),
      CompanyListScreen(),
      MessagesScreen(),
      authController.isJobSeeker
          ? JobseekerProfileScreen()
          : CompanyProfile(),
    ];

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
            onPressed: () => _confirmLogout(),
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
            index: _selectedIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الوظائف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'الشركات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'الرسائل',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      )),
    );
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
      await authController.logout();
    }
  }
}