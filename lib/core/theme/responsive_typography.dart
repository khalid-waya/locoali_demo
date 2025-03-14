import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';

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

    // For screens larger than iPad Air, always use mobile style
    // This ensures text doesn't get too large on desktop screens
    if (screenWidth > DeviceBreakpoints.iPadAir) {
      return _scaleFontSize(context, mobileStyle ?? AppTypography.bodyMedium);
    }

    // Determine the appropriate style based on screen width for smaller screens
    if (screenWidth < 600) {
      // Mobile
      return _scaleFontSize(context, mobileStyle ?? AppTypography.bodyMedium);
    } else if (screenWidth < 1200) {
      // Tablet
      return _scaleFontSize(context, tabletStyle ?? AppTypography.bodyLarge);
    } else {
      // Desktop (for screens <= iPad Air but >= 1200)
      return _scaleFontSize(
          context, desktopStyle ?? AppTypography.displaySmall);
    }
  }

  TextStyle _scaleFontSize(BuildContext context, TextStyle baseStyle) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseFontSize = baseStyle.fontSize ?? 16;

    // For screens larger than iPad Air, use iPhone 16 Pro Max as reference
    if (screenWidth > DeviceBreakpoints.iPadAir) {
      // Use a fixed font size based on iPhone 16 Pro Max
      // No scaling for larger screens
      return baseStyle.copyWith(
        fontSize: baseFontSize,
      );
    }

    // For screens smaller than iPad Air, scale normally
    // Cap the screen width at iPad Air size
    screenWidth = screenWidth.clamp(
        DeviceBreakpoints.minScreenWidth, DeviceBreakpoints.iPadAir);

    // Calculate scaling factor
    double t = (screenWidth - DeviceBreakpoints.minScreenWidth) /
        (DeviceBreakpoints.maxScreenWidth - DeviceBreakpoints.minScreenWidth);
    t = t.clamp(0.0, 1.0);

    double scaledFontSize = baseFontSize * (1 + (0.2 * t));

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
