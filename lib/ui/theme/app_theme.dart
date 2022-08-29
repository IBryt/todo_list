import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/theme/app_colors.dart';

abstract class AppTheme {
  const AppTheme();

  Future<void> init();

  ThemeData get kDarkMode;

  ThemeData get kLightMode;

  bool get isLight;

  void toggle(BuildContext context);
}

class AppThemeImpl implements AppTheme {
  late bool _isLight;

  AppThemeImpl();

  @override
  ThemeData get kDarkMode => ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          color: AppColors.darkAppBar,
        ),
        scaffoldBackgroundColor: AppColors.darkScaffold,
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline2: const TextStyle(
                fontSize: 56.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              subtitle1: const TextStyle(
                color: Color(0xFFDADADA),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              subtitle2: const TextStyle(
                fontSize: 14,
              ),
              bodyText2: const TextStyle(
                color: Color(0xFFDADADA),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFF0E0E11)),
          checkColor: MaterialStateProperty.all(const Color(0xFFDADADA)),
          side: const BorderSide(
            width: 2,
            color: Color(0xFF0E0E11),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );

  @override
  ThemeData get kLightMode => ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: AppColors.lightScaffold,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline2: const TextStyle(
                fontSize: 56.0,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              subtitle1: const TextStyle(
                color: Color(0xFF575767),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              subtitle2: const TextStyle(
                fontSize: 14,
              ),
              bodyText2: const TextStyle(
                color: Color(0xFF575767),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFFDADADA)),
          checkColor: MaterialStateProperty.all(Colors.white),
          side: const BorderSide(
            width: 2,
            color: Color(0xFFDADADA),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );

  @override
  bool get isLight => _isLight;

  @override
  Future<void> init() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    final mode = savedThemeMode ?? AdaptiveThemeMode.light;
    _isLight = mode == AdaptiveThemeMode.light;
  }

  @override
  void toggle(BuildContext context) {
    final theme = AdaptiveTheme.of(context);
    _isLight = !_isLight;
    theme.brightness == Brightness.light
        ? theme.toggleThemeMode()
        : theme.setLight();
  }
}

typedef ThemeBuilder = Widget Function(
  BuildContext context,
  AppTheme theme,
);

class ThemeListenableBuilder extends StatelessWidget {
  final ThemeBuilder builder;

  const ThemeListenableBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = context.read<AppTheme>();
    return ValueListenableBuilder(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (context, mode, child) => builder(context, appTheme),
    );
  }
}
