import 'package:flutter_test/flutter_test.dart';
import 'package:todo/shared/validation/validating_task_information.dart';

class MockValidatingTaskInformation with ValidatingTaskInformation {}

main(){
  late MockValidatingTaskInformation validation;

  setUp((){
    validation = MockValidatingTaskInformation();
  });

  group("Validação", (){
    group("texto não é nulo",(){
      test("deve gerar um erro se o texto não for passado", (){
        expect(() => validation.textNotIsNull(""),  throwsException);
        expect(() => validation.textNotIsNull(" "),  throwsException);
        expect(() => validation.textNotIsNull("   "),  throwsException);

        expect(() => validation.textNotIsNull("\n"),  throwsException);
        expect(() => validation.textNotIsNull("\n\n"),  throwsException);
        expect(() => validation.textNotIsNull("\n \n"),  throwsException);

        expect(() => validation.textNotIsNull("\t"),  throwsException);
        expect(() => validation.textNotIsNull("\t\t"),  throwsException);
        expect(() => validation.textNotIsNull("\t \n"),  throwsException);
      });
      test('lança exceção para texto só com tabs e quebras de linha', () {
        expect(
              () => validation.textNotIsNull('\n\t\n\t'),
          throwsA(predicate((e) => e is Exception && e.toString().contains('O valor não pode ser vazio'))),
        );
      });
      test("deve retornar uma mensagem de erro generico caso o texto do erro não seja passado", (){
        expect(() =>
            validation.textNotIsNull('   ', error: 'Campo obrigatório'),
            throwsA(predicate((e) => e is Exception && e.toString().contains('Campo obrigatório'))));
      });

      test('não lança exceção se texto contém algo além de espaços', () {
        expect(() => validation.textNotIsNull('  ok  '), returnsNormally);
      });

      test('não faz nada se texto for null (ignora)', () {
        expect(() => validation.textNotIsNull(null), returnsNormally);
      });

    });

    group("texto tem menos de 20 caracteres",(){
      test('não lança exceção com string de 20 caracteres', () {
        expect(() => validation.textIsLessThan20Characters('12345678901234567890'), returnsNormally);
      });

      test('não lança exceção com string menor que 20 caracteres', () {
        expect(() => validation.textIsLessThan20Characters('curto'), returnsNormally);
      });

      test('lança exceção com string maior que 20 caracteres', () {
        expect(
              () => validation.textIsLessThan20Characters('123456789012345678901'),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('O valor não pode ter mais de 20 caracteres'))),
        );
      });

      test('lança exceção com mensagem personalizada', () {
        expect(
              () => validation.textIsLessThan20Characters('a' * 21, error: 'Texto muito longo'),
          throwsA(predicate((e) =>
          e is Exception &&
              e.toString().contains('Texto muito longo'))),
        );
      });
    });
  });
}