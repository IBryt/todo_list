import 'package:equatable/equatable.dart';

class TaskEntity with EquatableMixin {
  final int id;
  final String text;
  final bool isDone;

  TaskEntity({
    required this.id,
    required this.text,
    required this.isDone,
  });

  const TaskEntity.empty()
      : id = 0,
        text = '',
        isDone = false;

  @override
  List<Object?> get props => [id, text, isDone];

  TaskEntity copyWith({
    int? id,
    String? text,
    bool? isDone,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
    );
  }
}
