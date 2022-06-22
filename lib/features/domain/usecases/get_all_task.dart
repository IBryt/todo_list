import 'package:dartz/dartz.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/core/usecases/usecase.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/domain/services/todo_service.dart';

class GetAllTask extends UseCase<List<TaskEntity>, void> {
  final TodoService todoService;

  GetAllTask(this.todoService);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(params) async {
    return await todoService.getAll();
  }
}
