import '../entities/task_entity.dart';

abstract class TaskEventRepository {
  List<TaskEntity> listen();
  void save({required String title, String? description});
  void updateStatus({required int id});
  void updateTitle(int id, {required String name});
  void updateDescription(int id, {required String description});
  void remove(int id);

}