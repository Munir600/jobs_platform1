import 'package:get/get.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/register_screen.dart';
import '../view/screens/home_screen.dart';
import '../view/screens/jobs/JobListScreen.dart';
import '../view/screens/jobs/JobDetailScreen.dart';
import '../view/screens/jobs/CreateJobScreen.dart';
import '../view/screens/companies/CompanyListScreen.dart';
import '../view/screens/companies/CompanyDetailScreen.dart';
import '../view/screens/applications/MyApplicationsScreen.dart';
import '../view/screens/applications/JobApplicationsScreen.dart';
import '../view/screens/applications/ApplicationDetailScreen.dart';
import '../view/screens/applications/ApplyJobScreen.dart';
import '../view/screens/interview/InterviewListScreen.dart';
import '../view/screens/interview/InterviewDetailScreen.dart';
import '../view/screens/main_screen.dart';
import '../view/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String mainScreen = '/mainScreen';
  
  // Jobs
  static const String jobs = '/jobs';
  static const String jobDetails = '/job-details';
  static const String createJob = '/create-job';
  
  // Companies
  static const String companies = '/companies';
  static const String companyDetails = '/company-details';
  
  // Applications
  static const String myApplications = '/my-applications';
  static const String jobApplications = '/job-applications';
  static const String applicationDetails = '/application-details';
  static const String applyJob = '/apply-job';
  
  // Interviews
  static const String interviews = '/interviews';
  static const String interviewDetails = '/interview-details';

  static List<GetPage> get pages => [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const RegisterScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: mainScreen, page: () =>  MainScreen()),
    
    // Jobs
    GetPage(name: jobs, page: () => const JobListScreen()),
    GetPage(name: jobDetails, page: () {
      final slug = Get.arguments as String;
      return JobDetailScreen(jobSlug: slug);
    }),
    GetPage(name: createJob, page: () => const CreateJobScreen()),
    
    // Companies
    GetPage(name: companies, page: () => const CompanyListScreen()),
    GetPage(name: companyDetails, page: () {
      final company = Get.arguments;
      return CompanyDetailScreen(company: company);
    }),
    
    // Applications
    GetPage(name: myApplications, page: () => const MyApplicationsScreen()),
    GetPage(name: jobApplications, page: () => const JobApplicationsScreen()),
    GetPage(name: applicationDetails, page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return ApplicationDetailScreen(
        application: args['application'],
        isEmployer: args['isEmployer'] ?? false,
      );
    }),
    GetPage(name: applyJob, page: () {
      final args = Get.arguments as Map<String, dynamic>;
      return ApplyJobScreen(
        jobId: args['jobId'],
        jobTitle: args['jobTitle'],
      );
    }),
    
    // Interviews
    GetPage(name: interviews, page: () => const InterviewListScreen()),
    GetPage(name: interviewDetails, page: () {
      final interview = Get.arguments;
      return InterviewDetailScreen(interview: interview);
    }),
  ];
}
