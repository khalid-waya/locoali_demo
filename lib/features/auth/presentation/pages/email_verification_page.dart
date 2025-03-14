import 'dart:async';
import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';

import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;
  final SendVerificationEmailUseCase sendVerificationEmailUseCase;
  final SignOutUseCase signOutUseCase;

  const EmailVerificationPage({
    required this.checkEmailVerifiedUseCase,
    required this.sendVerificationEmailUseCase,
    required this.signOutUseCase,
    super.key,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? deleteTimer;
  bool canResendEmail = true;
  late final DeleteAccountUseCase _deleteAccountUseCase;

  // Time limit for verification (10 minutes)
  final int _verificationTimeLimit = 10 * 60; // in seconds
  int _timeRemaining = 10 * 60; // in seconds

  @override
  void initState() {
    super.initState();

    // Initialize the delete account use case with the repository implementation
    _deleteAccountUseCase = DeleteAccountUseCase(AuthRepositoryImpl());

    // Start verification check timer
    checkEmailVerified();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );

    // Start countdown timer for account deletion
    _timeRemaining = _verificationTimeLimit;
    deleteTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {
            if (_timeRemaining > 0) {
              _timeRemaining--;
            } else {
              // Time's up, delete the account
              _handleAccountDeletion(reason: 'verification timeout');
            }
          });
        }
      },
    );

    // Send verification email automatically on page load
    sendVerificationEmail();
  }

  @override
  void dispose() {
    timer?.cancel();
    deleteTimer?.cancel();
    super.dispose();
  }

  String get formattedTimeRemaining {
    final minutes = (_timeRemaining / 60).floor();
    final seconds = _timeRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> checkEmailVerified() async {
    final result = await widget.checkEmailVerifiedUseCase.execute();

    result.fold(
      (failure) {
        if (mounted) {
          CustomSnackbar.showError(context, message: failure.message);
        }
      },
      (isVerified) {
        setState(() {
          isEmailVerified = isVerified;
        });

        if (isVerified) {
          // Email is verified, cancel all timers
          timer?.cancel();
          deleteTimer?.cancel();

          if (mounted) {
            CustomSnackbar.showSuccess(
              context,
              message: 'Email verified successfully!',
            );

            // Navigate to home page after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            });
          }
        }
      },
    );
  }

  Future<void> sendVerificationEmail() async {
    if (!canResendEmail) return;

    final result = await widget.sendVerificationEmailUseCase.execute();

    result.fold(
      (failure) {
        if (mounted) {
          CustomSnackbar.showError(context, message: failure.message);
        }
      },
      (_) {
        setState(() => canResendEmail = false);
        CustomSnackbar.showSuccess(
          context,
          message: 'Verification email sent. Please check your inbox.',
        );
        Future.delayed(const Duration(seconds: 60), () {
          if (mounted) setState(() => canResendEmail = true);
        });
      },
    );
  }

  Future<void> _handleSignOut() async {
    // Show confirmation dialog
    final shouldDelete = await _showDeleteConfirmationDialog();

    if (shouldDelete != true || !mounted) return;

    // User confirmed, proceed with account deletion
    _handleAccountDeletion(reason: 'user cancelled');
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Verification?'),
          content: const Text(
            'If you cancel, your account will be deleted. Are you sure you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Don't delete
              child: const Text('No, Continue Verification'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // Delete account
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Yes, Delete Account'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleAccountDeletion({required String reason}) async {
    // Cancel all timers
    timer?.cancel();
    deleteTimer?.cancel();

    // Show loading indicator
    if (mounted) {
      setState(() => _isLoading = true);
    }

    // Delete the account
    final result = await _deleteAccountUseCase.execute();

    if (!mounted) return;

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to delete account: ${failure.message}',
        );

        // Sign out anyway
        widget.signOutUseCase.execute();

        // Navigate to login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      (_) {
        // Account deleted successfully
        CustomSnackbar.showSuccess(
          context,
          message: 'Account deleted successfully',
        );

        // Navigate to login page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate content width - use iPhone 16 Pro Max width for large screens
    final contentWidth = screenWidth > DeviceBreakpoints.iPadAir
        ? DeviceBreakpoints.iphoneProMax * 0.9 // 90% of iPhone 16 Pro Max width
        : screenWidth * 0.9; // 90% of screen width for smaller screens

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSignOut,
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SizedBox(
                width: contentWidth,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'A verification email has been sent to your email address. Please check your inbox and click the verification link.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      // Countdown timer
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Time remaining for verification:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formattedTimeRemaining,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _timeRemaining < 60 ? Colors.red : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your account will be deleted if not verified in time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.email),
                        label: const Text('Resend Email'),
                        onPressed:
                            canResendEmail ? sendVerificationEmail : null,
                      ),
                      if (!canResendEmail)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'You can resend the email in 60 seconds',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
