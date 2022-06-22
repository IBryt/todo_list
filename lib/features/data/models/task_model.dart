import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/features/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel with EquatableMixin, HiveObjectMixin {
  @HiveField(0)
  String text;
  @HiveField(1)
  bool isDone;

  TaskModel({
    required this.text,
    required this.isDone,
  });

  @override
  List<Object?> get props => [text, isDone];

  TaskEntity toEntity() {
    return TaskEntity(
      id: key as int,
      text: text,
      isDone: isDone,
    );
  }
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(isDone: entity.isDone, text: entity.text);
  }
}
