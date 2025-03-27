import 'package:flutter/material.dart';

class AssetsPath extends ThemeExtension<AssetsPath> {
  final String path;

  AssetsPath(this.path);

  @override
  AssetsPath copyWith({String? path}) {
    return AssetsPath(path ?? this.path);
  }

  @override
  AssetsPath lerp(AssetsPath? other, double t) {
    return AssetsPath(path);
  }
}
