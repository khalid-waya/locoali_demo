import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoali_demo/core/theme/app_theme.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/signup_page.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Entry point of the application
void main() async {

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

 
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Locoali Demo',
      theme: AppTheme.lightThemeMode,
      home: FutureBuilder(
        // Check if user has previously signed up
        future: FirebaseAuth.instance.userChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // If user exists but not logged in, show login page
          if (snapshot.data == null) {
            return FirebaseAuth.instance.currentUser == null
                ? const SignupPage() // New user, show signup
                : const LoginPage(); // Existing user, show login
          }

          // If user is logged in, show home page
          return const HomePage();
        },
      ),
    );
  }
}
