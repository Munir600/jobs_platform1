import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

// ----------------------- قالب الصفحات الفرعية -----------------------
class _ProfileSubPage extends StatelessWidget {
  final String title;
  final Widget child;

  const _ProfileSubPage({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context)
                    .pushReplacementNamed('profile/home');
              }
            },
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// ----------------------- الشاشات الفرعية -----------------------
class DashboardScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "📊 نظرة عامة",
      child: Center(child: Text("هذه شاشة نظرة عامة")),
    );
  }
}

class ApplicationsScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "📑 طلباتي",
      child: Center(child: Text("هذه شاشة طلباتي")),
    );
  }
}

class SavedJobsScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "🔖 الوظائف المحفوظة",
      child: Center(child: Text("هذه شاشة الوظائف المحفوظة")),
    );
  }
}

class ProfileDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "👤 الملف الشخصي",
      child: Center(child: Text("هذه شاشة الملف الشخصي")),
    );
  }
}

class CVBuilderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "📄 السيرة الذاتية",
      child: Center(child: Text("هذه شاشة السيرة الذاتية")),
    );
  }
}

class AlertJobsScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "🔔 تنبيهات الوظائف",
      child: Center(child: Text("هذه شاشة تنبيهات الوظائف")),
    );
  }
}

class SettingScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ProfileSubPage(
      title: "⚙️ الإعدادات",
      child: Center(child: Text("هذه شاشة الإعدادات")),
    );
  }
}

// ----------------------- JobSeekerScreen -----------------------
class JobSeekerScreen extends StatefulWidget {
  const JobSeekerScreen({super.key});

  @override
  State<JobSeekerScreen> createState() => _JobSeekerScreenState();
}

class _JobSeekerScreenState extends State<JobSeekerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Navigator(
        initialRoute: 'profile/home',
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case 'profile/home':
              page = _buildFullProfile(context);
              break;
            case 'profile/dashboard':
              page = DashboardScreen2();
              break;
            case 'profile/applications':
              page = ApplicationsScreen2();
              break;
            case 'profile/saved':
              page = SavedJobsScreen2();
              break;
            case 'profile/details':
              page = ProfileDetailsScreen();
              break;
            case 'profile/cv':
              page = CVBuilderScreen();
              break;
            case 'profile/alerts':
              page = AlertJobsScreen2();
              break;
            case 'profile/settings':
              page = SettingScreen2();
              break;
            default:
              page = _buildFullProfile(context);
          }
          return MaterialPageRoute(
            builder: (_) => page,
            settings: settings,
          );
        },
      ),
    );
  }

  /// شاشة البروفايل الرئيسية
  Widget _buildFullProfile(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/Logo4.png'),
          ),
          const SizedBox(height: 12),
          const Text(
            'محمد أحمد',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'مطور برمجيات',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          _SidebarNavItem(
            icon: Icons.dashboard,
            label: 'نظرة عامة',
            onTap: () =>
                Navigator.of(context).pushNamed('profile/dashboard'),
          ),
          _SidebarNavItem(
            icon: Icons.assignment,
            label: 'طلباتي',
            onTap: () =>
                Navigator.of(context).pushNamed('profile/applications'),
          ),
          _SidebarNavItem(
            icon: Icons.bookmark,
            label: 'الوظائف المحفوظة',
            onTap: () => Navigator.of(context).pushNamed('profile/saved'),
          ),
          _SidebarNavItem(
            icon: Icons.person,
            label: 'الملف الشخصي',
            onTap: () => Navigator.of(context).pushNamed('profile/details'),
          ),
          _SidebarNavItem(
            icon: Icons.description,
            label: 'السيرة الذاتية',
            onTap: () => Navigator.of(context).pushNamed('profile/cv'),
          ),
          _SidebarNavItem(
            icon: Icons.notifications,
            label: 'تنبيهات الوظائف',
            onTap: () => Navigator.of(context).pushNamed('profile/alerts'),
          ),
          _SidebarNavItem(
            icon: Icons.settings,
            label: 'الإعدادات',
            onTap: () => Navigator.of(context).pushNamed('profile/settings'),
          ),
        ],
      ),
    );
  }
}

// ----------------------- عنصر القائمة -----------------------
class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      onTap: onTap,
    );
  }
}
