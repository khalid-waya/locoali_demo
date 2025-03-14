import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
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

  // Remove the silent sign-in attempt as it might be causing issues
  // await GoogleSignIn().signInSilently();

  // Add reCAPTCHA verification
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: false, // Set to true only for testing
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
        future: FirebaseAuth.instance.userChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return FirebaseAuth.instance.currentUser == null
                ? const SignupPage()
                : const LoginPage();
          }
          return const HomePage();
        },
      ),
    );
  }
}
