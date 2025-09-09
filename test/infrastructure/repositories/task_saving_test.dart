import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/infrastructure/repositories/task_database_event.dart';


void main() {
  late TaskDatabaseEvent repository;

  late TaskEntity task;

  setUp((){
    repository = TaskDatabaseEvent();

    task = TaskEntity(
      id: 1,
      title: "Teste",
      description: "Descrição",
      completed: false,
      createAt: DateTime.now(),
      updateAt: DateTime.now(),
    );
  });

  group("Tarefa", () {

    test("deve conseguir salvar", () {
      repository.save(task: task);

      expect(repository.db.length, 1);
      expect(repository.db[0].title, task.title);
      expect(repository.db[0].description, task.description);
    });


    test("deve conseguir alterar o status de uma tarefa", () {
      repository.save(task: task);

      repository.updateStatus(task: task.copyWith(completed: true));

      expect(repository.db.length, 1);
      expect(repository.db[0].title, task.title);
      expect(repository.db[0].description, task.description);
      expect(repository.db[0].completed, true);
    });

    test("deve conseguir ser removida", () {
      repository.save(task: task);

      repository.remove(1);

      expect(repository.db.length, 0);
    });

    test("deve conseguir ser listada", () {
      repository.save(task: task);

      final tasks = repository.listen();

      expect(repository.db.length, tasks.length);
    });
  });
  test("deve conseguir alterar o título", () {
    repository.save(task:task);

    repository.updateTitle(task:task.copyWith(title: "Estudar Flutter"));

    expect(repository.db.length, 1);
    expect(repository.db[0].title, "Estudar Flutter");
    expect(repository.db[0].description, task.description);
    expect(repository.db[0].completed,  task.completed);
  });

  test("deve conseguir alterar o descrição", () {
    repository.save(task:task);

    repository.updateTitle(task:task.copyWith(description: "Estudar Flutter"));

    expect(repository.db.length, 1);
    expect(repository.db[0].title, task.title);
    expect(repository.db[0].description, "Estudar Flutter");
    expect(repository.db[0].completed, task.completed);
  });
}
