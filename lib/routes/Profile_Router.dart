import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/user_model.dart';
import '../features/companies/screen/CompaniesScreen.dart';
import '../features/job_seeker/screens/job_seeker_screen.dart';
import '../features/auth/controllers/auth_controller.dart';

class ProfileRouter extends StatelessWidget {
  const ProfileRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: Provider.of<AuthController>(context, listen: false).getProfileModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ في جلب البيانات'));
        }
        final user = snapshot.data;
        if (user == null) {
          return Center(child: Text('لا يوجد بيانات مستخدم'));
        }
        if (user.userType == 'job_seeker') {
          return const JobSeekerScreen();
        } else if (user.userType == 'employer') {
          return  CompaniesScreen();
        } else {
          return Center(child: Text('نوع المستخدم غير معروف'));
        }
      },
    );
  }
}
