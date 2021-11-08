import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  var config = Config.inline(bypass: false);

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
    });

    test('is thrown if any part of a last name breaks the validation rules',
        () {
      expect(
        () => Namefully('Jane Do3', config: config),
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
            [Name('mr ', Namon.prefix), FirstName('John'), LastName('Doe')],
            config: config),
        throwsValidationException,
      );
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
        () => Namefully.fromJson({
          'prefix': '',
          'firstName': 'Jane',
          'lastName': 'Smith',
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
        () => Namefully.fromJson({'firstname': 'Jane', 'lastName': 'Doe'},
            config: config),
        throwsInputException,
      );
      expect(
        () => Namefully.fromJson({'firstName': 'Jane', 'lastname': 'Doe'}),
        throwsInputException,
      );
      expect(() => Namefully.fromJson({}), throwsInputException);
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
      var name = Name('jane-', Namon.firstName);
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
  });
}
