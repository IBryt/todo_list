import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/ui/navigation/app_navigation_impl.dart';
import 'package:todo_list/ui/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final AppNavigation appNavigation;

  const MyApp({
    Key? key,
    required this.appNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();

    return AdaptiveTheme(
      light: appTheme.kLightMode,
      dark: appTheme.kDarkMode,
      initial:
          appTheme.isLight ? AdaptiveThemeMode.light : AdaptiveThemeMode.dark,
      builder: (theme, dark) => MaterialApp(
        theme: theme,
        darkTheme: dark,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        initialRoute: appNavigation.initialRoute,
        routes: appNavigation.routes,
      ),
    );
  }
}
