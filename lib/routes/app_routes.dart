
import 'package:flutter/widgets.dart';
import 'package:jobs_platform1/features/auth/screens/splash_screen.dart';
import '../features/auth/screens/Register_Screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/home_screen.dart';

class AppRoutes {
  static const String signup = '/signup';
  static const String login = '/login';
  static const String home = '/home';
  static const String splash = '/splash';

  static Map<String, WidgetBuilder> get routes => {
    signup: (_) => const RegisterScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(title: 'اهلا بـــك  في منـــصـة  التوظــيف'),
    splash: (_) => const SplashScreen(),
  };
}
