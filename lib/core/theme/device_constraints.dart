import 'package:flutter/widgets.dart';

class DeviceBreakpoints {
  static const double iphoneProMax = 430.0; // iPhone 16 Pro Max width
  static const double iPadAir = 1180.0; // iPad Air 13" width
  static const double minScreenWidth = 375.0;
  static const double maxScreenWidth = iPadAir; // Cap at iPad Air size

  /// Returns a responsive dimension that scales with screen size but caps at iPad Air size
  /// For screens larger than iPad Air, it will use iPhone 16 Pro Max dimensions
  static double getResponsiveDimension(BuildContext context, double dimension) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For screens smaller than iPad Air, scale normally
    if (screenWidth <= iPadAir) {
      return dimension;
    }
    // For screens larger than iPad Air, use iPhone 16 Pro Max as reference
    else {
      // Scale based on iPhone 16 Pro Max width
      return (dimension / screenWidth) * iphoneProMax;
    }
  }

  /// Returns a responsive size that scales with screen width but caps appropriately
  static double getResponsiveWidth(BuildContext context, double percentage) {
    final screenWidth = MediaQuery.of(context).size.width;

    // For screens smaller than iPad Air, scale normally
    if (screenWidth <= iPadAir) {
      return screenWidth * percentage;
    }
    // For screens larger than iPad Air, use iPhone 16 Pro Max as reference
    else {
      return iphoneProMax * percentage;
    }
  }

  /// Returns a responsive height that scales with screen height but caps appropriately
  static double getResponsiveHeight(BuildContext context, double percentage) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // For screens smaller than iPad Air, scale normally
    if (screenWidth <= iPadAir) {
      return screenHeight * percentage;
    }
    // For screens larger than iPad Air, scale down proportionally
    else {
      // Use a proportional scaling factor based on width ratio
      double scaleFactor = iphoneProMax / screenWidth;
      return screenHeight * percentage * scaleFactor;
    }
  }
}
