import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class ProfileRouter extends StatelessWidget {
  const ProfileRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic?>(
      // converted to GetX; removed provider package
      future: Get.find<AuthController>().currentUser != null
          ? Future.value(Get.find<AuthController>().currentUser)
          : Future.value(null),
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
        if ((user as dynamic).userType == 'job_seeker') {
          return const SizedBox.shrink(); // TODO: return JobSeekerScreen()
        } else if ((user as dynamic).userType == 'employer') {
          return const SizedBox.shrink(); // TODO: return CompaniesScreen()
        } else {
          return Center(child: Text('نوع المستخدم غير معروف'));
        }
      },
    );
  }
}