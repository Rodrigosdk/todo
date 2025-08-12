import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/entities/task_entity.dart';

abstract class ITaskSaving {
  void save({required String title, String? description});
  void updateStatus({required int id});
  void updateTitle(int id, {required String name});
  void updateDescription(int id, {required String description});
  void remove(int id);
  List<TaskEntity> listen();
}

class TaskSaving implements ITaskSaving{
  List<TaskEntity> db = [];

  @override
  void save({required String title, String? description}) {
    if (title.trim().isEmpty) throw Exception("O título não pode ser vazio");
    if(description is String){
      if (description.trim().isEmpty) throw Exception("A descrição não pode ser vazia");
    }
    if (title.length > 20) throw Exception("O título não pode ter mais de 20 caracteres");

    db.add(
      TaskEntity(
        id: 1,
        title: title,
        description: description,
        createAt: DateTime.now(),
        completed: false,
      ),
    );
  }

  @override
  void updateStatus({required int id}) {
    final task = db
        .firstWhere((element) => element.id == id)
        .alterStatusCompleted();
    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  @override
  void updateTitle(int id, {required String name}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final task = oldTask.alterTitle(name);

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  @override
  void updateDescription(int id, {required String description}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final task = oldTask.alterDescription(description);

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

void main() {
  late TaskSaving taskSaving;
  late String title;
  late String description;

  setUp((){
    taskSaving = TaskSaving();
    title = "Estudar Flutter";
    description = "Estudar Flutter na Udemy";
  });

  group("Tarefa", () {

    test("deve conseguir ser salvar", () {
      taskSaving.save(title: title, description: description);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
    });

    test("deve conseguir salvar uma tarefa sem descrição", (){
      taskSaving.save(title: title);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, null);
    });


    test("deve conseguir ser salvar como não concluída", () {
      taskSaving.save(title: title, description: description);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("Deve conseguir alterar o status de uma tarefa", () {
      taskSaving.save(title: title, description: description);

      taskSaving.updateStatus(id: 1);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, true);
    });

    test("deve conseguir ser removida", () {
      taskSaving.save(title: title, description: description);

      taskSaving.remove(1);

      expect(taskSaving.db.length, 0);
    });

    test("deve conseguir ser listada", () {
      expect(taskSaving.db.length, 0);
      taskSaving.save(title: title, description: description);

      final tasks = taskSaving.listen();

      expect(taskSaving.db.length, tasks.length);
    });
  });

  group("Campo título da tarefa", () {
    test("deve conseguir alterar o título", () {
      taskSaving.save(title: title, description: description);

      taskSaving.updateTitle(1, name: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, "Estudar Flutter");
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("deve retornar um erro caso tente salvar com o valor vazio", () {
      expect(
        () => taskSaving.save(title: "", description: description),
        throwsException,
      );
      expect(
        () => taskSaving.save(title: "  ", description: description),
        throwsException,
      );
    });

    test("deve retornar um erro caso tente atualizar com um campo vazio", () {
      taskSaving.save(title: title, description: description);

      expect(() => taskSaving.updateTitle(1, name: ""), throwsException);
      expect(() => taskSaving.updateTitle(1, name: "  "), throwsException);
    });


    test("deve retornar um erro caso tente salvar uma tarefa com o título tendo mais de 20 caractere", () {
      expect(
            () => taskSaving.save(title: "000000000000000000000000", description: description),
        throwsException,
      );
    });

    test("deve retornar um erro caso tente atualizar o título com mais de 20 caractere", () {
      taskSaving.save(title: title, description: description);

      expect(
        () => taskSaving.updateTitle(1, name: "000000000000000000000000"),
        throwsException,
      );
    });

    test("deve modifcar o status para false caso altere o título", () {
      taskSaving.save(title: title, description: description);
      taskSaving.updateStatus(id: 1);

      taskSaving.updateTitle(1, name: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, "Estudar Flutter");
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o título",  () {
        final beforeUpdate = DateTime.now();
        taskSaving.save(title: title, description: description);
        taskSaving.updateTitle(1, name: "Estudar Flutter");
        final afterUpdate = DateTime.now();

        expect(taskSaving.db.length, 1);
        expect(taskSaving.db[0].title, "Estudar Flutter");
        expect(taskSaving.db[0].description, description);
        expect(taskSaving.db[0].completed, false);
        expect(taskSaving.db[0].updateAt!.isBefore(afterUpdate), true);
        expect(taskSaving.db[0].updateAt!.isAfter(beforeUpdate), true);
      },
    );
  });

  group("Campo de descrição da tarefa", () {
    test("deve conseguir alterar o descrição", () {
      taskSaving.save(title: title, description: description);
      taskSaving.updateDescription(1, description: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, "Estudar Flutter");
      expect(taskSaving.db[0].completed, false);
    });

    test("deve retornar um erro caso tente salvar com o valor vazio", () {
      expect(
            () => taskSaving.save(title: title, description: ""),
        throwsException,
      );
      expect(
            () => taskSaving.save(title: title, description: "    "),
        throwsException,
      );
    });

    test("deve retornar um erro caso o descrição seja vazio", () {
      taskSaving.save(title: title, description: description);

      expect(
        () => taskSaving.updateDescription(1, description: ""),
        throwsException,
      );
      expect(
        () => taskSaving.updateDescription(1, description: "  "),
        throwsException,
      );
    });

    test("deve modifcar o status para false caso altere o descrição", () {
      taskSaving.save(title: title, description: description);
      taskSaving.updateStatus(id: 1);

      taskSaving.updateDescription(1, description: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, "Estudar Flutter");
      expect(taskSaving.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o descrição", () {
        final beforeUpdate = DateTime.now();
        taskSaving.save(title: title, description: description);
        taskSaving.updateDescription(1, description: "Estudar Flutter");
        final afterUpdate = DateTime.now();

        expect(taskSaving.db.length, 1);
        expect(taskSaving.db[0].title, title);
        expect(taskSaving.db[0].description, "Estudar Flutter");
        expect(taskSaving.db[0].completed, false);
        expect(taskSaving.db[0].updateAt!.isBefore(afterUpdate), true);
        expect(taskSaving.db[0].updateAt!.isAfter(beforeUpdate), true);
      },
    );
  });
}
