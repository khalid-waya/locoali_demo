import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: ColorPalette.secondaryBackground,
     );
  static final lightThemeMode = ThemeData.light()
      .copyWith(scaffoldBackgroundColor: ColorPalette.primaryBackground);
}
