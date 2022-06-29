import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:todo_list/core/error/failure_handler.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_cubit.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_state.dart';
import 'package:todo_list/generated/l10n.dart';
import 'package:todo_list/ui/theme/app_colors.dart';
import 'package:todo_list/ui/theme/app_theme.dart';
import 'package:todo_list/ui/widgets/add_widget.dart';
import 'package:todo_list/ui/widgets/display_snack_bar.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).todo_app_bar_title),
        actions: const [
          _IconToggleThemeWidget(),
        ],
      ),
      body: Column(
        children: const [
          _HeaderWidget(),
          _TodoListWidget(),
        ],
      ),
    );
  }
}

class _IconToggleThemeWidget extends StatelessWidget {
  const _IconToggleThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeListenableBuilder(
      builder: (context, theme) => IconButton(
        onPressed: () => theme.toggle(context),
        icon: Icon(
          theme.isLight ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
        left: 30.0,
        top: 30.0,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).todo_header,
                style: theme.textTheme.headline2,
              ),
              const Spacer(),
              const _ButtonAddWidget(),
            ],
          ),
          ThemeListenableBuilder(
            builder: (context, theme) => Divider(
              color: theme.isLight
                  ? AppColors.lightDivider
                  : AppColors.darkDivider,
            ),
          ),
          BlocBuilder<TodoCubit, TodoState>(
            buildWhen: (previous, current) =>
                previous.isAllowedAdd != current.isAllowedAdd,
            builder: (context, state) {
              return state.isAllowedAdd
                  ? const _InputTaskTextFieldWidget()
                  : const SizedBox.shrink();
            },
          ),
          BlocBuilder<TodoCubit, TodoState>(
            buildWhen: (previous, current) =>
                previous.validateMessage != current.validateMessage,
            builder: (context, state) {
              return Text(
                state.validateMessage,
                style: theme.textTheme.subtitle2?.copyWith(
                  color: theme.errorColor,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _ButtonAddWidget extends StatelessWidget {
  const _ButtonAddWidget({
    Key? key,
  }) : super(key: key);

  void _onTap(TodoCubit cubit, bool isKeyboardVisible) {
    !isKeyboardVisible
        ? cubit.toggleAllowedAdd()
        : FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final borderRadius = const BorderRadius.all(Radius.circular(6));
    const sideLength = 56.0;
    return ThemeListenableBuilder(
      builder: (context, theme) => SizedBox(
        height: sideLength,
        width: sideLength,
        child: Stack(
          children: [
            Container(
              height: sideLength,
              width: sideLength,
              decoration: BoxDecoration(
                color: theme.isLight
                    ? AppColors.lightBackgroundButton
                    : AppColors.darkBackgroundButton,
                borderRadius: borderRadius,
                border: Border.all(
                    width: 1,
                    color: theme.isLight
                        ? AppColors.lightBorderButton
                        : AppColors.darkBorderButton),
              ),
              child: const AddWidget(
                size: 24.0,
                color: AppColors.iconButton,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: KeyboardVisibilityBuilder(
                builder: (context, isKeyboardVisible) {
                  return InkWell(
                    splashColor: Colors.green.withOpacity(0.3),
                    highlightColor: Colors.green.withOpacity(0.1),
                    borderRadius: borderRadius,
                    onTap: () => _onTap(todoCubit, isKeyboardVisible),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputTaskTextFieldWidget extends StatefulWidget {
  const _InputTaskTextFieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_InputTaskTextFieldWidget> createState() =>
      _InputTaskTextFieldWidgetState();
}

class _InputTaskTextFieldWidgetState extends State<_InputTaskTextFieldWidget> {
  late StreamSubscription<bool> keyboardSubscription;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final todoCubit = context.read<TodoCubit>();
    final keyboardVisibilityController = KeyboardVisibilityController();
    controller = TextEditingController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen(
      (bool visible) {
        if (!visible) {
          _onSaved(todoCubit);
        }
      },
    );
  }

  void _onSaved(TodoCubit todoCubit) {
    final taskText = controller.text.trim();
    final errorMessage = _validator(taskText);
    errorMessage == null
        ? todoCubit.add(taskText)
        : todoCubit.addErrorMessage(errorMessage);
    todoCubit.toggleAllowedAdd();
  }

  String? _validator(String value) {
    if (value.trim().isEmpty) {
      return S.of(context).error_message_empty_task;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return TextField(
      keyboardType: TextInputType.text,
      maxLines: null,
      textInputAction: TextInputAction.done,
      autofocus: true,
      controller: controller,
      onSubmitted: (value) => _onSaved(todoCubit),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }
}

class _TodoListWidget extends StatelessWidget {
  const _TodoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return BlocBuilder<TodoCubit, TodoState>(
      buildWhen: (previous, current) =>
          current.taskStatus == TaskStatus.loaded &&
          !identical(current.taskList, previous.taskList),
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: state.taskList.length,
            shrinkWrap: false,
            dragStartBehavior: DragStartBehavior.down,
            itemBuilder: (context, index) {
              final _index = state.taskList.length - 1 - index;
              final taskModel = state.taskList[_index];
              return TaskListRowWidget(
                todoCubit: todoCubit,
                taskModel: taskModel,
              );
            },
          ),
        );
      },
    );
  }
}

class TaskListRowWidget extends StatelessWidget {
  final TodoCubit todoCubit;
  final TaskViewModel taskModel;

  const TaskListRowWidget({
    Key? key,
    required this.todoCubit,
    required this.taskModel,
  }) : super(key: key);

  Future<bool> test() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        confirmDismiss: (direction) async {
          await todoCubit.remove(taskModel.task.id);
          _displayError(todoCubit, context);
          return !todoCubit.isFailure;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                _CheckBoxListViewWidget(
                    task: taskModel.task, todoCubit: todoCubit),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    taskModel.task.text,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        background: ColoredBox(
          color: Colors.red,
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBoxListViewWidget extends StatelessWidget {
  final TaskEntity task;
  final TodoCubit todoCubit;

  const _CheckBoxListViewWidget({
    Key? key,
    required this.task,
    required this.todoCubit,
  }) : super(key: key);

  void _onChanged(bool? isDone) {
    if (isDone != null) {
      todoCubit.changeDone(isDone, task.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideLength = 24.0;
    return ThemeListenableBuilder(
      builder: (context, theme) {
        return Container(
          height: sideLength,
          width: sideLength,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              transform: const GradientRotation(180),
              colors: [
                theme.isLight
                    ? AppColors.lightGradientStart
                    : AppColors.darkGradientStart,
                theme.isLight
                    ? AppColors.lightGradientEnd
                    : AppColors.darkGradientEnd,
              ],
            ),
          ),
          child: Transform.scale(
            scale: sideLength / Checkbox.width,
            child: Checkbox(
              value: task.isDone,
              onChanged: _onChanged,
            ),
          ),
        );
      },
    );
  }
}

void _displayError(TodoCubit todoCubit, BuildContext context) {
  if (todoCubit.isFailure) {
    final errorMessage =
        FailureHandler.getMessage(context, todoCubit.state.failure);
    displaySnackBar(context, errorMessage);
  }
}
