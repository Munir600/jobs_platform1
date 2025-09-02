import 'package:flutter/material.dart';
import 'package:jobs_platform1/config/app_colors.dart';

class EmployerScreen extends StatelessWidget {
  const EmployerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/images/company_logo.png'),
            ),
            const SizedBox(height: 12),
            const Text(
              'شركة التقنيات الحديثة', // Placeholder اسم الشركة
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'قطاع تكنولوجيا المعلومات',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('تحديث بيانات الشركة'),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("إدارة الموظفين"),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text("إدارة الوظائف"),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("الإعدادات"),
            ),
          ],
        ),
      ),
    );
  }
}
