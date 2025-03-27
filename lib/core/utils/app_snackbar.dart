import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:work_order_app/config/theme/app_color.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:work_order_app/core/widget/app_count_down.dart';

class AppSnackbar {
  static final List<GlobalKey<ScaffoldMessengerState>> scaffoldMessengerKeys =
      [];

  static Flushbar? _snackbar;

  static late ThemeData _theme;

  static void setTheme(ThemeData theme) {
    _theme = theme;
  }

  static AppColor get _color => _theme.extension<AppColor>()!;

  static void showError(String message) {
    _showIcon(Iconsax.info_circle, message, _color.danger);
  }

  static void showSuccess(String message) {
    _showIcon(Iconsax.tick_circle, message, _color.success);
  }

  static void showWarning(String message) {
    _showIcon(Iconsax.info_circle, message, _color.warning);
  }

  static void showInfo(String message) {
    _showIcon(Iconsax.info_circle, message, _color.control);
  }

  static Future<void> _showIcon(
      IconData icon, String message, Color color) async {
    _snackbar?.dismiss(false);
    _snackbar = Flushbar<bool?>(
      icon: Icon(icon, color: color),
      padding: const EdgeInsets.all(12),
      messageColor: _color.foreground[900],
      borderColor: color,
      message: message,
      backgroundColor: _color.background[100]!,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(10),
    );
    if (scaffoldMessengerKeys.isEmpty) return;
    await _snackbar?.show(scaffoldMessengerKeys.last.currentContext!);
  }

  static Future<bool?> showUndo(String message) async {
    if (_snackbar != null) {
      _snackbar!.dismiss(false);
      await Future.delayed(const Duration(milliseconds: 400));
    }
    _snackbar = Flushbar<bool?>(
      icon: const AppCountDown(duration: Duration(seconds: 3)),
      padding: const EdgeInsets.all(12),
      messageColor: _color.foreground[900],
      borderColor: _color.primary[500]!,
      message: message,
      backgroundColor: _color.background[100]!,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(10),
      mainButton: TextButton(
        onPressed: () => _snackbar!.dismiss(true),
        child: Text('Undo', style: TextStyle(color: _color.primary[500])),
      ),
    );

    if (scaffoldMessengerKeys.isEmpty) return false;

    return (await _snackbar!.show(scaffoldMessengerKeys.last.currentContext!))
        as bool?;
  }
}
