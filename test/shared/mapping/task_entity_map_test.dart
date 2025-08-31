import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/shared/mapping/task_entity_map.dart';

main(){
  test('toTaskRules mapeia corretamente os campos', () {
    final taskEntity = TaskEntity(
      id: 123,
      completed: false,
      title: 'Testar',
      description: 'Descrição',
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
    );

    final rules = taskEntity.toTaskRules();

    expect(rules.id, taskEntity.id);
    expect(rules.title, taskEntity.title);
    expect(rules.description, taskEntity.description);
    expect(rules.completed, taskEntity.completed);
  });

}