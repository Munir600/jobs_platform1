import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/ChatController.dart';
import '../../core/utils/network_utils.dart';
import 'companies/CompanyListScreen.dart';
import 'jobs/JobListScreen.dart';
import 'messages/ai_chat.dart';
import 'messages/message_screen.dart';
import 'profile/employer_profile/employer_profile_screen.dart';
import 'profile/jobseeker_profile/jobseeker_profile_screen.dart';

class MainScreen extends StatelessWidget {
   MainScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final RxInt _selectedIndex = 0.obs;
  ChatController get chatController => Get.find();

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return JobListScreen();
      case 1:
        return CompanyListScreen();
      case 2:
        return MessagesScreen();
      case 3:
        return authController.isJobSeeker
            ? JobseekerProfileScreen()
            : CompanyProfile();
      default:
        return JobListScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'منـصـة توظـيـف',
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
            icon: const Icon(Icons.auto_awesome_outlined),
            tooltip: 'وكيل التوظيف الذكي ',
            onPressed:() async {
              final hasInternet = await NetworkUtils.checkInternet(context);
              if (!hasInternet) {
               return;
              }else{
                Get.to(AiChat());
              }
            }
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () => _confirmLogout(),
          ),

        ],
      ),
      body: Obx(() => _buildScreen(_selectedIndex.value)),
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
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
              icon: Icon(Icons.business_center_sharp),
              label: 'الوظائف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
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
            onPressed: () => Get.back(result: false), // Fix translation/text
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