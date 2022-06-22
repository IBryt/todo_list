import 'package:equatable/equatable.dart';

class TaskEntity with EquatableMixin {
  final String text;
  final bool isDone;

  TaskEntity({
    required this.text,
    required this.isDone,
  });

  @override
  List<Object?> get props => [text, isDone];
}
