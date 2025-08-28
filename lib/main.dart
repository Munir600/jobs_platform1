import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'routes/app_routes.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
    // Localization و RTL
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ar', 'SA'),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
     // home:  SplashScreen(),
    );
  }
}

