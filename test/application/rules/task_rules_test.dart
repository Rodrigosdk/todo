
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/application/rules/task_rules.dart';

void main() {
  group('Regras de negócio da tarefa', () {
    final now = DateTime.now();

    test('deve conseguir salvar e retornar TaskEntity válida', () {
      final task = TaskRules(
        id: 1,
        title: 'Fazer testes',
        description: 'Descrição ok',
        completed: false,
      );

      final result = task.save();

      expect(result.id, task.id);
      expect(result.title, task.title);
      expect(result.description, task.description);
      expect(result.completed, task.completed);
    });

    test('deve lançar exceção se título for vazio', () {
      final task = TaskRules(
        id: 1,
        title: '   ',
        description: 'Descrição',
        completed: false,
        createAt: now,
      );

      expect(() => task.save(), throwsException);
    });

    test('deve lançar exceção se título > 20 caracteres', () {
      final task = TaskRules(
        id: 1,
        title: 'a' * 21,
        description: 'Descrição',
        completed: false,
        createAt: now,
      );

      expect(() => task.save(), throwsException);
    });

    test('deve salvar o id como 0 caso não seja passado', () {
      final task = TaskRules(
        title: 'a',
        description: 'Descrição',
      );

      final result = task.save();

      expect(result.id, 0);
      expect(result.title, task.title);
      expect(result.description, task.description);
    });

    test('deve salvar como completed false', () {
      final task = TaskRules(
        title: 'a',
        description: 'Descrição',
        completed: true
      );

      final result = task.save();

      expect(result.id, 0);
      expect(result.title, task.title);
      expect(result.description, task.description);
      expect(result.completed, false);
    });

    test('alterStatusCompleted() deve inverter o status', () {
      final task = TaskRules(
        id: 1,
        title: 'Tarefa',
        description: 'Descrição',
        completed: false,
        createAt: now,
      );

      final updated = task.alterStatusCompleted();

      expect(updated.completed, isTrue);
      expect(updated.id, task.id);
    });

    test('alterStatusCompleted() deve retornar um erro caso a data de criação não tenha sido informada', () {
      final task = TaskRules(
        id: 1,
        title: 'Tarefa',
        description: 'Descrição',
        completed: false,
      );

      expect(() => task.alterStatusCompleted(), throwsException);
    });

    test('alterStatusCompleted() deve retornar um erro caso a data o completed não tenha sido informada', () {
      final task = TaskRules(
        id: 1,
        title: 'Tarefa',
        description: 'Descrição',
        createAt: now
      );

      expect(() => task.alterStatusCompleted(), throwsException);
    });

    test('alterTitle() deve atualizar o título e manter outros campos', () {
      final task = TaskRules(
        id: 1,
        title: 'Velho título',
        description: 'Descrição',
        completed: false,
        createAt: now,
      );

      final updated = task.alterTitle('Novo título');

      expect(updated.title, 'Novo título');
      expect(updated.description, task.description);
      expect(updated.completed, task.completed);
      expect(updated.updateAt, isNotNull);
    });

    test('alterTitle() deve lançar exceção se título for inválido', () {
      final task = TaskRules(
        id: 1,
        title: 'Título',
        description: 'Descrição',
        completed: false,
        createAt: now,
      );

      expect(() => task.alterTitle('   '), throwsException);
      expect(() => task.alterTitle('a' * 21), throwsException);
    });

    test('alterTitle() deve lançar exceção se título a data de criação não tenha sido informada', () {
      final task = TaskRules(
        id: 1,
        title: 'Título',
        description: 'Descrição',
        completed: false,
      );

      expect(() => task.alterTitle(" "), throwsException);
    });


    test('alterDescription() deve atualizar a descrição', () {
      final task = TaskRules(
        id: 1,
        title: 'Tarefa',
        description: 'Descrição antiga',
        completed: false,
        createAt: now,
      );

      final updated = task.alterDescription('Nova descrição');

      expect(updated.description, 'Nova descrição');
      expect(updated.title, task.title);
      expect(updated.updateAt, isNotNull);
    });
  });
}
