import 'package:flutter/material.dart';

class ColorPalette {
  // Brand Colors
  static const Color primary = Color(0xFF9489F5);
  static const Color secondary = Color(0xFF39D2C0);
  static const Color tertiary = Color(0xFF6D5FED);
  static const Color alternate = Color.fromARGB(0, 224, 227, 231);

  // Utility Colors
  static const Color primaryText = Color(0xFF101213);
  static const Color secondaryText = Color(0xFF57636C);
  static const Color primaryBackground = Color(0xFFF1F4F8);
  static const Color secondaryBackground = Color.fromRGBO(24, 24, 32, 1);
  static const Color borderColor = Color(0xFFE2E2E2);
  static const Color transparentColor = Colors.transparent;

  // Accent Colors
  static const Color accent1 = Color(0x4D9489F5);
  static const Color accent2 = Color(0x4E39D2C0);
  static const Color accent3 = Color(0x4D6D5FED);
  static const Color accent4 = Color(0xCCFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF24A891);
  static const Color error = Color(0xFFE74852);
  static const Color warning = Color(0xFFCA6C45);
  static const Color info = Color(0xFFFFFFFF);
  static const Color fields = Color(0xFF57636C);

  // Prevent instantiation
  ColorPalette._();
}
