
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/entities/task_entity.dart';
import 'package:todo/domain/rules/task_rules.dart';

void main() {
  group('Regras de negócio da tarefa', () {
    final now = DateTime.now();

    test('deve conseguir salvar e retornar TaskEntity válida', () {
      final task = TaskRules(
        id: 1,
        title: 'Fazer testes',
        description: 'Descrição ok',
        completed: false,
        createAt: now,
      );

      final result = task.save();

      expect(result.id, task.id);
      expect(result.title, task.title);
      expect(result.description, task.description);
      expect(result.completed, task.completed);
      expect(result.createAt, task.createAt);
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

    test('alterDescription() deve lançar exceção se descrição for inválida', () {
      final task = TaskRules(
        id: 1,
        title: 'Tarefa',
        description: 'Descrição antiga',
        completed: false,
        createAt: now,
      );

      expect(() => task.alterDescription('   '), throwsException);
    });
  });
}
