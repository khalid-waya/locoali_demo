import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';

class AppTheme {
  static _border([Color color = ColorPalette.fields]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorPalette.secondaryBackground,
  );
  static final lightThemeMode = ThemeData.light().copyWith(
      scaffoldBackgroundColor: ColorPalette.primaryBackground,
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(20),
          enabledBorder: _border(),
          focusedBorder: _border(ColorPalette.primary)));
}
