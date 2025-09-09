import 'package:todo/shared/mapping/task_entity_map.dart';

import '../domain/entities/task_entity.dart';
import '../domain/repository/task_event_repository.dart';
import 'rules/task_rules.dart';

class TaskEvent {
  final TaskEventRepository taskEventRepository;

  TaskEvent({required this.taskEventRepository});

  List<TaskEntity> listen(){
    return taskEventRepository.listen();
  }

  void save({required String title, String? description}) {
    final task = TaskRules(
      title: title,
      description: description,
    );

    final validationTask = task.save();

    taskEventRepository.save(task: validationTask);
  }

  void updateStatus({required int id}) {
    final finedTask = taskEventRepository.listen().firstWhere((element) => element.id == id);

    final mapTask = finedTask.toTaskRules();
    final task = mapTask.alterStatusCompleted();

    taskEventRepository.updateStatus(task: task);
  }

  void updateTitle(int id, {required String name}) {
    final oldTask = taskEventRepository.listen().firstWhere((element) => element.id == id);

    final taskRules = oldTask.toTaskRules();
    final task = taskRules.alterTitle(name);

    taskEventRepository.updateTitle(task: task);

  }

  void updateDescription(int id, {required String description}) {
    final oldTask = taskEventRepository.listen().firstWhere((element) => element.id == id);

    final taskRules = oldTask.toTaskRules();
    final task = taskRules.alterDescription(description);

    taskEventRepository.updateDescription(task: task);
  }

  void remove(int id) {
    taskEventRepository.remove(id);
  }
}
