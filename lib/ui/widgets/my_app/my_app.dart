import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/ui/theme/app_theme.dart';

abstract class AppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
}

class MyApp extends StatelessWidget {
  final AppTheme appTheme;
  final AppNavigation appNavigation;

  const MyApp({
    Key? key,
    required this.appTheme,
    required this.appNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: appTheme.kLightMode,
      dark: appTheme.kDarkMode,
      initial: AdaptiveThemeMode.system,
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routes: appNavigation.routes,
      ),
    );
  }
}
