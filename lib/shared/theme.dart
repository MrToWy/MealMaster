import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

sealed class AppTheme {
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.indigoM3,
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.indigoM3,
  );
}

