import 'package:flutter_test/flutter_test.dart';
import 'package:todo/application/task_event.dart';
import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/domain/repository/task_event_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskEventRepository extends Mock implements TaskEventRepository {}

void main() {
  late TaskEventRepository repository;
  late TaskEvent useCase;

  late String title;
  late String description;

  setUp((){
    repository = MockTaskEventRepository();
    useCase = TaskEvent(taskEventRepository: repository);

    title = "Estudar Flutter";
    description = "Estudar Flutter na Udemy";
  });

  group("Caso de uso da tarefa", () {

    test("deve conseguir salvar uma tarefa", () {
      useCase.save(title: title, description: description);

      verify(() => repository.save(title: title, description: description)).called(1);
    });

    test("deve conseguir salvar uma tarefa sem descrição", (){
      useCase.save(title: title);

      verify(() => repository.save(title: title)).called(1);
    });


    test("Deve conseguir alterar o status de uma tarefa", () {
      useCase.save(title: title, description: description);

      useCase.updateStatus(id: 1);

      verify(() => repository.updateStatus(id: 1)).called(1);
    });

    test("deve conseguir ser removida", () {
      useCase.save(title: title, description: description);

      useCase.remove(1);

      verify(() => repository.remove(1)).called(1);
    });

    test("deve conseguir ser listada", () {
      when(() => repository.listen()).thenReturn(<TaskEntity>[]);

      useCase.listen();

      verify(() => repository.listen()).called(1);
    });

    test("deve conseguir alterar o título", () {
      useCase.save(title: title, description: description);

      useCase.updateTitle(1, name: "Estudar Flutter");

      verify(() => repository.updateTitle(1, name: "Estudar Flutter")).called(1);
    });
    test("deve conseguir alterar o descrição", () {
      useCase.save(title: title, description: description);
      useCase.updateDescription(1, description: "Estudar Flutter");

      verify(() => repository.updateDescription(1, description: "Estudar Flutter")).called(1);
    });

  });
}

