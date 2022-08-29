import 'package:equatable/equatable.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_cubit.dart';

enum TaskStatus { initial, loading, loaded, failure }

class TodoState with EquatableMixin {
  final TaskStatus taskStatus;
  final List<TaskViewModel> taskList;
  final bool isAllowedAdd;
  final Failure? failure;
  final String validateMessage;

  const TodoState({
    this.taskStatus = TaskStatus.initial,
    this.taskList = const <TaskViewModel>[],
    this.isAllowedAdd = false,
    this.failure,
    this.validateMessage = '',
  });

  @override
  List<Object> get props =>
      [taskList, taskStatus, isAllowedAdd, validateMessage];

  TodoState copyWith({
    TaskStatus? taskStatus,
    List<TaskViewModel>? taskList,
    bool? isAllowedAdd,
    Failure? failure,
    String? validateMessage,
  }) {
    return TodoState(
      taskStatus: taskStatus ?? this.taskStatus,
      taskList: taskList ?? this.taskList,
      isAllowedAdd: isAllowedAdd ?? this.isAllowedAdd,
      failure: failure ?? this.failure,
      validateMessage: validateMessage ?? this.validateMessage,
    );
  }
}
