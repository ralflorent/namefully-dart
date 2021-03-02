import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Name', () {
    Name name;

    setUp(() {
      name = Name('John', Namon.middleName);
    });

    test('creates a name marked with a specific type', () {
      expect(name.namon, 'John');
      expect(name.type, Namon.middleName);
    });

    test('creates a name with its initial capitalized', () {
      expect(Name('ben', Namon.firstName, Uppercase.initial).toString(), 'Ben');
    });

    test('creates a name fully capitalized', () {
      expect(Name('rick', Namon.firstName, Uppercase.all).toString(), 'RICK');
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
}
