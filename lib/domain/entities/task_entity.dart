import '../../shared/validation/validating_task_information.dart';
import '../seedWork/entity.dart';

class TaskEntity extends Entity with ValidatingTaskInformation {
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
}