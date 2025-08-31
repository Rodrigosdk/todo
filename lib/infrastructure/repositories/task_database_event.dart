import 'package:todo/domain/rules/task_rules.dart';
import 'package:todo/shared/mapping/task_entity_map.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_event_repository.dart';

class TaskDatabaseEvent implements TaskEventRepository{
  List<TaskEntity> db = [];

  @override
  void save({required String title, String? description}) {
    final task = TaskRules(
      id: db.length + 1,
      title: title,
      description: description,
      completed: false,
      createAt: DateTime.now(),
    );

    final validationTask = task.save();

    db.add(validationTask);
  }

  @override
  void updateStatus({required int id}) {
    final finedTask = db.firstWhere((element) => element.id == id);
    final mapTask = finedTask.toTaskRules();
    final task = mapTask.alterStatusCompleted();

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  @override
  void updateTitle(int id, {required String name}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final taskRules = oldTask.toTaskRules();
    final task = taskRules.alterTitle(name);

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  @override
  void updateDescription(int id, {required String description}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final taskRules = oldTask.toTaskRules();
    final task = taskRules.alterDescription(description);

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  @override
  void remove(int id) {
    db.removeWhere((element) => element.id == id);
  }

  @override
  List<TaskEntity> listen(){
    return db;
  }
}
