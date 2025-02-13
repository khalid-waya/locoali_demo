import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';

class SignupGoogleButton extends StatelessWidget {
  const SignupGoogleButton({super.key});

  void signupWithGoogle() {
    // Implement Google signup logic here
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = (395 / 40) * screenSize.width;
    final buttonHeight = (55 / 932) * screenSize.height;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: signupWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        icon: Image.asset(
          "assets/img/google_logo.png",
          height: 24,
        ),
        label: Text(
          "Sign up with Google",
          style: AppTypography.authButton.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}