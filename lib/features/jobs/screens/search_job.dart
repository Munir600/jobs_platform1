import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class SearchJob extends StatefulWidget {
  const SearchJob({super.key});

  @override
  State<SearchJob> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Text(
          'Search Job Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
