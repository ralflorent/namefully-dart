import 'package:namefully/namefully.dart';
import 'package:namefully/src/validator.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  final Config config = Config(name: 'error_handling', bypass: false);

  group('ValidationException', () {
    test('is thrown when a namon breaks the validation rules', () {
      expect(
        () => Namefully('J4ne Doe', config: config),
        throwsValidationException,
      );
      expect(
        () => Namefully('Jane Do3', config: config),
        throwsValidationException,
      );
    });

    test('is thrown if part of a first name breaks the validation rules', () {
      expect(
        () => Namefully('J4ne Doe', config: config),
        throwsValidationException,
      );
      expect(
        () => Namefully.of([
          FirstName('Jane', ['M4ry']),
          LastName('Doe')
        ], config: config),
        throwsValidationException,
      );
    });

    test('is thrown if any middle name breaks the validation rules', () {
      expect(
        () => Namefully('Jane M4ry Doe', config: config),
        throwsValidationException,
      );
      expect(
        () => Validators.middleName.validate([Name.first('ka7e')]),
        throwsValidationException,
      );
      expect(
        () => Validators.middleName.validate([Name.middle('kate;')]),
        throwsValidationException,
      );
      expect(
        () => Validators.middleName.validate([
          Name.middle('Jack'),
          Name.middle('kate;'),
        ]),
        throwsValidationException,
      );
      expect(
        () => Validators.middleName.validate(['Mary', 'kate;']),
        throwsValidationException,
      );
    });

    test('is thrown if any part of a last name breaks the validation rules',
        () {
      expect(
        () => Namefully('Jane Mary Do3', config: config),
        throwsValidationException,
      );
      expect(
        () => Namefully.of([FirstName('Jane'), LastName('Doe', 'Sm1th')],
            config: config),
        throwsValidationException,
      );
    });

    test('is thrown if a namon breaks the validation rules', () {
      expect(
        () => Namefully.of(
            [Name.prefix('mr '), FirstName('John'), LastName('Doe')],
            config: config),
        throwsValidationException,
      );
      expect(() => Validators.prefix.validate(Name.prefix('mr.')),
          throwsValidationException);
      expect(() => Validators.suffix.validate(Name.suffix('PhD ')),
          throwsValidationException);
    });

    test('is thrown if the json name values are incorrect', () {
      expect(
        () => Namefully.fromJson({
          'firstName': 'J4ne',
          'lastName': 'Doe',
        }, config: config),
        throwsValidationException,
      );
      expect(
        () => Validators.nama.validate({
          Namon.prefix: '',
          Namon.firstName: 'Jane',
          Namon.lastName: 'Smith',
        }),
        throwsValidationException,
      );
    });

    test('is thrown if a string list breaks the validation rules', () {
      expect(
        () => Namefully.fromList(['j4ne', 'doe'], config: config),
        throwsValidationException,
      );
    });
  });

  group('InputException', () {
    test('is thrown if the json name keys are not as expected', () {
      expect(
        () => Namefully.fromJson({'firstname': 'Jane', 'lastName': 'Doe'}),
        throwsInputException,
      );
      expect(
        () => Namefully.fromJson({'firstName': 'Jane', 'lastname': 'Doe'}),
        throwsInputException,
      );
      expect(() => Namefully.fromJson({}), throwsInputException);

      expect(
        () => Validators.nama.validate({Namon.prefix: ''}),
        throwsInputException,
      );
      expect(
        () => Validators.nama.validate({
          Namon.prefix: 'Mr',
          Namon.firstName: 'John',
        }),
        throwsInputException,
      );
      expect(
        () => Validators.nama.validate({
          Namon.prefix: 'Mr',
          Namon.lastName: 'Smith',
        }),
        throwsInputException,
      );
    });

    test('is thrown if a string list has an unsupported number of entries', () {
      expect(() => Namefully.fromList([]), throwsInputException);
      expect(
        () => Namefully.fromList(['jane']),
        throwsInputException,
      );
      expect(
        () => Namefully.fromList([
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
      var name = Name.first('jane-');
      expect(() => Namefully.of([]), throwsInputException);
      expect(() => Namefully.of([name]), throwsInputException);
      expect(
        () => Namefully.of([
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
      expect(() => Validators.firstName.validate(1), throwsInputException);
      expect(() => Validators.firstName.validate(true), throwsInputException);
    });

    test('is thrown if the wrong argument is provided for a middle name', () {
      expect(() => Validators.middleName.validate(1), throwsInputException);
      expect(() => Validators.middleName.validate(true), throwsInputException);
    });

    test('is thrown if the wrong argument is provided for a last name', () {
      expect(() => Validators.lastName.validate(1), throwsInputException);
      expect(() => Validators.lastName.validate(true), throwsInputException);
    });
  });

  group('NotAllowedException', () {
    test('is thrown if wrong key params are given when formatting', () {
      final name = Namefully('Jane Doe');
      for (var k in ['[', '{', '^', '!', '@', '#', 'a', 'c', 'd']) {
        expect(() => name.format(k), throwsNotAllowedException);
      }
    });

    test('is thrown if a derivative builder executes after being closed', () {
      var derivative = Namefully('Jane Doe').derivative
        ..byLastName() // orders the name by last name
        ..upper() // makes the name uppercase
        ..done(); // closes the name builder.

      expect(derivative.isDone, equals(true));
      expect(() => derivative.lower(), throwsNotAllowedException);
      expect(derivative.context.toString(), equals('DOE JANE'));
    });
  });

  group('UnknownException', () {
    test('is thrown if a json name cannot be parsed from FullName', () {
      expect(
        () => FullName.fromJson({'firstname': 'Jane', 'lastname': 'Doe'}),
        throwsUnknownException,
      );
      expect(
        () => FullName.fromJson({}),
        throwsUnknownException,
      );
    });
  });

  group('NameException', () {
    const String name = 'Jane Doe', message = 'Wrong name';

    test('can be created with a message only', () {
      NameException exception = NameException(message, name);

      expect(exception, isA<Exception>());
      expect(exception.message, equals(message));
      expect(exception.source, equals(name));
      expect(exception.sourceAsString, equals(name));
      expect(exception.type, equals(NameExceptionType.unknown));
      expect(exception.toString(), '_NameException ($name): $message');
    });

    test('can be created for wrong input', () {
      NameException exception =
          NameException.input(source: ['Jane', 'Doe'], message: message);

      expect(exception, isA<Exception>());
      expect(exception.message, equals(message));
      expect(exception.source, equals(['Jane', 'Doe']));
      expect(exception.sourceAsString, equals(name));
      expect(exception.type, equals(NameExceptionType.input));
      expect(exception.toString(), 'InputException ($name): $message');
    });

    test('can be created for validation purposes', () {
      NameException exception = NameException.validation(
          source: [FirstName('Jane'), LastName('Doe')],
          nameType: 'firstName',
          message: message);

      expect(exception, isA<Exception>());
      expect(exception.message, equals(message));
      expect(exception.source, equals([FirstName('Jane'), LastName('Doe')]));
      expect(exception.sourceAsString, equals(name));
      expect(exception.type, equals(NameExceptionType.validation));
      expect(exception.toString(),
          "ValidationException (firstName='$name'): $message");
    });

    test('can be created for unsupported operations', () {
      NameException exception = NameException.notAllowed(
          source: name, operation: 'lower', message: message);

      expect(exception, isA<Exception>());
      expect(exception.message, equals(message));
      expect(exception.source, equals(name));
      expect(exception.sourceAsString, equals(name));
      expect(exception.type, equals(NameExceptionType.notAllowed));
      expect(exception.toString(),
          'NotAllowedException ($name) - lower: $message');
    });

    test('can be created for unknown use cases', () {
      final exception = UnknownException(source: name);

      expect(exception, isA<NameException>());
      expect(exception.stackTrace, isNull);
      expect(exception.type, equals(NameExceptionType.unknown));
      expect(exception.toString(), 'UnknownException ($name)');
    });

    test('is thrown if wrong name type is being validated', () {
      expect(
        () => Validators.middleName
            .validate([Name.middle('Mary'), Name.last('Doe')]),
        throwsNameException,
      );
    });
  });
}
