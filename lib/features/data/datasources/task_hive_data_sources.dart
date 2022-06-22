import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/data/data_provider/hive_box_provider.dart';
import 'package:todo_list/features/data/models/task_model.dart';

abstract class TaskHiveDataSources {
  Future<List<TaskModel>> getAll();

  Future<int> add(TaskModel task);

  Future<void> remove(int id);
}

class TaskHiveDataSourcesImpl implements TaskHiveDataSources {
  final HiveBoxProvider hiveBoxProvider;

  TaskHiveDataSourcesImpl(this.hiveBoxProvider);

  @override
  Future<int> add(TaskModel task) async {
    return await _wrapperOperation<Future<int>>(
      hiveBoxProvider.openTasksBox(),
      (box) async => await box.add(task),
    );
  }

  @override
  Future<List<TaskModel>> getAll() async {
    return _wrapperOperation<List<TaskModel>>(
      hiveBoxProvider.openTasksBox(),
      (box) => box.values.toList() as List<TaskModel>,
    );
  }

  @override
  Future<void> remove(int id) async {
    return _wrapperOperation<void>(
      hiveBoxProvider.openTasksBox(),
      (box) async => await box.delete(id),
    );
  }

  Future<T> _wrapperOperation<T>(
      Future<Box<TaskModel>> box, T Function(Box box) function) async {
    final _box = await box;
    final result = function(_box);
    _box.close();
    return result;
  }
}
