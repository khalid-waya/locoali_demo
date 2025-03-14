import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';
import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_field.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_gradient_button.dart';

class ForgetPwPage extends StatefulWidget {
  const ForgetPwPage({super.key});

  @override
  State<ForgetPwPage> createState() => _ForgetPwPageState();
}

class _ForgetPwPageState extends State<ForgetPwPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final ResetPasswordUsecase _resetPasswordUseCase;

  @override
  void initState() {
    super.initState();
    final repository = AuthRepositoryImpl();
    _resetPasswordUseCase = ResetPasswordUsecase(repository);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Directly send the password reset email without checking if email exists first
        // Firebase will handle this gracefully and always return success even if email doesn't exist
        final result = await _resetPasswordUseCase.execute(
          email: emailController.text,
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        result.fold(
          (failure) {
            CustomSnackbar.showError(
              context,
              message: failure.message,
            );
          },
          (_) {
            _showSuccessDialog();
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
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Sent'),
          content: const Text(
            'If an account exists with this email, password reset instructions have been sent. Please check your inbox.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to login page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate content width - use iPhone 16 Pro Max width for large screens
    final contentWidth = screenWidth > DeviceBreakpoints.iPadAir
        ? DeviceBreakpoints.iphoneProMax * 0.9 // 90% of iPhone 16 Pro Max width
        : screenWidth * 0.9; // 90% of screen width for smaller screens

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: AppTypography.headlineSmall.copyWith(
            color: ColorPalette.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Forgot your password?',
                      style: AppTypography.headlineMedium.copyWith(
                        color: ColorPalette.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter your email address and we\'ll send you instructions to reset your password.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 30),
                    AuthField(
                      hintText: "Email",
                      prefixIcon: Icons.email_outlined,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      buttonText: "Send Reset Link",
                      onPressed: _handleResetPassword,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
