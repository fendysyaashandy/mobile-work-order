import 'package:flutter/material.dart';
import 'package:work_order_app/config/theme/app_color.dart';
import 'package:work_order_app/config/theme/assets_path.dart';
import 'package:work_order_app/config/theme/color_data.dart';

class ThemeManager {
  static final ThemeData theme = AppTheme(
    color: ColorData.defaultColor,
    assetsPath: "assets",
  ).theme;
}

class AppTheme {
  final AppColor color;
  final String assetsPath;

  AppTheme({
    required this.color,
    required this.assetsPath,
  });

  ThemeData get theme => ThemeData(
        extensions: <ThemeExtension<dynamic>>[
          AssetsPath(assetsPath),
          color,
        ],
        inputDecorationTheme: inputDecorationTheme,
        elevatedButtonTheme: elevatedButtonThemeData,
        textTheme: textTheme,
      );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.primary[500]!,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.danger,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: color.danger,
          ),
        ),
      );

  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color.primary[500]),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
          foregroundColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return color.foreground[400]!.withValues(
                red: 0.5,
                green: 0.5,
                blue: 0.5,
              );
            }
            return color.background[100]!.withValues(
              red: 0.5,
              green: 0.5,
              blue: 0.5,
            );
          }),
        ),
      );

  TextStyle textStyle({
    required double fontSize,
    required Color color,
    required double letterSpacing,
  }) {
    return TextStyle(
      color: color,
      decoration: TextDecoration.none,
      fontFamily: 'Roboto',
      fontSize: fontSize,
      inherit: false,
      letterSpacing: letterSpacing,
      textBaseline: TextBaseline.alphabetic,
    );
  }

  TextTheme get textTheme => TextTheme(
        displayLarge: textStyle(
          color: color.foreground[100]!,
          fontSize: 24,
          letterSpacing: -1.5,
        ),
        displayMedium: textStyle(
          color: color.foreground[900]!,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
        displaySmall: textStyle(
          color: color.foreground[900]!,
          fontSize: 18,
          letterSpacing: -0.5,
        ),
        headlineLarge: textStyle(
          color: color.foreground[900]!,
          fontSize: 18,
          letterSpacing: 0.25,
        ),
        headlineMedium: textStyle(
          color: color.foreground[100]!,
          fontSize: 16,
          letterSpacing: 0.25,
        ),
        headlineSmall: textStyle(
          color: color.foreground[100]!,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        titleLarge: textStyle(
          color: color.foreground[900]!,
          fontSize: 16,
          letterSpacing: 0.15,
        ),
        titleMedium: textStyle(
          color: color.foreground[100]!,
          fontSize: 14,
          letterSpacing: 0.15,
        ),
        titleSmall: textStyle(
          color: color.foreground[100]!,
          fontSize: 12,
          letterSpacing: 0.1,
        ),
        bodyLarge: textStyle(
          color: color.foreground[100]!,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        bodyMedium: textStyle(
          color: color.foreground[100]!,
          fontSize: 12,
          letterSpacing: 0.25,
        ),
        bodySmall: textStyle(
          color: color.foreground[100]!,
          fontSize: 12,
          letterSpacing: 0.4,
        ),
        labelLarge: textStyle(
          color: color.foreground[100]!,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        labelMedium: textStyle(
          color: color.foreground[100]!,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
        labelSmall: textStyle(
          color: color.foreground[100]!,
          fontSize: 10,
          letterSpacing: 1.5,
        ),
      );
}
