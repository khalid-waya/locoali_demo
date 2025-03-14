import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';


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
    // Calculate responsive button dimensions
    final buttonWidth = DeviceBreakpoints.getResponsiveWidth(
        context, 0.9); // 90% of available width
    final buttonHeight = DeviceBreakpoints.getResponsiveHeight(
        context, 0.06); // 6% of available height

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
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: ColorPalette.info,
                strokeWidth: 3,
              )
            : Text(buttonText, style: AppTypography.authButton),
      ),
    );
  }
}
