// lib/features/home/presentation/pages/home_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/signup_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // First, check for error state
        if (snapshot.hasError) {
          print('Auth stream error: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text(
                  'Authentication error occurred. Please restart the app.'),
            ),
          );
        }

        // Check loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if user is null (not authenticated)
        if (!snapshot.hasData || snapshot.data == null) {
          print('User is null in HomePage, redirecting to signup');

          // Only navigate if context is valid and mounted
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is authenticated, show the home page
        final user = snapshot.data!;
        print('User authenticated in HomePage: ${user.uid}');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // NavigationState will handle redirection
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${user.displayName ?? "User"}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  'You are successfully logged in',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'If your account is deleted from Firebase,\nyou will be automatically redirected to signup.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
