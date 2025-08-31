import 'package:flutter_test/flutter_test.dart';
import 'package:todo/infrastructure/repositories/task_database_event.dart';


void main() {
  late TaskDatabaseEvent repository;

  late String title;
  late String description;

  setUp((){
    repository = TaskDatabaseEvent();

    title = "Estudar Flutter";
    description = "Estudar Flutter na Udemy";
  });

  group("Tarefa", () {

    test("deve conseguir ser salvar", () {
      repository.save(title: title, description: description);

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, description);
    });

    test("deve conseguir salvar uma tarefa sem descrição", (){
      repository.save(title: title);

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, null);
    });


    test("deve conseguir salvar como não concluída", () {
      repository.save(title: title, description: description);

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, description);
      expect(repository.db[0].completed, false);
    });

    test("deve conseguir alterar o status de uma tarefa", () {
      repository.save(title: title, description: description);

      repository.updateStatus(id: 1);

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, description);
      expect(repository.db[0].completed, true);
    });

    test("deve conseguir ser removida", () {
      repository.save(title: title, description: description);

      repository.remove(1);

      expect(repository.db.length, 0);
    });

    test("deve conseguir ser listada", () {
      repository.save(title: title, description: description);

      final tasks = repository.listen();

      expect(repository.db.length, tasks.length);
    });
  });

  group("Campo título da tarefa", () {
    test("deve conseguir alterar o título", () {
      repository.save(title: title, description: description);

      repository.updateTitle(1, name: "Estudar Flutter");

      expect(repository.db.length, 1);
      expect(repository.db[0].title, "Estudar Flutter");
      expect(repository.db[0].description, description);
      expect(repository.db[0].completed, false);
    });

    test("deve retornar um erro caso tente atualizar com um campo vazio", () {
      repository.save(title: title, description: description);

      expect(() => repository.updateTitle(1, name: ""), throwsException);
      expect(() => repository.updateTitle(1, name: "  "), throwsException);
    });


    test("deve retornar um erro caso tente salvar uma tarefa com o título tendo mais de 20 caractere", () {
      expect(
            () => repository.save(title: "000000000000000000000000", description: description),
        throwsException,
      );
    });

    test("deve retornar um erro caso tente atualizar o título com mais de 20 caractere", () {
      repository.save(title: title, description: description);

      expect(
        () => repository.updateTitle(1, name: "000000000000000000000000"),
        throwsException,
      );
    });

    test("deve modifcar o status para false caso altere o título", () {
      repository.save(title: title, description: description);
      repository.updateStatus(id: 1);

      repository.updateTitle(1, name: "Estudar Flutter");

      expect(repository.db.length, 1);
      expect(repository.db[0].title, "Estudar Flutter");
      expect(repository.db[0].description, description);
      expect(repository.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o título",  () {
        final beforeUpdate = DateTime.now();
        repository.save(title: title, description: description);
        repository.updateTitle(1, name: "Estudar Flutter");
        final afterUpdate = DateTime.now();

        expect(repository.db.length, 1);
        expect(repository.db[0].title, "Estudar Flutter");
        expect(repository.db[0].description, description);
        expect(repository.db[0].completed, false);
        expect(repository.db[0].updateAt!.isBefore(afterUpdate), true);
        expect(repository.db[0].updateAt!.isAfter(beforeUpdate), true);
      },
    );
  });

  group("Campo de descrição da tarefa", () {
    test("deve conseguir alterar o descrição", () {
      repository.save(title: title, description: description);
      repository.updateDescription(1, description: "Estudar Flutter");

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, "Estudar Flutter");
      expect(repository.db[0].completed, false);
    });

    test("deve retornar um erro caso tente salvar com o valor vazio", () {
      expect(
            () => repository.save(title: title, description: ""),
        throwsException,
      );
      expect(
            () => repository.save(title: title, description: "    "),
        throwsException,
      );
    });

    test("deve retornar um erro caso o descrição seja vazio", () {
      repository.save(title: title, description: description);

      expect(
        () => repository.updateDescription(1, description: ""),
        throwsException,
      );
      expect(
        () => repository.updateDescription(1, description: "  "),
        throwsException,
      );
    });

    test("deve modifcar o status para false caso altere o descrição", () {
      repository.save(title: title, description: description);
      repository.updateStatus(id: 1);

      repository.updateDescription(1, description: "Estudar Flutter");

      expect(repository.db.length, 1);
      expect(repository.db[0].title, title);
      expect(repository.db[0].description, "Estudar Flutter");
      expect(repository.db[0].completed, false);
    });

    test("deve está alterando a data de atualização apos modificar o descrição", () {
        final beforeUpdate = DateTime.now();
        repository.save(title: title, description: description);
        repository.updateDescription(1, description: "Estudar Flutter");
        final afterUpdate = DateTime.now();

        expect(repository.db.length, 1);
        expect(repository.db[0].title, title);
        expect(repository.db[0].description, "Estudar Flutter");
        expect(repository.db[0].completed, false);
        expect(repository.db[0].updateAt!.isBefore(afterUpdate), true);
        expect(repository.db[0].updateAt!.isAfter(beforeUpdate), true);
      },
    );
  });
}
