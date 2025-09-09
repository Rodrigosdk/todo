import '../entities/task_entity.dart';

abstract class TaskEventRepository {
  List<TaskEntity> listen();
  void save({required TaskEntity task});
  void updateStatus({required TaskEntity task});
  void updateTitle({required TaskEntity task});
  void updateDescription({required TaskEntity task});
  void remove(int id);

}