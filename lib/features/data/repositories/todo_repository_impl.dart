import 'package:dartz/dartz.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/features/data/datasources/task_hive_data_sources.dart';
import 'package:todo_list/features/data/models/task_model.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TaskHiveDataSources taskHiveDataSources;

  TodoRepositoryImpl({
    required this.taskHiveDataSources,
  });

  @override
  Future<Either<Failure, TaskEntity>> add(TaskEntity task) async {
    return _wrapperEither(() async {
      final id = await taskHiveDataSources.add(TaskModel.fromEntity(task));
      return task.copyWith(id: id);
    });
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getAll() async {
    return _wrapperEither(() async {
      final listTaskEntity = (await taskHiveDataSources.getAll())
          .map((TaskModel e) => e.toEntity())
          .toList();
      return listTaskEntity;
    });
  }

  @override
  Future<Either<Failure, void>> remove(int id) async {
    return _wrapperEither(() async {
      await taskHiveDataSources.remove(id);
    });
  }

  @override
  Future<Either<Failure, void>> update(TaskEntity task) {
    return _wrapperEither(() async {
      await taskHiveDataSources.update(task.id, TaskModel.fromEntity(task));
    });
  }

  Future<Either<Failure, T>> _wrapperEither<T>(
      Future<T> Function() func) async {
    try {
      final value = await func();
      return Right(value);
    } on Exception {
      return Left(HiveFailure());
    }
  }

  @override
  Future<void> close() async {
    await taskHiveDataSources.close();
  }
}
