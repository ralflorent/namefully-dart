import 'package:namefully/namefully.dart';
import 'package:namefully/src/validators.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('ValidationException', () {
    test('is thrown when a namon breaks the validation rules', () {
      expect(
        () => NamonValidator().validate('J4ne'),
        throwsValidationException,
      );
    });

    test('is thrown if part of a first name breaks the validation rules', () {
      expect(
        () => FirstNameValidator().validate(FirstName('J4ne')),
        throwsValidationException,
      );
      expect(
        () => FirstNameValidator().validate(FirstName('J4ne', ['Ka7e'])),
        throwsValidationException,
      );
      expect(() => FirstNameValidator().validate('Jane;'),
          throwsValidationException);
    });

    test('is thrown if any middle name breaks the validation rules', () {
      expect(
        () => MiddleNameValidator().validate([Name('ka7e', Namon.firstName)]),
        throwsValidationException,
      );
      expect(
        () => MiddleNameValidator().validate([Name('kate;', Namon.middleName)]),
        throwsValidationException,
      );
      expect(
        () => MiddleNameValidator().validate([
          Name('Jack', Namon.middleName),
          Name('kate;', Namon.middleName),
        ]),
        throwsValidationException,
      );
    });

    test('is thrown if any part of a last name breaks the validation rules',
        () {
      expect(() => LastNameValidator().validate(LastName('Smith;')),
          throwsValidationException);
      expect(() => LastNameValidator().validate(LastName('Smith', 'Doe-')),
          throwsValidationException);
      expect(() => LastNameValidator().validate('Smith--Doe'),
          throwsValidationException);
    });

    test('is thrown if a namon breaks the validation rules', () {
      expect(() => NameValidator().validate(Name('mr.', Namon.prefix)),
          throwsValidationException);
      expect(() => NameValidator().validate(Name('mr ', Namon.prefix)),
          throwsValidationException);
      expect(() => NameValidator().validate(Name('jane-', Namon.prefix)),
          throwsValidationException);
      expect(() => NameValidator().validate(Name("john'", Namon.prefix)),
          throwsValidationException);
    });

    test('is thrown if the json name values are incorrect', () {
      expect(
        () => NamaValidator().validate({
          Namon.firstName: 'J4ne',
          Namon.lastName: 'Doe',
        }),
        throwsValidationException,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: '',
          Namon.firstName: 'Jane',
          Namon.lastName: 'Smith',
        }),
        throwsValidationException,
      );
    });

    test('is thrown if a string list breaks the validation rules', () {
      expect(
        () => ListStringValidator().validate(['jane,', 'doe']),
        throwsValidationException,
      );
    });
  });

  group('InputException', () {
    test('is thrown if the json name keys are not as expected', () {
      expect(() => NamaValidator().validate({}), throwsInputException);
      expect(
        () => NamaValidator().validate({Namon.prefix: ''}),
        throwsInputException,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: 'Mr',
          Namon.firstName: 'John',
        }),
        throwsInputException,
      );
      expect(
        () => NamaValidator().validate({
          Namon.prefix: 'Mr',
          Namon.lastName: 'Smith',
        }),
        throwsInputException,
      );
    });
    test('is thrown if a string list has an unsupported number of entries', () {
      expect(() => ListStringValidator().validate([]), throwsInputException);
      expect(
        () => ListStringValidator().validate(['jane']),
        throwsInputException,
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
        throwsInputException,
      );
    });

    test('is thrown if a name list has an unsupported number of entries', () {
      var name = Name('jane-', Namon.firstName);
      expect(() => ListNameValidator().validate([]), throwsInputException);
      expect(() => ListNameValidator().validate([name]), throwsInputException);
      expect(
        () => ListNameValidator().validate([
          name,
          name,
          name,
          name,
          name,
          name,
        ]),
        throwsInputException,
      );
    });

    test('is thrown if the wrong argument is provided for a first name', () {
      expect(() => FirstNameValidator().validate(1), throwsInputException);
      expect(() => FirstNameValidator().validate(true), throwsInputException);
    });

    test('is thrown if the wrong argument is provided for a middle name', () {
      expect(() => MiddleNameValidator().validate(1), throwsInputException);
      expect(() => MiddleNameValidator().validate(true), throwsInputException);
    });

    test('is thrown if the wrong argument is provided for a last name', () {
      expect(() => LastNameValidator().validate(1), throwsInputException);
      expect(() => LastNameValidator().validate(true), throwsInputException);
    });
  });
}
