import 'package:namefully/namefully.dart';
import 'package:namefully/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Utils', () {
    test(
        'NameIndex.when() provides the name indexes from a list of names when '
        'ordered by first name', () {
      var indexes = NameIndex.when(NameOrder.firstName, 2);
      expect(indexes.firstName, equals(0));
      expect(indexes.lastName, equals(1));

      indexes = NameIndex.when(NameOrder.firstName, 3);
      expect(indexes.firstName, equals(0));
      expect(indexes.middleName, equals(1));
      expect(indexes.lastName, equals(2));

      indexes = NameIndex.when(NameOrder.firstName, 4);
      expect(indexes.prefix, equals(0));
      expect(indexes.firstName, equals(1));
      expect(indexes.middleName, equals(2));
      expect(indexes.lastName, equals(3));

      indexes = NameIndex.when(NameOrder.firstName, 5);
      expect(indexes.prefix, equals(0));
      expect(indexes.firstName, equals(1));
      expect(indexes.middleName, equals(2));
      expect(indexes.lastName, equals(3));
      expect(indexes.suffix, equals(4));
    });

    test(
        'NameIndex.when() provides the name indexes from a list of names when '
        'ordered by last name', () {
      var indexes = NameIndex.when(NameOrder.lastName, 2);
      expect(indexes.lastName, equals(0));
      expect(indexes.firstName, equals(1));

      indexes = NameIndex.when(NameOrder.lastName, 3);
      expect(indexes.lastName, equals(0));
      expect(indexes.firstName, equals(1));
      expect(indexes.middleName, equals(2));

      indexes = NameIndex.when(NameOrder.lastName, 4);
      expect(indexes.prefix, equals(0));
      expect(indexes.lastName, equals(1));
      expect(indexes.firstName, equals(2));
      expect(indexes.middleName, equals(3));

      indexes = NameIndex.when(NameOrder.lastName, 5);
      expect(indexes.prefix, equals(0));
      expect(indexes.lastName, equals(1));
      expect(indexes.firstName, equals(2));
      expect(indexes.middleName, equals(3));
      expect(indexes.suffix, equals(4));
    });

    test('NameIndex.when() provides a base indexing for wrong counts', () {
      var indexes = NameIndex.when(NameOrder.firstName, 0);
      expect(indexes.firstName, equals(0));
      expect(indexes.lastName, equals(1));
      expect(indexes.prefix, equals(-1));
      expect(indexes.middleName, equals(-1));
      expect(indexes.suffix, equals(-1));

      indexes = NameIndex.when(NameOrder.lastName, 0);
      expect(indexes.firstName, equals(0));
      expect(indexes.lastName, equals(1));
      expect(indexes.prefix, equals(-1));
      expect(indexes.middleName, equals(-1));
      expect(indexes.suffix, equals(-1));
    });

    test('.capitalize() capitalizes a string accordingly', () {
      expect(capitalize(''), equals(''));
      expect(capitalize('stRiNg'), equals('String'));
      expect(capitalize('stRiNg', CapsRange.initial), equals('String'));
      expect(capitalize('StRiNg', CapsRange.all), equals('STRING'));
      expect(capitalize('StRiNg', CapsRange.none), equals('StRiNg'));
    });

    test('.decapitalize() de-capitalizes a string accordingly', () {
      expect(decapitalize(''), equals(''));
      expect(decapitalize('StRiNg'), equals('stRiNg'));
      expect(decapitalize('StRiNg', CapsRange.initial), equals('stRiNg'));
      expect(decapitalize('StRiNg', CapsRange.all), equals('string'));
      expect(decapitalize('StRiNg', CapsRange.none), equals('StRiNg'));
    });

    test('.toggleCase() toggles a string accordingly', () {
      expect(toggleCase('toggle'), equals('TOGGLE'));
      expect(toggleCase('toGGlE'), equals('TOggLe'));
    });
  });

  group('Separator', () {
    test('should have some explicit tokens', () {
      const tokens = [',', ':', '"', '', '-', '.', ';', "'", ' ', '_'];
      expect(Separator.tokens.length, equals(tokens.length));
      expect(Separator.tokens.containsAll(tokens), equals(true));

      expect(Separator.period.token, equals('.'));
      expect(Separator.period.name, equals('period'));
      expect(Separator.period.toString(), equals('Separator.period'));

      expect(Separator.comma.hashCode != Separator.colon.hashCode, true);
    });
  });
}
