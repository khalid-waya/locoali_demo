import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';
import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';
import 'package:locoali_demo/core/utils/custom_snackbar.dart';

class SigninGoogleButton extends StatefulWidget {
  const SigninGoogleButton({super.key});

  @override
  State<SigninGoogleButton> createState() => _SigninGoogleButtonState();
}

class _SigninGoogleButtonState extends State<SigninGoogleButton> {
  final GoogleSignInUseCase _googleSignInUseCase =
      GoogleSignInUseCase(AuthRepositoryImpl());
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Starting Google sign-in process from button');
      final result = await _googleSignInUseCase.execute();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      result.fold(
        (failure) {
          debugPrint('Google sign-in failed: ${failure.message}');
          CustomSnackbar.showError(context,
              message: 'Google sign-in failed: ${failure.message}');
        },
        (success) {
          debugPrint('Google sign-in successful: ${success.message}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      );
    } catch (e) {
      debugPrint('Unexpected error during Google sign-in: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      CustomSnackbar.showError(context,
          message: 'Error during Google sign-in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive button dimensions
    final buttonWidth = DeviceBreakpoints.getResponsiveWidth(
        context, 0.9); // 90% of available width
    final buttonHeight = DeviceBreakpoints.getResponsiveHeight(
        context, 0.06); // 6% of available height

    // Fixed icon size regardless of screen size
    // This ensures the Google logo doesn't shrink on larger screens
    final iconSize = 24.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : () => _handleGoogleSignIn(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        icon: _isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Image.asset(
                "assets/img/google_logo.png",
                height: iconSize,
              ),
        label: Text(
          _isLoading ? "Signing in..." : "Continue with Google",
          style: AppTypography.bodyMedium.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
