import 'package:flutter/material.dart';
import 'package:work_order_app/config/theme/app_color.dart';
import 'package:work_order_app/config/theme/assets_path.dart';

abstract class AppStatelessWidget extends StatelessWidget {
  AppColor color(BuildContext ctx) => Theme.of(ctx).extension<AppColor>()!;
  TextTheme textTheme(BuildContext ctx) => Theme.of(ctx).textTheme;
  String assetsPath(BuildContext ctx) =>
      Theme.of(ctx).extension<AssetsPath>()!.path;

  const AppStatelessWidget({super.key});
}
