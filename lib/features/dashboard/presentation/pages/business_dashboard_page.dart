import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';

class BusinessDashboardPage extends StatelessWidget {
  const BusinessDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
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
              Icons.business,
              size: 80,
              color: ColorPalette.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome, ${user?.displayName ?? "Business Owner"}!',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'You are logged in as a Business Owner',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Business Dashboard Features Coming Soon:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFeatureItem(Icons.store, 'Manage Your Business Profile'),
            _buildFeatureItem(Icons.event, 'Create and Manage Events'),
            _buildFeatureItem(Icons.calendar_today, 'View and Manage Bookings'),
            _buildFeatureItem(Icons.message, 'Chat with Customers'),
            _buildFeatureItem(Icons.analytics, 'Business Analytics'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement business profile creation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Business profile creation coming soon!'),
            ),
          );
        },
        backgroundColor: ColorPalette.primary,
        child: const Icon(Icons.add),
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
