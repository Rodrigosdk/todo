import '../seedWork/entity.dart';

class TaskEntity extends Entity {
  final String title;
  final String? description;
  final bool completed;

  TaskEntity({
    required super.id,
    required this.title,
    required this.completed,
    required super.createAt,
    this.description,
    super.updateAt
  });

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createAt,
    DateTime? updateAt,
  }){
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt
    );
  }
}