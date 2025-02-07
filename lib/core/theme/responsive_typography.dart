import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextStyle? desktopStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileStyle,
    this.tabletStyle,
    this.desktopStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getResponsiveStyle(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getResponsiveStyle(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // If a specific style is provided, use it
    if (style != null) {
      return _scaleFontSize(context, style!);
    }

    // Determine the appropriate style based on screen width
    if (screenWidth < 600) {
      // Mobile
      return _scaleFontSize(context, mobileStyle ?? AppTypography.bodyMedium);
    } else if (screenWidth < 1200) {
      // Tablet
      return _scaleFontSize(context, tabletStyle ?? AppTypography.bodyLarge);
    } else {
      // Desktop
      return _scaleFontSize(
          context, desktopStyle ?? AppTypography.displaySmall);
    }
  }

TextStyle _scaleFontSize(BuildContext context, TextStyle baseStyle) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define min and max screen sizes
    const double minScreenWidth = 375; // iPhone SE
    const double maxScreenWidth = 1920; // Large desktop

    // Calculate scaling factor
    double t =
        (screenWidth - minScreenWidth) / (maxScreenWidth - minScreenWidth);
    t = t.clamp(0.0, 1.0);

    // Base font size
    double baseFontSize = baseStyle.fontSize ?? 16;

    // Calculate scaled font size (increase by up to 20%)
    double scaledFontSize = baseFontSize * (1 + (0.2 * t));

    // Return new style with scaled font size
    return baseStyle.copyWith(
      fontSize: scaledFontSize,
    );
  }
}

// Extension method for even easier usage
extension ResponsiveTextExtension on Text {
  Widget responsive({
    TextStyle? mobileStyle,
    TextStyle? tabletStyle,
    TextStyle? desktopStyle,
  }) {
    return ResponsiveText(
      data ?? '',
      style: style,
      mobileStyle: mobileStyle,
      tabletStyle: tabletStyle,
      desktopStyle: desktopStyle,
    );
  }
}
