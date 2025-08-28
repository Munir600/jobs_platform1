
import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const AuthScaffold({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: SafeArea(child: Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 700), child: Padding(padding: EdgeInsets.all(16), child: child)))),
    );
  }
}