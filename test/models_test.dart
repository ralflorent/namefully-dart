import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Name', () {
    var name = Name('John', Namon.middleName);

    setUp(() {
      name = Name('John', Namon.middleName);
    });

    test('creates a name marked with a specific type', () {
      expect(name.namon, 'John');
      expect(name.toString(), 'John');
      expect(name.type, Namon.middleName);
    });

    test('creates a name with its initial capitalized', () {
      expect(Name('ben', Namon.firstName, Uppercase.initial).toString(), 'Ben');
    });

    test('creates a name fully capitalized', () {
      expect(Name('rick', Namon.firstName, Uppercase.all).toString(), 'RICK');
    });

    test('== [Name] returns true if they are equal', () {
      expect(name == Name('John', Namon.middleName), equals(true));
      expect(name == Name('Johnx', Namon.middleName), equals(false));
      expect(name == Name('John', Namon.prefix), equals(false));
    });

    test('.stats() returns a summary of the name', () {
      var summary = name.stats();
      expect(summary.count, equals(4));
      expect(summary.distribution, equals({'J': 1, 'o': 1, 'h': 1, 'n': 1}));
    });

    test('.initials() returns only the initials of the name', () {
      expect(name.initials(), equals(['J']));
    });

    test('.caps() capitalizes the name afterwards', () {
      expect((name..caps()).toString(), 'John');
      expect((name..caps(Uppercase.all)).toString(), 'JOHN');
    });

    test('.decaps() de-capitalizes the name afterwards', () {
      var n = Name('MORTY', Namon.firstName);
      expect((n..decaps()).toString(), 'mORTY');
      expect((n..decaps(Uppercase.all)).toString(), 'morty');
    });

    test('.normalize() normalizes the name afterward', () {
      expect((Name('MR', Namon.prefix)..normalize()).toString(), 'Mr');
    });

    test('.passwd() returns a password-like representation of the name', () {
      expect(name.passwd(), isNot(contains('John')));
    });
  });

  group('FirstName', () {
    var firstName = FirstName('John', ['Ben', 'Carl']);
    setUp(() {
      firstName = FirstName('John', ['Ben', 'Carl']);
    });

    test('creates a first name', () {
      var name = FirstName('John');
      expect(name.toString(), equals('John'));
      expect(name.more, equals([]));
      expect(name.type, equals(Namon.firstName));
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
    });

    test('.initials() returns only the initials of the specified parts', () {
      expect(firstName.initials(), equals(['J']));
      expect(firstName.initials(includeAll: true), equals(['J', 'B', 'C']));
    });

    test('.caps() capitalizes a first name afterwards', () {
      var name = FirstName('john', ['ben', 'carl']);
      expect((name..caps()).toString(), equals('John'));
      expect(
          (name..caps()).toString(includeAll: true), equals('John Ben Carl'));
    });

    test('.caps() capitalizes all parts of a first name afterwards', () {
      expect((firstName..caps(Uppercase.all)).toString(), equals('JOHN'));
      expect((firstName..caps(Uppercase.all)).toString(includeAll: true),
          equals('JOHN BEN CARL'));
    });

    test('.decaps() de-capitalizes a first name afterwards', () {
      var name = FirstName('JOHN', ['BEN', 'CARL']);
      expect((name..decaps()).toString(), equals('jOHN'));
      expect((name..decaps()).toString(includeAll: true), 'jOHN bEN cARL');
    });

    test('.decaps() de-capitalizes all parts of a first name afterwards', () {
      var name = FirstName('JOHN', ['BEN', 'CARL']);
      expect((name..decaps(Uppercase.all)).toString(), equals('john'));
      expect((name..decaps(Uppercase.all)).toString(includeAll: true),
          equals('john ben carl'));
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
          firstName.passwd(includeAll: true), isNot(contains('John Ben Carl')));
    });
  });

  group('LastName', () {
    var lastName = LastName('Smith', 'Doe');
    setUp(() {
      lastName = LastName('Smith', 'Doe');
    });

    test('creates a last name with a father surname only', () {
      var name = LastName('Smith');
      expect(name.father, equals('Smith'));
      expect(name.hasMother(), equals(false));
      expect(name.toString(format: LastNameFormat.mother), equals(isNull));
      expect(name.type, equals(Namon.lastName));
    });

    test('creates a last name with both father and mother surnames', () {
      expect(lastName.father, equals('Smith'));
      expect(lastName.hasMother(), equals(true));
      expect(lastName.toString(format: LastNameFormat.mother), equals('Doe'));
      expect(lastName.type, equals(Namon.lastName));
    });

    test('creates a last name with a [LastNameFormat.mother] format', () {
      expect(LastName('Smith', 'Doe', LastNameFormat.mother).toString(),
          equals('Doe'));
    });

    test('creates a last name with a [LastNameFormat.hyphenated] format', () {
      expect(LastName('Smith', 'Doe', LastNameFormat.hyphenated).toString(),
          equals('Smith-Doe'));
    });

    test('creates a last name with a [LastNameFormat.all] format', () {
      expect(LastName('Smith', 'Doe', LastNameFormat.all).toString(),
          equals('Smith Doe'));
    });

    test('.toString() outputs a last name with a specific format', () {
      expect(lastName.toString(), equals('Smith'));
      expect(lastName.toString(format: LastNameFormat.mother), 'Doe');
      expect(lastName.toString(format: LastNameFormat.hyphenated),
          equals('Smith-Doe'));
      expect(
          lastName.toString(format: LastNameFormat.all), equals('Smith Doe'));
    });

    test('.stats() returns only a summary of the specified parts', () {
      expect(lastName.stats().count, equals(5));
      // expect(lastName.stats(format: LastNameFormat.all).count, equals(11));
      // expect(lastName.stats(format: LastNameFormat.all).length, equals(13));
    });

    test('.initials() returns only the initials of the specified parts', () {
      expect(lastName.initials(), equals(['S']));
      expect(lastName.initials(format: LastNameFormat.all), equals(['S', 'D']));
    });
  });
}
