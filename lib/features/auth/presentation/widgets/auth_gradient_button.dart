import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    print('Button render'); // Add debug print
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth =
        (395 / 40) * screenSize.width; // Changed it to 40 from 430
    final buttonHeight =
        (55 / 932) * screenSize.height; // 932 is standard design height

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPalette.primary,
            ColorPalette.secondary,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          print('Button pressed'); // Add debug print
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        child: isLoading ? 
          const CircularProgressIndicator(
            color: ColorPalette.info,
            strokeWidth: 3,

          ) : 
          Text(
            buttonText,
            style: AppTypography.authButton
          ),
      ),
    );
  }
}
