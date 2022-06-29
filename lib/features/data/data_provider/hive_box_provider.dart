import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/data/models/task_model.dart';

abstract class HiveBoxProvider {
  void init();

  Future<Box<TaskModel>> openTasksBox();

  Future<void> closeBox(Box box);
}

class HiveBoxProviderImpl implements HiveBoxProvider {
  HiveBoxProviderImpl() {
    init();
  }

  @override
  void init() {
    Hive.registerAdapter(TaskModelAdapter());
  }

  @override
  Future<Box<TaskModel>> openTasksBox() async => _openBox('task_model_box');

  @override
  Future<void> closeBox(Box box) async {
    await box.flush();
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(String name) async => Hive.openBox<T>(name);
}
