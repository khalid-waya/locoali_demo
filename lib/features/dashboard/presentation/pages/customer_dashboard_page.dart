import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';

class CustomerDashboardPage extends StatelessWidget {
  const CustomerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 80,
              color: ColorPalette.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome, ${user?.displayName ?? "Customer"}!',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'You are logged in as a Customer',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Customer Dashboard Features Coming Soon:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureItem(Icons.store, 'Browse Local Businesses'),
            _buildFeatureItem(Icons.event, 'Discover Local Events'),
            _buildFeatureItem(Icons.calendar_today, 'Book Services'),
            _buildFeatureItem(Icons.message, 'Chat with Businesses'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: ColorPalette.primary),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
