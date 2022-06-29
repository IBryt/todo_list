import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/di_container.dart' as di;
import 'package:todo_list/ui/my_app/app_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  final myapp = const AppFactory();
  runApp(myapp);
}
