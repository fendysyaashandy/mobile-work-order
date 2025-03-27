import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  final Map<int, Color> primary;
  final Map<int, Color> foreground;
  final Map<int, Color> background;
  final Map<int, Color> status;
  final Color success;
  final Color warning;
  final Color control;
  final Color danger;

  AppColor({
    required this.primary,
    required this.foreground,
    required this.background,
    required this.status,
    required this.success,
    required this.warning,
    required this.control,
    required this.danger,
  });

  @override
  AppColor copyWith({
    Map<int, Color>? primary,
    Map<int, Color>? foreground,
    Map<int, Color>? background,
    Map<int, Color>? status,
    Color? success,
    Color? warning,
    Color? control,
    Color? danger,
  }) {
    return AppColor(
      primary: primary ?? this.primary,
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      status: status ?? this.status,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      control: control ?? this.control,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<AppColor> lerp(AppColor? other, double t) {
    if (other == null) return this;
    return copyWith(
      primary: lerpColorMap(primary, other.primary, t),
      foreground: lerpColorMap(foreground, other.foreground, t),
      background: lerpColorMap(background, other.background, t),
      status: lerpColorMap(status, other.status, t),
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      control: Color.lerp(control, other.control, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }

  Map<int, Color> lerpColorMap(Map<int, Color> a, Map<int, Color> b, double t) {
    final Map<int, Color> result = {};
    for (final key in a.keys) {
      result[key] = Color.lerp(a[key], b[key], t)!;
    }
    return result;
  }
}
