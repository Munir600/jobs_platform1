import 'package:flutter/widgets.dart';
import 'screens/alert_jobs.dart';
import 'screens/applications.dart';
import 'screens/job_seeker_screen.dart';
import 'screens/saved_jobs.dart';
import 'screens/cv_bulider.dart';
import 'screens/dashboard.dart';
import 'screens/edit_profile.dart';
import 'screens/setting.dart';

class JobSeekerRoutes {
  static const String alertjobs = '/alertjobs';
  static const String applications = '/applications';
  static const String jobseeker = '/jobseeker';
  static const String savedjobs = '/savedjobs';
  static const String cvbuilder = '/cvbuilder';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String setting = '/setting';


  static Map<String, WidgetBuilder> get routes => {
    alertjobs: (_) => const AlertJobsScreen(),
    applications: (_) => const ApplicationsScreen(),
    jobseeker: (_) => const JobSeekerScreen(),
    savedjobs: (_) => const SavedJobsScreen(),
    cvbuilder: (_) => const CvBuilderScreen(),
    dashboard: (_) => const DashboardScreen(),
    profile: (_) => const ProfileScreen(),
    setting: (_) => const SettingScreen(),
  };
}
