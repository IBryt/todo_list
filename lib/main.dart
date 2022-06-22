import 'package:flutter/material.dart';
import 'package:todo_list/di_container.dart' as di;

void main() {
  di.init();
  final myapp = di.makeApp();
  runApp(myapp);
}
