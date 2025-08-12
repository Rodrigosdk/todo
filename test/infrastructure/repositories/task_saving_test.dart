import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/entities/task_entity.dart';

class TaskSaving {
  List<TaskEntity> db = [];

  void save({required title, required description}) {
    if (title.trim().isEmpty) throw Exception("O título não pode ser vazio");
    if (description.trim().isEmpty) throw Exception("A descrição não pode ser vazia");

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

  void updateStatus({required int id}) {
    final task = db
        .firstWhere((element) => element.id == id)
        .alterStatusCompleted();
    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  void updateTitle(int id, {required String name}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final task = oldTask.alterTitle(name);

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }

  void updateDescription(int id, {required String description}) {
    final oldTask = db.firstWhere((element) => element.id == id);

    final task = oldTask.alterDescription(description);

    db.removeWhere((element) => element.id == id);
    db.add(task);
  }
}

void main() {
  group("Tarefa", () {
    test("Deve conseguir salvar uma tarefa", () {
      final taskSaving = TaskSaving();
      final title = "Estudar Flutter";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
    });

    test("Deve salvar uma tarefa como não concluída", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("Deve conseguir alterar o status de uma tarefa", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      final taskId = taskSaving.save(title: title, description: description);
      taskSaving.updateStatus(id: 1);

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, true);
    });
  });

  group("Campo título da tarefa", () {
    test("deve conseguir alterar o título", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);
      taskSaving.updateTitle(1, name: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, "Estudar Flutter");
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("deve retornar um erro caso tente salvar com o valor vazio", () {
      final taskSaving = TaskSaving();
      final description = "Estudar Flutter na Udemy";

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
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);

      expect(() => taskSaving.updateTitle(1, name: ""), throwsException);
      expect(() => taskSaving.updateTitle(1, name: "  "), throwsException);
    });


    test("deve retornar um erro caso tente salvar uma tarefa com o título tendo mais de 20 caractere", () {
      final taskSaving = TaskSaving();
      final description = "Estudar Flutter na Udemy";

      expect(
            () => taskSaving.save(title: "000000000000000000000000", description: description),
        throwsException,
      );
    });

    test("deve retornar um erro caso tente atualizar o título com mais de 20 caractere", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);

      expect(
        () => taskSaving.updateTitle(1, name: "000000000000000000000000"),
        throwsException,
      );
    });

    test("deve modifcar o status para false caso altere o título", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);
      taskSaving.updateStatus(id: 1);

      taskSaving.updateTitle(1, name: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, "Estudar Flutter");
      expect(taskSaving.db[0].description, description);
      expect(taskSaving.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o título",  () {
        final taskSaving = TaskSaving();
        final title = "Estudar .Net";
        final description = "Estudar Flutter na Udemy";

        final beforeUpdate = DateTime.now();
        taskSaving.save(title: title, description: description);
        taskSaving.updateTitle(1, name: "Estudar Flutter");
        final afterUpdate = DateTime.now();

        expect(taskSaving.db.length, 1);
        expect(taskSaving.db[0].title, "Estudar Flutter");
        expect(taskSaving.db[0].description, description);
        expect(taskSaving.db[0].completed, false);
        expect(taskSaving.db[0].updateAt!.isAfter(beforeUpdate), true);
      },
    );
  });

  group("Campo de descrição da tarefa", () {
    test("deve conseguir alterar o descrição", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);
      taskSaving.updateDescription(1, description: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, "Estudar Flutter");
      expect(taskSaving.db[0].completed, false);
    });

    test("deve retornar um erro caso tente salvar com o valor vazio", () {
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";

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
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

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
      final taskSaving = TaskSaving();
      final title = "Estudar .Net";
      final description = "Estudar Flutter na Udemy";

      taskSaving.save(title: title, description: description);
      taskSaving.updateStatus(id: 1);

      taskSaving.updateDescription(1, description: "Estudar Flutter");

      expect(taskSaving.db.length, 1);
      expect(taskSaving.db[0].title, title);
      expect(taskSaving.db[0].description, "Estudar Flutter");
      expect(taskSaving.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o descrição", () {
        final taskSaving = TaskSaving();
        final title = "Estudar .Net";
        final description = "Estudar Flutter na Udemy";

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
