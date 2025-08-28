
import 'package:flutter/material.dart';
import '../../auth/widgets/auth_scaffold.dart';

class JobsList extends StatelessWidget {
  const JobsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: AuthScaffold(title: 'قائمة الوظائف', child: const Center(child: Text('قائمة الوظائف - قادمة'))));
  }
}
