import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_theme.dart';
import 'package:locoali_demo/features/auth/presentation/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Locoali Demo',
        theme: AppTheme.lightThemeMode,
        home: SignupPage());
  }
}
