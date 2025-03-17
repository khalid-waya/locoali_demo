// lib/features/home/presentation/pages/home_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';
import 'package:locoali_demo/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:locoali_demo/features/user_profile/domain/entities/user_profile.dart';
import 'package:locoali_demo/features/user_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:locoali_demo/features/dashboard/presentation/pages/customer_dashboard_page.dart';
import 'package:locoali_demo/features/dashboard/presentation/pages/business_dashboard_page.dart';
import 'package:locoali_demo/features/user_profile/presentation/pages/role_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  final GetUserProfileUseCase _getUserProfileUseCase =
      GetUserProfileUseCase(UserProfileRepositoryImpl());

  @override
  void initState() {
    super.initState();
    _checkUserAndRedirect();
  }

  Future<void> _checkUserAndRedirect() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _navigateToLogin();
      return;
    }

    try {
      final result = await _getUserProfileUseCase.execute(user.uid);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      result.fold(
        (failure) {
          // If there's an error getting profile, go to role selection
          CustomSnackbar.showError(
            context,
            message:
                'Could not retrieve your profile. Please set up your account.',
          );

          _navigateToRoleSelection();
        },
        (profile) {
          // Navigate based on user role
          if (profile.role == UserRole.businessOwner) {
            _navigateToBusinessDashboard();
          } else {
            _navigateToCustomerDashboard();
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      CustomSnackbar.showError(
        context,
        message: 'An error occurred: ${e.toString()}',
      );

      // Default to role selection on error
      _navigateToRoleSelection();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _navigateToRoleSelection() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
      (route) => false,
    );
  }

  void _navigateToCustomerDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const CustomerDashboardPage()),
      (route) => false,
    );
  }

  void _navigateToBusinessDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BusinessDashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Redirecting...'),
      ),
    );
  }
}
