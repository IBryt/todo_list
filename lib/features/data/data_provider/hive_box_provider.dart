import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/data/models/task_model.dart';

abstract class HiveBoxProvider {
  Future<Box<TaskModel>> openTasksBox();
}

class HiveBoxProviderImpl implements HiveBoxProvider {
  const HiveBoxProviderImpl();

  @override
  Future<Box<TaskModel>> openTasksBox() async =>
      _openBox('task_model_box', 0, TaskModelAdapter());

  Future<Box<T>> _openBox<T>(
    String name,
    int typeId,
    TypeAdapter<T> adapter,
  ) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    final box = Hive.openBox<T>(name);
    return box;
  }
}
