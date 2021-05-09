import 'package:namefully/namefully.dart';
import 'package:namefully/src/validators.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('ValidationError', () {
    test('is thrown when a namon breaks the validation rules', () {
      expect(() => NamonValidator().validate('J4ne'), throwsValidationError);
    });

    test('is thrown if any part of a first name breaks the validation rules',
        () {
      expect(
        () => FirstNameValidator().validate(FirstName('J4ne')),
        throwsValidationError,
      );
      expect(
        () => FirstNameValidator().validate(FirstName('J4ne', ['Ka7e'])),
        throwsValidationError,
      );
      expect(
          () => FirstNameValidator().validate('Jane;'), throwsValidationError);
    });

    test('is thrown if any middle name breaks the validation rules', () {
      expect(
        () => MiddleNameValidator().validate([
          Name('ka7e', Namon.firstName),
        ]),
        throwsValidationError,
      );
      expect(
        () => MiddleNameValidator().validate([Name('kate;', Namon.middleName)]),
        throwsValidationError,
      );
      expect(
        () => MiddleNameValidator().validate([
          Name('Jack', Namon.middleName),
          Name('kate;', Namon.middleName),
        ]),
        throwsValidationError,
      );
    });

    test('is thrown if any part of a last name breaks the validation rules',
        () {
      expect(() => LastNameValidator().validate(LastName('Smith;')),
          throwsValidationError);
      expect(() => LastNameValidator().validate(LastName('Smith', 'Doe-')),
          throwsValidationError);
      expect(() => LastNameValidator().validate('Smith--Doe'),
          throwsValidationError);
    });

    test('is thrown if a namon breaks the validation rules', () {
      expect(() => NameValidator().validate(Name('mr.', Namon.prefix)),
          throwsValidationError);
      expect(() => NameValidator().validate(Name('mr ', Namon.prefix)),
          throwsValidationError);
      expect(() => NameValidator().validate(Name('jane-', Namon.prefix)),
          throwsValidationError);
      expect(() => NameValidator().validate(Name("john'", Namon.prefix)),
          throwsValidationError);
    });

    test('is thrown if the json name keys are not as expected', () {
      expect(() => NamaValidator().validate({}), throwsValidationError);
      expect(
        () => NamaValidator().validate({Namon.prefix: ''}),
        throwsValidationError,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: 'Mr',
          Namon.firstName: 'John',
        }),
        throwsValidationError,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: 'Mr',
          Namon.lastName: 'Smith',
        }),
        throwsValidationError,
      );
    });

    test('is thrown if the json name values are incorrect', () {
      expect(
        () => NamaValidator().validate({
          Namon.firstName: 'J4ne',
          Namon.lastName: 'Doe',
        }),
        throwsValidationError,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: '',
          Namon.firstName: 'Jane',
          Namon.lastName: 'Smith',
        }),
        throwsValidationError,
      );
    });

    test('is thrown if a string list has an unsupported number of entries', () {
      expect(() => ListStringValidator().validate([]), throwsValidationError);
      expect(
        () => ListStringValidator().validate(['jane']),
        throwsValidationError,
      );
      expect(
        () => ListStringValidator().validate([
          'ms',
          'jane',
          'jane',
          'janet',
          'doe',
          'III',
        ]),
        throwsValidationError,
      );
    });

    test('is thrown if a string list breaks the validation rules', () {
      expect(
        () => ListStringValidator().validate([
          'jane,',
          'doe',
        ]),
        throwsValidationError,
      );
    });

    test('is thrown if a name list has an unsupported number of entries', () {
      var name = Name('jane-', Namon.firstName);
      expect(() => ListNameValidator().validate([]), throwsValidationError);
      expect(() => ListNameValidator().validate([name]), throwsValidationError);
      expect(
        () => ListNameValidator().validate([
          name,
          name,
          name,
          name,
          name,
          name,
        ]),
        throwsValidationError,
      );
    });
  });

  group('ArgumentError', () {
    test('is thrown if the wrong argument is provided for a first name', () {
      expect(() => FirstNameValidator().validate(1), throwsArgumentError);
      expect(() => FirstNameValidator().validate(true), throwsArgumentError);
    });

    test('is thrown if the wrong argument is provided for a middle name', () {
      expect(() => MiddleNameValidator().validate(1), throwsArgumentError);
      expect(() => MiddleNameValidator().validate(true), throwsArgumentError);
    });

    test('is thrown if the wrong argument is provided for a last name', () {
      expect(() => LastNameValidator().validate(1), throwsArgumentError);
      expect(() => LastNameValidator().validate(true), throwsArgumentError);
    });
  });
}
