import 'package:flutter/widgets.dart';

import '../view/screens/auth/login_screen.dart';
import '../view/screens/auth/register_screen.dart';
import '../view/screens/home_screen.dart';
import '../view/screens/jobs/jobs_list_screen.dart';
import '../view/screens/main_screen.dart';
import '../view/screens/splash_screen.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String mainScreen = '/mainScreen';
  static const String searchJob = '/searchJob';

  static Map<String, WidgetBuilder> get routes => {
    signup: (_) => const RegisterScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(),
    splash: (_) => const SplashScreen(),
     mainScreen: (_) =>  MainScreen(),
    searchJob: (_) =>  JobsScreen(),
  };
}
