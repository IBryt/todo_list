import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  const AppTheme();

  ThemeData get kDarkMode;

  ThemeData get kLightMode;

  void toggle(BuildContext context);
}

class AppThemeImpl implements AppTheme {
  const AppThemeImpl();

  @override
  ThemeData get kDarkMode => ThemeData.dark().copyWith();

  @override
  ThemeData get kLightMode => ThemeData.light().copyWith();

  @override
  void toggle(BuildContext context) {
    final theme = AdaptiveTheme.of(context);
    theme.brightness == Brightness.light ? theme.setDark() : theme.setLight();
  }
}
