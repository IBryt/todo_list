import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/core/usecases/usecase.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/domain/services/todo_service.dart';

class AddTask extends UseCase<TaskEntity, AddTaskParams> {
  final TodoService todoService;

  AddTask(this.todoService);

  @override
  Future<Either<Failure, TaskEntity>> call(AddTaskParams params) async {
    return await todoService.add(params.task);
  }
}

class AddTaskParams with EquatableMixin {
  final TaskEntity task;

  const AddTaskParams({
    required this.task,
  });

  @override
  List<Object> get props => [task];
}
