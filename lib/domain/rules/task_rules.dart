import 'package:todo/domain/entities/task_entity.dart';

class TaskRules extends TaskEntity {
  TaskRules({
    required super.id,
    required super.title,
    required super.completed,
    required super.createAt,
    super.description,
    super.updateAt
  });

  TaskEntity save(){
    textNotIsNull(title, error: "O título não pode ser vazio");
    textIsLessThan20Characters(title, error: "O título não pode ter mais de 20 caracteres");
    textNotIsNull(description, error: "O título não pode ser vazio");

    return TaskEntity(
        id: id,
        title: title,
        description: description,
        completed: false,
        createAt: createAt,
    );
  }

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
    textNotIsNull(text, error: "O título não pode ser vazio");
    textIsLessThan20Characters(text, error: "O título não pode ter mais de 20 caracteres");

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
    textNotIsNull(text, error: "A descrição não pode ser vazia");

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