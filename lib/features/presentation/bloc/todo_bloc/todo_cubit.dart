import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list/core/error/failure.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/domain/repository/todo_repository.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_state.dart';

class TaskViewModel with EquatableMixin {
  final TaskEntity task;
  final bool isUpdate;

  TaskViewModel({
    required this.task,
    required this.isUpdate,
  });

  const TaskViewModel.empty()
      : task = const TaskEntity.empty(),
        isUpdate = false;

  @override
  List<Object?> get props => [task, isUpdate];

  TaskViewModel copyWith({
    TaskEntity? task,
    bool? isUpdate,
  }) {
    return TaskViewModel(
      task: task ?? this.task,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }
}

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository todoRepository;

  TodoCubit({
    required this.todoRepository,
  }) : super(const TodoState());

  bool get isFailure => state.taskStatus == TaskStatus.failure;

  Future<void> loading() async {
    final tasks = await todoRepository.getAll();
    tasks.fold(
      (failure) => _setErrorState(failure),
      (listTasks) {
        final newList =
            listTasks.map((task) => TaskViewModel(task: task, isUpdate: false));
        emit(
          state.copyWith(
            taskStatus: TaskStatus.loaded,
            taskList: List.unmodifiable(newList),
          ),
        );
      },
    );
  }

  Future<void> add(String text) async {
    emit(state.copyWith(taskStatus: TaskStatus.loading));
    final task = TaskEntity(id: 0, text: text, isDone: false);

    final result = await todoRepository.add(task);
    result.fold(
      (failure) => _setErrorState(failure),
      (task) {
        final newList = state.taskList.toList();
        newList.add(TaskViewModel(task: task, isUpdate: false));
        emit(
          state.copyWith(
            taskStatus: TaskStatus.loaded,
            validateMessage: '',
            taskList: List.unmodifiable(newList),
          ),
        );
      },
    );
  }

  Future<void> remove(int id) async {
    if (_isUpdate(id)) {
      return;
    }
    emit(state.copyWith(taskStatus: TaskStatus.loading));
    final result = await todoRepository.remove(id);
    return result.fold(
      (failure) => _setErrorState(failure),
      (result) {
        final newList = state.taskList.toList();
        newList.removeWhere((taskModel) => taskModel.task.id == id);
        emit(
          state.copyWith(
            taskStatus: TaskStatus.loaded,
            taskList: List.unmodifiable(newList),
          ),
        );
      },
    );
  }

  Future<void> changeDone(bool isDone, int id) async {
    if (_isUpdate(id)) {
      return;
    }
    _emitTaskIsUpdate(id);

    //++update
    final task =
        state.taskList[_getIndexById(id)].task.copyWith(isDone: isDone);
    await todoRepository.update(task);

    //--update
    final index = _getIndexById(id);
    final newList = state.taskList.toList();
    newList[index] = TaskViewModel(isUpdate: false, task: task);
    emit(state.copyWith(
        taskStatus: TaskStatus.loaded, taskList: List.unmodifiable(newList)));
  }

  void addErrorMessage(String errorMessage) {
    emit(
      state.copyWith(
        validateMessage: errorMessage,
      ),
    );
  }

  void toggleAllowedAdd() async {
    final isAllowedAdd = !state.isAllowedAdd;
    emit(state.copyWith(isAllowedAdd: isAllowedAdd));
  }

  @override
  Future<void> close() async {
    todoRepository.close();
    return super.close();
  }

  void _emitTaskIsUpdate(int id) {
    final index = _getIndexById(id);
    emit(
      state.copyWith(
        taskStatus: TaskStatus.loading,
        taskList: _setTaskIsUpdate(index, true),
      ),
    );
  }

  bool _isUpdate(int id) {
    final index = _getIndexById(id);
    final taskModel = state.taskList[index];
    return taskModel.isUpdate;
  }

  List<TaskViewModel> _setTaskIsUpdate(int index, bool isUpdate) {
    final newList = state.taskList.toList();
    newList[index] = newList[index].copyWith(isUpdate: isUpdate);
    return List.unmodifiable(newList);
  }

  int _getIndexById(int id) =>
      state.taskList.indexWhere((taskModel) => taskModel.task.id == id);

  void _setErrorState(Failure failure) {
    final newState = state.copyWith(
      taskStatus: TaskStatus.failure,
      failure: failure,
    );
    emit(newState);
  }
}
