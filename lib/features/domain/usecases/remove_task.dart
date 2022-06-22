import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/core/usecases/usecase.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/domain/services/todo_service.dart';

class RemoveTask extends UseCase<TaskEntity, RemoveTaskParams> {
  final TodoService todoService;

  RemoveTask(this.todoService);

  @override
  Future<Either<Failure, TaskEntity>> call(RemoveTaskParams params) async {
    return await todoService.remove(params.id);
  }
}

class RemoveTaskParams with EquatableMixin {
  final int id;

  const RemoveTaskParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
