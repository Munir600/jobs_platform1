import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../job_seeker/screens/job_seeker_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('لا يوجد وظائف في الوقت الحالي :'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(
            Icons.add,
        ),
      ),
    );
  }
}
