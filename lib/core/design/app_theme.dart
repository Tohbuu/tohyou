import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class TohyouTheme {
  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      surface: TohyouColors.surface,
      primary: TohyouColors.accent,
      secondary: TohyouColors.cyan,
      error: TohyouColors.error,
      onSurface: TohyouColors.textPrimary,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: TohyouColors.background,

      textTheme: const TextTheme(
        displaySmall: TohyouTypography.display,
        headlineSmall: TohyouTypography.headline,
        titleLarge: TohyouTypography.title,
        bodyMedium: TohyouTypography.body,
        bodyLarge: TohyouTypography.bodyStrong,
        labelMedium: TohyouTypography.label,
        bodySmall: TohyouTypography.caption,
      ),

      dividerTheme: const DividerThemeData(
        color: TohyouColors.surfaceHighlight,
        thickness: 1,
      ),

      splashFactory: InkSparkle.splashFactory,
    );
  }
}