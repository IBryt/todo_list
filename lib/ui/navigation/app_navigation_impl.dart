import 'package:flutter/material.dart';
import 'package:todo_list/screen_factory.dart';
import 'package:todo_list/ui/navigation/app_route_names.dart';

abstract class AppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;

  String get initialRoute;
}

class AppNavigationImpl implements AppNavigation {
  final ScreenFactory screenFactory;

  const AppNavigationImpl({
    required this.screenFactory,
  });
  @override
  String get initialRoute => AppRouteNames.root;

  @override
  Map<String, Widget Function(BuildContext)> get routes => {
        AppRouteNames.root: (_) => screenFactory.makeMainScreen(),
      };
}
