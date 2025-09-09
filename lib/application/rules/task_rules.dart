import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/shared/validation/validating_task_information.dart';

class TaskRules with ValidatingTaskInformation {
  final int? id;
  final String title;
  final String? description;
  final bool? completed;
  final DateTime? createAt;
  final DateTime? updateAt;
  
  
  TaskRules({
    this.id,
    required this.title,
    this.completed,
    this.createAt,
    this.description,
    this.updateAt
  });

  TaskEntity save(){
    textNotIsNull(title, error: "O título não pode ser vazio");
    textIsLessThan20Characters(title, error: "O título não pode ter mais de 20 caracteres");

    return TaskEntity(
        id: id ?? 0,
        title: title,
        description: description,
        completed: false,
        createAt: DateTime.now(),
    );
  }

  TaskEntity alterStatusCompleted(){
    dataTimeNotIsNull(createAt, error: "O valor da data de criação não pode ser vazio");
    boolNotIsNull(completed);

    return TaskEntity(
        id: id ?? 0 ,
        title: title,
        description: description,
        completed: !completed!,
        createAt: createAt!,
        updateAt: DateTime.now()
    );
  }

  TaskEntity alterTitle(String text){
    textNotIsNull(text, error: "O título não pode ser vazio");
    dataTimeNotIsNull(createAt, error: "O valor da data de criação não pode ser vazio");
    textIsLessThan20Characters(text, error: "O título não pode ter mais de 20 caracteres");

    return TaskEntity(
        id: id ?? 0,
        title: text,
        description: description,
        completed: false,
        createAt: createAt!,
        updateAt: DateTime.now()
    );
  }

  TaskEntity alterDescription(String text){
    dataTimeNotIsNull(createAt, error: "O valor da data de criação não pode ser vazio");

    return TaskEntity(
        id: id ?? 0,
        title: title,
        description: text,
        completed: false,
        createAt: createAt!,
        updateAt: DateTime.now()
    );
  }
}