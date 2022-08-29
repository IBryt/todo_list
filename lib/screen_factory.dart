import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list/features/presentation/bloc/todo_bloc/todo_cubit.dart';
import 'package:todo_list/features/presentation/pages/todo_screen.dart';

abstract class ScreenFactory {
  Widget makeMainScreen();
}

final _di = GetIt.instance;

class ScreenFactoryImpl implements ScreenFactory {
  const ScreenFactoryImpl();

  @override
  Widget makeMainScreen() {
    return BlocProvider<TodoCubit>(
      create: (context) => _di<TodoCubit>()..loading(),
      child: const TodoScreen(),
    );
  }
}
