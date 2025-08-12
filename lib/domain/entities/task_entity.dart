import 'package:todo/domain/enum/task_status.dart';

import '../seedWork/entity.dart';

class TaskEntity extends Entity{
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

  TaskEntity alterStatusCompleted(){
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      completed: !completed,
      createAt: createAt,
      updateAt: DateTime.now()
    );
  }

  TaskEntity alterTitle(String text){
    if(text.trim().isEmpty) throw Exception("O título não pode ser vazio");
    if(text.length > 20) throw Exception("O título não pode ter mais de 20 caracteres");

    return TaskEntity(
      id: id,
      title: text,
      description: description,
      completed: false,
      createAt: createAt,
      updateAt: DateTime.now()
    );
  }

  TaskEntity alterDescription(String text){
    if(text.trim().isEmpty) throw Exception("A descrição não pode ser vazia");

    return TaskEntity(
        id: id,
        title: title,
        description: text,
        completed: false,
        createAt: createAt,
        updateAt: DateTime.now()
    );
  }

}