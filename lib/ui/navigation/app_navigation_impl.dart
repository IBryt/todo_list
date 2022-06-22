import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/app_route_names.dart';
import 'package:todo_list/ui/widgets/my_app/my_app.dart';

abstract class ScreenFactory {
  Widget makeMainScreen();
}

class AppNavigationImpl implements AppNavigation {
  final ScreenFactory screenFactory;

  const AppNavigationImpl(this.screenFactory);

  @override
  Map<String, Widget Function(BuildContext)> get routes => {
        AppRouteNames.root: (_) => screenFactory.makeMainScreen(),
      };
}
