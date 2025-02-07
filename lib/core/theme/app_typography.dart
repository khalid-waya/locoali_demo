import 'package:flutter/material.dart';
import "color_pallete.dart"; // Assuming you're using the previous color palette class

class AppTypography {
  // Font Families
  static const String primaryFont = 'Urbanist';
  static const String secondaryFont = 'Manrope';

  // Display Styles (Previous styles remain the same)
  static final TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: ColorPalette.primaryText,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 45,
    fontWeight: FontWeight.w600, // Semi-Bold
    color: ColorPalette.primaryText,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: FontWeight.w600, // Semi-Bold
    color: ColorPalette.primaryText,
  );

  // Headline Styles (Previous styles remain the same)
  static final TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 42,
    fontWeight: FontWeight.w700, // Normal
    color: ColorPalette.primaryText,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: FontWeight.w600, // Medium
    color: ColorPalette.primaryText,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.primaryText,
  );

  // Title Styles (Previous styles remain the same)
  static final TextStyle titleLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 22,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.primaryText,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.info,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.info,
  );

  // New Label Styles
  static final TextStyle labelLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.secondaryText,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.secondaryText,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 11,
    fontWeight: FontWeight.w500, // Medium
    color: ColorPalette.secondaryText,
  );

  // New Body Styles
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Normal
    color: ColorPalette.secondaryText,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Normal
    color: ColorPalette.secondaryText,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Normal
    color: ColorPalette.primaryText,
  );

  // Prevent instantiation
  AppTypography._();

  // Convenience method to get a style by name
  static TextStyle getStyle(String styleName) {
    switch (styleName) {
      case 'displayLarge':
        return displayLarge;
      case 'displayMedium':
        return displayMedium;
      case 'displaySmall':
        return displaySmall;
      case 'headlineLarge':
        return headlineLarge;
      case 'headlineMedium':
        return headlineMedium;
      case 'headlineSmall':
        return headlineSmall;
      case 'titleLarge':
        return titleLarge;
      case 'titleMedium':
        return titleMedium;
      case 'titleSmall':
        return titleSmall;
      case 'labelLarge':
        return labelLarge;
      case 'labelMedium':
        return labelMedium;
      case 'labelSmall':
        return labelSmall;
      case 'bodyLarge':
        return bodyLarge;
      case 'bodyMedium':
        return bodyMedium;
      case 'bodySmall':
        return bodySmall;
      default:
        throw ArgumentError('No style found for $styleName');
    }
  }
}
