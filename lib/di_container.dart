import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/ui/navigation/app_navigation_impl.dart';
import 'package:todo_list/ui/theme/app_theme.dart';
import 'package:todo_list/ui/widgets/my_app/my_app.dart';

final _di = GetIt.instance;

Widget makeApp() => MyApp(
      appTheme: _di<AppTheme>(),
      appNavigation: _di<AppNavigation>(),
    );

void init() {
  //Core
  _di.registerSingleton<ScreenFactory>(const ScreenFactoryImpl());
  _di.registerSingleton<AppNavigation>(AppNavigationImpl(_di<ScreenFactory>()));
  _di.registerSingleton<AppTheme>(const AppThemeImpl());
}

class ScreenFactoryImpl implements ScreenFactory {
  const ScreenFactoryImpl();

  @override
  Widget makeMainScreen() {
    return const SizedBox.shrink();
  }
}
