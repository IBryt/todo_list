import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/ui/my_app/my_app.dart';
import 'package:todo_list/ui/navigation/app_navigation_impl.dart';
import 'package:todo_list/ui/theme/app_theme.dart';

class AppFactory extends StatelessWidget {
  const AppFactory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final di = GetIt.instance;

    return Provider<AppTheme>(
      create: (_) => di<AppTheme>(),
      child: MyApp(
        appNavigation: di<AppNavigation>(),
      ),
    );
  }
}
