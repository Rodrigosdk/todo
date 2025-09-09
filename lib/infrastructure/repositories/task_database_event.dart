import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_event_repository.dart';

class TaskDatabaseEvent implements TaskEventRepository{
  List<TaskEntity> db = [];

  void _updateElement(TaskEntity task){
    db.removeWhere((element) => element.id == task.id);
    db.add(task);
  }

  @override
  void save({required TaskEntity task}) => db.add(task);

  @override
  void updateStatus({required TaskEntity task}) => _updateElement(task);

  @override
  void updateTitle({required TaskEntity task}) => _updateElement(task);

  @override
  void updateDescription({required TaskEntity task}) => _updateElement(task);

  @override
  void remove(int id) {
    db.removeWhere((element) => element.id == id);
  }

  @override
  List<TaskEntity> listen(){
    return db;
  }
}
