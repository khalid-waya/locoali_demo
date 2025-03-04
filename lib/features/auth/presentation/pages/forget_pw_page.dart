import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
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

      final result = await _resetPasswordUseCase.execute(
        email: emailController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          _showSuccessDialog();
        },
      );
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
            'Password reset instructions have been sent to your email. Please check your inbox.',
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
    );
  }
}
