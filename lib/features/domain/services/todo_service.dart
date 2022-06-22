import 'package:dartz/dartz.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';

abstract class TodoService {
  Future<Either<Failure, List<TaskEntity>>> getAll();

  Future<Either<Failure, TaskEntity>> add(TaskEntity task);

  Future<Either<Failure, void>> remove(int id);
}
