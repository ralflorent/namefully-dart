import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Name', () {
    late Name name;

    setUp(() => name = Name('John', Namon.middleName));

    test('throws an exception if a name is less than 2 characters', () {
      expect(() => Name('', Namon.firstName), throwsInputException);
    });

    test('creates a name marked with a specific type', () {
      expect(name.namon, 'John');
      expect(name.length, equals(4));
      expect(name.hashCode != name.namon.hashCode, isTrue);
      expect(name.toString(), 'John');
      expect(name.type, Namon.middleName);
    });

    test('creates a name with its initial capitalized', () {
      expect(Name('ben', Namon.firstName, CapsRange.initial).toString(), 'Ben');
    });

    test('creates a name fully capitalized', () {
      expect(Name('rick', Namon.firstName, CapsRange.all).toString(), 'RICK');
    });

    test('== [Name] returns true if they are equal', () {
      expect(name == Name('John', Namon.middleName), equals(true));
      expect(name == Name('Johnx', Namon.middleName), equals(false));
      expect(name == Name('John', Namon.prefix), equals(false));
    });

    test('.stats() returns a summary of the name', () {
      var summary = name.stats();
      expect(summary.count, equals(name.length));
      expect(summary.distribution, equals({'J': 1, 'O': 1, 'H': 1, 'N': 1}));
    });

    test('.initials() returns only the initials of the name', () {
      expect(name.initials(), equals(['J']));
    });

    test('.caps() capitalizes the name afterwards', () {
      expect((name..caps()).toString(), 'John');
      expect((name..caps(CapsRange.all)).toString(), 'JOHN');
    });

    test('.decaps() de-capitalizes the name afterwards', () {
      var n = Name('MORTY', Namon.firstName);
      expect((n..decaps()).toString(), 'mORTY');
      expect((n..decaps(CapsRange.all)).toString(), 'morty');
    });

    test('.normalize() normalizes the name afterward', () {
      expect((Name('MR', Namon.prefix)..normalize()).toString(), 'Mr');
    });

    test('.passwd() returns a password-like representation of the name', () {
      expect(name.passwd(), isNot(contains('John')));
    });
  });

  group('FirstName', () {
    late FirstName firstName;

    setUp(() => firstName = FirstName('John', ['Ben', 'Carl']));

    test('creates a first name', () {
      var name = FirstName('John');
      expect(name.toString(), equals('John'));
      expect(name.more, equals([]));
      expect(name.type, equals(Namon.firstName));
      expect(name.length, equals(4));
    });

    test('creates a first name with additional parts', () {
      expect(firstName.toString(), equals('John'));
      expect(firstName.more, equals(['Ben', 'Carl']));
      expect(firstName.type, equals(Namon.firstName));
    });

    test('.hasMore() indicates if a first name has more than 1 name part', () {
      expect(firstName.hasMore(), equals(true));
      expect(FirstName('John').hasMore(), equals(false));
    });

    test('.asNames() returns the name parts as a pile of [Name]s', () {
      var names = firstName.asNames();
      expect(names.length, equals(3));
      expect(names.first.toString(), equals('John'));
      for (var name in names) {
        expect(name, isA<Name>());
        expect(name.type, equals(Namon.firstName));
      }
    });

    test('.toString() returns a string version of the first name', () {
      expect(firstName.toString(), equals('John'));
      expect(firstName.toString(includeAll: true), equals('John Ben Carl'));
    });

    test('.stats() returns only a summary of the specified parts', () {
      expect(firstName.stats().count, equals(4));
      expect(firstName.stats(includeAll: true).count, equals(11));
      expect(firstName.stats(includeAll: true).length, equals(13));
      expect(firstName.length, equals(11));
    });

    test('.initials() returns only the initials of the specified parts', () {
      expect(firstName.initials(), equals(['J']));
      expect(firstName.initials(includeAll: true), equals(['J', 'B', 'C']));
    });

    test('.caps() capitalizes a first name afterwards', () {
      var name = FirstName('john', ['ben', 'carl']);
      expect((name..caps()).toString(), equals('John'));
      expect((name..caps()).toString(includeAll: true), 'John Ben Carl');
    });

    test('.caps() capitalizes all parts of a first name afterwards', () {
      expect((firstName..caps(CapsRange.all)).toString(), equals('JOHN'));
      expect(
        (firstName..caps(CapsRange.all)).toString(includeAll: true),
        equals('JOHN BEN CARL'),
      );
    });

    test('.decaps() de-capitalizes a first name afterwards', () {
      var name = FirstName('JOHN', ['BEN', 'CARL']);
      expect((name..decaps()).toString(), equals('jOHN'));
      expect((name..decaps()).toString(includeAll: true), 'jOHN bEN cARL');
    });

    test('.decaps() de-capitalizes all parts of a first name afterwards', () {
      var name = FirstName('JOHN', ['BEN', 'CARL']);
      expect((name..decaps(CapsRange.all)).toString(), equals('john'));
      expect(
        (name..decaps(CapsRange.all)).toString(includeAll: true),
        equals('john ben carl'),
      );
    });

    test('.normalize() normalizes a first name afterwards', () {
      expect((FirstName('JOHN')..normalize()).toString(), equals('John'));
      expect(
          (FirstName('JOHN', ['BEN', 'CARL'])..normalize())
              .toString(includeAll: true),
          equals('John Ben Carl'));
    });

    test('.passwd() returns a password-like of the first name', () {
      expect(firstName.passwd(), isNot(contains('John')));
      expect(
        firstName.passwd(includeAll: true),
        isNot(contains('John Ben Carl')),
      );
    });
  });

  group('LastName', () {
    late LastName lastName;

    setUp(() => lastName = LastName('Smith', 'Doe'));

    test('creates a last name with a father surname only', () {
      var name = LastName('Smith');
      expect(name.father, equals('Smith'));
      expect(name.hasMother(), equals(false));
      expect(name.mother, equals(isNull));
      expect(name.toString(format: Surname.mother), equals(isEmpty));
      expect(name.type, equals(Namon.lastName));
    });

    test('creates a last name with both father and mother surnames', () {
      expect(lastName.father, equals('Smith'));
      expect(lastName.hasMother(), equals(true));
      expect(lastName.toString(format: Surname.mother), equals('Doe'));
      expect(lastName.type, equals(Namon.lastName));
    });

    test('creates a last name with a [Surname.mother] format', () {
      expect(LastName('Smith', 'Doe', Surname.mother).toString(), 'Doe');
    });

    test('creates a last name with a [Surname.hyphenated] format', () {
      expect(
        LastName('Smith', 'Doe', Surname.hyphenated).toString(),
        equals('Smith-Doe'),
      );
    });

    test('creates a last name with a [Surname.all] format', () {
      expect(
        LastName('Smith', 'Doe', Surname.all).toString(),
        equals('Smith Doe'),
      );
    });

    test('.toString() outputs a last name with a specific format', () {
      expect(lastName.toString(), equals('Smith'));
      expect(lastName.toString(format: Surname.mother), 'Doe');
      expect(
        lastName.toString(format: Surname.hyphenated),
        equals('Smith-Doe'),
      );
      expect(lastName.toString(format: Surname.all), 'Smith Doe');
    });

    test('.stats() returns only a summary of the specified parts', () {
      expect(lastName.stats().count, equals(5));
      expect(lastName.stats(format: Surname.mother).count, equals(3));
      expect(lastName.stats(format: Surname.all).count, equals(8));
      expect(lastName.stats(format: Surname.all).length, equals(9));
      expect(lastName.length, equals(8));
    });

    test('.initials() returns only the initials of the specified parts', () {
      expect(lastName.initials(), equals(['S']));
      expect(lastName.initials(format: Surname.mother), equals(['D']));
      expect(
        lastName.initials(format: Surname.hyphenated),
        equals(['S', 'D']),
      );
      expect(lastName.initials(format: Surname.all), equals(['S', 'D']));
    });

    test('.caps() capitalizes a last name afterwards', () {
      var name = LastName('sánchez');
      expect((name..caps()).toString(), equals('Sánchez'));
      expect((name..caps(CapsRange.all)).toString(), equals('SÁNCHEZ'));
    });

    test('.caps() capitalizes all parts of the last name afterwards', () {
      expect((lastName..caps(CapsRange.all)).toString(), equals('SMITH'));
      expect(
        (lastName..caps(CapsRange.all)).toString(format: Surname.all),
        equals('SMITH DOE'),
      );
    });

    test('.decaps() de-capitalizes the last name afterwards', () {
      var name = LastName('SMITH', 'DOE');
      expect((name..decaps()).toString(), equals('sMITH'));
      expect(
        (name..decaps()).toString(format: Surname.all),
        'sMITH dOE',
      );
    });

    test('.decaps() de-capitalizes all parts of a last name afterwards', () {
      var name = LastName('SMITH', 'DOE');
      expect((name..decaps(CapsRange.all)).toString(), equals('smith'));
      expect(
        (name..decaps(CapsRange.all)).toString(format: Surname.all),
        equals('smith doe'),
      );
    });

    test('.normalize() normalizes the last name afterwards', () {
      expect((LastName('SMITH')..normalize()).toString(), equals('Smith'));
      expect(
        (LastName('SMITH', 'DOE')..normalize()).toString(format: Surname.all),
        equals('Smith Doe'),
      );
    });

    test('.passwd() returns a password-like of the last name', () {
      expect(lastName.passwd(), isNot(contains('Smith')));
      expect(lastName.passwd(), isNot(contains('Smith Doe')));
    });
  });

  group('Summary', () {
    test('throws an exception if a value is less than 2 characters', () {
      expect(() => Summary('a'), throwsInputException);
    });

    test('creates a statistically descriptive summary of a string', () {
      var summary = Summary('abracadabra');
      expect(summary.count, equals(11));
      expect(summary.length, equals(11));
      expect(summary.frequency, equals(5));
      expect(summary.unique, equals(5));
      expect(summary.top, equals('A'));
      expect(
        summary.distribution,
        equals({
          'A': 5,
          'B': 2,
          'R': 2,
          'C': 1,
          'D': 1,
        }),
      );
    });

    test('creates a descriptive summary of string with defined restrictions',
        () {
      var summary = Summary('abracadabra', restrictions: ['a']);
      expect(summary.count, equals(6));
      expect(summary.length, equals(11));
      expect(summary.frequency, equals(2));
      expect(summary.unique, equals(4));
      expect(summary.top, equals('R'));
      expect(summary.distribution, equals({'B': 2, 'R': 2, 'C': 1, 'D': 1}));
    });

    test(
        'creates a descriptive summary of a string with space as a default'
        'defined restrictions', () {
      var summary = Summary('avada kedavra');
      expect(summary.count, equals(12));
      expect(summary.length, equals(13));
      expect(summary.frequency, equals(5));
      expect(summary.unique, equals(6));
      expect(summary.top, equals('A'));
      expect(
        summary.distribution,
        equals({'A': 5, 'V': 2, 'D': 2, 'K': 1, 'E': 1, 'R': 1}),
      );
    });
  });
}
