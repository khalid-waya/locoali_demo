import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_theme.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
