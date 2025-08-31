import '../domain/entities/task_entity.dart';
import '../domain/repository/task_event_repository.dart';

class TaskEvent {
  final TaskEventRepository taskEventRepository;

  TaskEvent({required this.taskEventRepository});

  List<TaskEntity> listen(){
    return taskEventRepository.listen();
  }

  void save({required String title, String? description}) {
    taskEventRepository.save(title: title, description: description);
  }

  void updateStatus({required int id}) {
    taskEventRepository.updateStatus(id: id);
  }

  void updateTitle(int id, {required String name}) {
    taskEventRepository.updateTitle(id, name: name);
  }

  void updateDescription(int id, {required String description}) {
    taskEventRepository.updateDescription(id, description: description);
  }

  void remove(int id) {
    taskEventRepository.remove(id);
  }
}
