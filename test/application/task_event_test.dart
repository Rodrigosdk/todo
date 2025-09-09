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
    registerFallbackValue(TaskEntity(id:0,title: "", description: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now()));
  });

  group("Caso de uso da tarefa", () {

    group("save()", (){
      test("deve conseguir salvar uma tarefa", () {
        useCase.save(title: title, description: description);

        verify(() => repository.save(task: any(named: 'task'))).called(1);
      });

      test("deve conseguir salvar uma tarefa sem descrição", (){
        useCase.save(title: title);

        verify(() => repository.save(task: any(named: 'task'))).called(1);
      });

      test("deve retornar um erro caso tente salvar com o título campo vazio", () {

        expect(() => useCase.save(title: ""), throwsException);
        expect(() => useCase.save(title: " "), throwsException);
        expect(() => useCase.save(title: "   "), throwsException);

        expect(() => useCase.save(title: "\n"), throwsException);
        expect(() => useCase.save(title: "\n\n"), throwsException);
        expect(() => useCase.save(title: "\n \n"), throwsException);

        expect(() => useCase.save(title: "\t"), throwsException);
        expect(() => useCase.save(title: "\t\t"), throwsException);
        expect(() => useCase.save(title: "\t \t"), throwsException);

        expect(() => useCase.save(title: "\t\n"), throwsException);
        expect(() => useCase.save(title: "\t \n"), throwsException);
      });

      test("deve retornar um erro caso tente salvar uma tarefa com o título tendo mais de 20 caractere", () {
        expect(() => useCase.save(
            title: "000000000000000000000000",
            description: description
        ),
          throwsException,
        );
      });

    });

    group("updateStatus()", (){
      test("deve conseguir alterar o status de uma tarefa", () {
        useCase.save(title: title, description: description);

        when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

        useCase.updateStatus(id: 1);

        verify(() => repository.updateStatus(task: any(named: 'task'))).called(1);
      });
    });

    group("updateTitle()", (){
      test("deve conseguir alterar o título", () {
        useCase.save(title: title, description: description);
        when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

        useCase.updateTitle(1, name: "Estudar Flutter");

        verify(() => repository.updateTitle(task: any(named: 'task'))).called(1);
      });

      test("deve conseguir salvar uma tarefa sem descrição", (){
        useCase.save(title: title, description: description);
        when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

        useCase.updateTitle(1 ,name: title);

        verify(() => repository.save(task: any(named: 'task'))).called(1);
      });

      test("deve retornar um erro caso tente salvar com o título campo vazio", () {
        useCase.save(title: title, description: description);
        when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

        expect(() => useCase.updateTitle(1,name: ""), throwsException);
        expect(() => useCase.updateTitle(1,name: " "), throwsException);
        expect(() => useCase.updateTitle(1,name: "   "), throwsException);

        expect(() => useCase.updateTitle(1,name: "\n"), throwsException);
        expect(() => useCase.updateTitle(1,name: "\n\n"), throwsException);
        expect(() => useCase.updateTitle(1,name: "\n \n"), throwsException);

        expect(() => useCase.updateTitle(1,name: "\t"), throwsException);
        expect(() => useCase.updateTitle(1,name: "\t\t"), throwsException);
        expect(() => useCase.updateTitle(1,name: "\t \t"), throwsException);

        expect(() => useCase.updateTitle(1,name: "\t\n"), throwsException);
        expect(() => useCase.updateTitle(1,name: "\t \n"), throwsException);
      });


    });

    group("updateDescription()", (){
      test("deve conseguir alterar o descrição", () {
        useCase.save(title: title, description: description);
        when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

        useCase.updateDescription(1, description: "Estudar Flutter");

        verify(() => repository.updateDescription(task: any(named: 'task'))).called(1);
      });
    });


    test("deve conseguir remover a tarefa", () {
      useCase.save(title: title, description: description);
      when(() => repository.listen()).thenReturn([TaskEntity(id: 1, title: "", completed: false, createAt: DateTime.now(), updateAt: DateTime.now())]);

      useCase.remove(1);

      verify(() => repository.remove(1)).called(1);
    });

    test("deve conseguir listar as tarefas", () {
      when(() => repository.listen()).thenReturn(<TaskEntity>[]);

      useCase.listen();

      verify(() => repository.listen()).called(1);
    });


  });
}

