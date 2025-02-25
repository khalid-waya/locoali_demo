import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';

class AppTheme {
  static _border([Color color = ColorPalette.fields]) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 1),
        borderRadius: BorderRadius.circular(10),
      );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorPalette.secondaryBackground,
  );
  static final lightThemeMode = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette.primaryBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ColorPalette.primary,
          
        ),
        
      ),
      scaffoldBackgroundColor: ColorPalette.primaryBackground,
      shadowColor: ColorPalette.transparentColor,

      inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(20),
          enabledBorder: _border(),
          focusedBorder: _border(ColorPalette.primary)));
           
}
