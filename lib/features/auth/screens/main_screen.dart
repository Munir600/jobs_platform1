import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'home_screen.dart';
import '../../jobs/screens/search_job.dart';
import '../../job_seeker/screens/alert_jobs.dart';
import '../../job_seeker/screens/job_seeker_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;


  final List<Widget> _screens = const [
    HomeScreen(),          // من AppRoutes.home
    SearchJob(),     // من AppRoutes.searchJob
    AlertJobsScreen(),     // من JobSeekerRoutes.alertjobs
    JobSeekerScreen(),       // من JobSeekerRoutes.jobseeker
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.exit_to_app),
            label: const Text('خروج'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirm == true) {
      final auth = Provider.of<AuthController>(context, listen: false);
      final messenger = ScaffoldMessenger.of(context);
      await auth.logout();
      if (!mounted) return;
      final tokenAfterLogout = await StorageService.getToken();
      if (!mounted) return;
      if (tokenAfterLogout == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الخروج'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
                  (route) => false,
            );
          }
        });
      } else {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء تسجيل الخروج'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'اهـلا بـك في منـصـة التوظـيـف',
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
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
