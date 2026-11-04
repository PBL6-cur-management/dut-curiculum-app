import 'package:flutter/material.dart';

class AppComponentTheme extends ThemeExtension<AppComponentTheme> {
  const AppComponentTheme();

  static bool isActive(BuildContext context) =>
      Theme.of(context).extension<AppComponentTheme>() != null;

  static bool usesLegacySheetStyle(BuildContext context) =>
      !isActive(context) && ModalRoute.of(context) is ModalBottomSheetRoute;

  @override
  AppComponentTheme copyWith() => this;

  @override
  AppComponentTheme lerp(covariant AppComponentTheme? other, double amount) =>
      this;
}
