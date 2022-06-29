import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/data/data_provider/hive_box_provider.dart';
import 'package:todo_list/features/data/models/task_model.dart';

abstract class TaskHiveDataSources {
  Future<List<TaskModel>> getAll();

  Future<int> add(TaskModel task);

  Future<void> remove(int id);

  Future<void> update(int id, TaskModel task);

  Future<void> close();
}

class TaskHiveDataSourcesImpl implements TaskHiveDataSources {
  final HiveBoxProvider hiveBoxProvider;

  Future<Box<TaskModel>>? _taskBox;

  TaskHiveDataSourcesImpl({
    required this.hiveBoxProvider,
  });

  Future<Box<TaskModel>> get _box {
    _taskBox ??= hiveBoxProvider.openTasksBox();
    return _taskBox!;
  }

  @override
  Future<int> add(TaskModel task) async {
    return (await _box).add(task);
  }

  @override
  Future<List<TaskModel>> getAll() async {
    return (await _box).values.toList();
  }

  @override
  Future<void> remove(int id) async {
    return (await _box).delete(id);
  }

  @override
  Future<void> update(int id, TaskModel task) async {
    (await _box).put(id, task);
  }

  @override
  Future<void> close() async {
    await hiveBoxProvider.closeBox((await _box));
    _taskBox = null;
  }
}
