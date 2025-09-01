import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

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
      body:
      Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage('assets/images/Logo4.png'), // Placeholder image
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'تغيير الصورة',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'محمد أحمد', // Placeholder name
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'مطور برمجيات',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Profile completion
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Text('75% مكتمل', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('تحديث الملف الشخصي'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Navigation menu
                Column(
                  children: [
                    _SidebarNavItem(icon: '📊', label: 'نظرة عامة'),
                    _SidebarNavItem(icon: '📝', label: 'طلباتي'),
                    _SidebarNavItem(icon: '💾', label: 'الوظائف المحفوظة'),
                    _SidebarNavItem(icon: '👤', label: 'الملف الشخصي'),
                    _SidebarNavItem(icon: '📄', label: 'السيرة الذاتية'),
                    _SidebarNavItem(icon: '🔔', label: 'تنبيهات الوظائف'),
                    _SidebarNavItem(icon: '⚙️', label: 'الإعدادات'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final String icon;
  final String label;
  const _SidebarNavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 22)),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        onTap: () {}, // No navigation logic for UI only
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.transparent,
        hoverColor: Colors.blue[50],
      ),
    );
  }
}
