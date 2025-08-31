import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/domain/rules/task_rules.dart';

extension TaskEntityMap on TaskEntity {
  TaskRules toTaskRules(){
    return TaskRules(
      id: id,
      completed: completed,
      title: title,
      description: description,
      createAt: createAt,
      updateAt: updateAt,
    );
  }
}