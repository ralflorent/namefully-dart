import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Namefully', () {
    group('(default settings)', () {
      var name = Namefully(
        'Mr John Ben Smith Ph.D',
        config: Config.inline(
          name: 'generic',
          orderedBy: NameOrder.firstName,
        ),
      );

      setUp(() {
        name = Namefully(
          'Mr John Ben Smith Ph.D',
          config: Config.inline(
            name: 'generic',
            orderedBy: NameOrder.firstName,
          ),
        );
      });

      test('.has() determines if the full name has a specific namon', () {
        expect(name.has(Namon.prefix), equals(true));
        expect(name.has(Namon.suffix), equals(true));
        expect(name.has(Namon.middleName), equals(true));
        expect(name.hasMiddleName(), equals(true));
      });

      test('.toString() returns a String version of the full name', () {
        expect(name.toString(), equals('Mr John Ben Smith Ph.D'));
      });

      test('.toMap() returns a Map<String, String> version of the full name',
          () {
        expect(
            name.toMap(),
            equals({
              'prefix': 'Mr',
              'firstName': 'John',
              'middleName': 'Ben',
              'lastName': 'Smith',
              'suffix': 'Ph.D',
            }));
      });

      test('.toList() returns a List<String> version of the full name', () {
        expect(name.toList(), equals(['Mr', 'John', 'Ben', 'Smith', 'Ph.D']));
      });

      test('.stats() returns the summary of the birth name', () {
        var summary = name.stats(what: NameType.birthName);
        expect(summary?.count, equals(12));
        expect(summary?.length, equals(14));
        expect(summary?.frequency, equals(2));
        expect(summary?.top, equals('N'));
        expect(summary?.unique, equals(10));
        expect(
            summary?.distribution,
            equals({
              'J': 1,
              'O': 1,
              'H': 2,
              'N': 2,
              'B': 1,
              'E': 1,
              'S': 1,
              'M': 1,
              'I': 1,
              'T': 1,
            }));
        expect(name.count, equals(12));
        expect(name.length, equals(14));
      });

      test('.stats() returns the summary of a specified namon', () {
        expect(name.stats(what: NameType.firstName)?.count, equals(4));
        expect(name.stats(what: NameType.middleName)?.count, equals(3));
        expect(name.stats(what: NameType.lastName)?.count, equals(5));
      });

      test('.format() formats a full name as desired', () {
        expect(name.format(), equals('Mr SMITH, John Ben Ph.D'));
        expect(name.format('short'), equals('John Smith'));
        expect(name.format('long'), equals('John Ben Smith'));
        expect(name.format('official'), equals('Mr SMITH, John Ben Ph.D'));

        expect(name.format('B'), equals('JOHN BEN SMITH'));
        expect(name.format('F'), equals('JOHN'));
        expect(name.format('L'), equals('SMITH'));
        expect(name.format('M'), equals('BEN'));
        expect(name.format('O'), equals('MR SMITH, JOHN BEN PH.D'));
        expect(name.format('P'), equals('MR'));
        expect(name.format('S'), equals('PH.D'));

        expect(name.format('b'), equals('John Ben Smith'));
        expect(name.format('f'), equals('John'));
        expect(name.format('l'), equals('Smith'));
        expect(name.format('m'), equals('Ben'));
        expect(name.format('o'), equals('Mr SMITH, John Ben Ph.D'));
        expect(name.format('p'), equals('Mr'));
        expect(name.format('s'), equals('Ph.D'));
      });

      test('throws error for wrong key params when formatting', () {
        ['[', '{', '^', '!', '@', '#', 'a', 'c', 'd']
            .forEach((k) => expect(() => name.format(k), throwsArgumentError));
      });

      test('.to() converts a birth name to a specific capitalization case', () {
        expect(name.to(Capitalization.lower), equals('john ben smith'));
        expect(name.to(Capitalization.upper), equals('JOHN BEN SMITH'));
        expect(name.to(Capitalization.camel), equals('johnBenSmith'));
        expect(name.to(Capitalization.pascal), equals('JohnBenSmith'));
        expect(name.to(Capitalization.snake), equals('john_ben_smith'));
        expect(name.to(Capitalization.hyphen), equals('john-ben-smith'));
        expect(name.to(Capitalization.dot), equals('john.ben.smith'));
        expect(name.to(Capitalization.toggle), equals('jOHN bEN sMITH'));

        // Alternatives are:
        expect(name.lower(), equals('john ben smith'));
        expect(name.upper(), equals('JOHN BEN SMITH'));
        expect(name.camel(), equals('johnBenSmith'));
        expect(name.pascal(), equals('JohnBenSmith'));
        expect(name.snake(), equals('john_ben_smith'));
        expect(name.hyphen(), equals('john-ben-smith'));
        expect(name.dot(), equals('john.ben.smith'));
        expect(name.toggle(), equals('jOHN bEN sMITH'));
      });

      test('.split() splits the birth name according to a pattern', () {
        expect(name.split(), equals(['John', 'Ben', 'Smith']));
      });

      test('.join() joins each piece of the birth name with a separator', () {
        expect(name.join('+'), equals('John+Ben+Smith'));
      });

      test('.passwd() returns a password-like of the birth name', () {
        expect(name.passwd(), isNot(contains('John Ben Smith')));
        expect(name.passwd(NameType.firstName), isNot(contains('John')));
        expect(name.passwd(NameType.middleName), isNot(contains('Ben')));
        expect(name.passwd(NameType.lastName), isNot(contains('Smith')));
      });

      test('.flip() flips the name order from the current config', () {
        name.flip(); // was before ordered by firstName.
        expect(name.birthName(), equals('Smith John Ben'));
        name.flip(); // flip back to the firstName name order.
      });
    });

    group('(by first name)', () {
      var name = Namefully(
        'Mr John Ben Smith Ph.D',
        config: Config.inline(
          name: 'byFirstName',
          orderedBy: NameOrder.firstName,
        ),
      );

      setUp(() {
        name = Namefully(
          'Mr John Ben Smith Ph.D',
          config: Config.inline(
            name: 'byFirstName',
            orderedBy: NameOrder.firstName,
          ),
        );
      });

      test('creates a full name', () {
        expect(name.prefix(), 'Mr');
        expect(name.firstName(), 'John');
        expect(name.middleName(), equals(['Ben']));
        expect(name.lastName(), 'Smith');
        expect(name.suffix(), 'Ph.D');
        expect(name.fullName(), 'Mr John Ben Smith Ph.D');
        expect(name.fullName(NameOrder.lastName), 'Mr Smith John Ben Ph.D');
        expect(name.birthName(), 'John Ben Smith');
        expect(name.birthName(NameOrder.lastName), 'Smith John Ben');
      });

      test('.initials() returns the initials of the full name', () {
        expect(name.initials(), equals(['J', 'S']));
        expect(name.initials(withMid: true), equals(['J', 'B', 'S']));
        expect(
            name.initials(orderedBy: NameOrder.lastName), equals(['S', 'J']));
        expect(name.initials(orderedBy: NameOrder.lastName, withMid: true),
            equals(['S', 'J', 'B']));
      });

      test('.shorten() shortens a full name to a first and last name', () {
        expect(name.shorten(), equals('John Smith'));
        expect(name.shorten(orderedBy: NameOrder.lastName), 'Smith John');
      });

      test('.flatten() flattens a full name based on specs', () {
        expect(name.flatten(limit: 12, by: FlattenedBy.middleName),
            equals('John B. Smith'));
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'John B. S.');
        expect(name.zip(by: FlattenedBy.firstName), 'J. Ben Smith');
        expect(name.zip(by: FlattenedBy.middleName), 'John B. Smith');
        expect(name.zip(by: FlattenedBy.lastName), 'John Ben S.');
        expect(name.zip(by: FlattenedBy.firstMid), 'J. B. Smith');
        expect(name.zip(by: FlattenedBy.midLast), 'John B. S.');
      });
    });

    group('(by last name)', () {
      var name = Namefully(
        'Mr Smith John Ben Ph.D',
        config: Config.inline(
          name: 'byLastName',
          orderedBy: NameOrder.lastName,
        ),
      );

      setUp(() {
        name = Namefully(
          'Mr Smith John Ben Ph.D',
          config: Config.inline(
            name: 'byLastName',
            orderedBy: NameOrder.lastName,
          ),
        );
      });

      test('creates a full name', () {
        expect(name.prefix(), 'Mr');
        expect(name.firstName(), 'John');
        expect(name.middleName(), equals(['Ben']));
        expect(name.lastName(), 'Smith');
        expect(name.suffix(), 'Ph.D');
        expect(name.fullName(), 'Mr Smith John Ben Ph.D');
        expect(name.fullName(NameOrder.firstName), 'Mr John Ben Smith Ph.D');
        expect(name.birthName(), 'Smith John Ben');
        expect(name.birthName(NameOrder.firstName), 'John Ben Smith');
      });

      test('.initials() returns the initials of the full name', () {
        expect(name.initials(), equals(['S', 'J']));
        expect(name.initials(withMid: true), equals(['S', 'J', 'B']));
        expect(
            name.initials(orderedBy: NameOrder.firstName), equals(['J', 'S']));
        expect(name.initials(orderedBy: NameOrder.firstName, withMid: true),
            equals(['J', 'B', 'S']));
      });

      test('.shorten() shortens a full name to a first and last name', () {
        expect(name.shorten(), 'Smith John');
        expect(
            name.shorten(orderedBy: NameOrder.firstName), equals('John Smith'));
      });

      test('.flatten() flattens a full name based on specs', () {
        expect(name.flatten(limit: 12, by: FlattenedBy.middleName),
            equals('Smith John B.'));
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'S. John B.');
        expect(name.zip(by: FlattenedBy.firstName), 'Smith J. Ben');
        expect(name.zip(by: FlattenedBy.middleName), 'Smith John B.');
        expect(name.zip(by: FlattenedBy.lastName), 'S. John Ben');
        expect(name.zip(by: FlattenedBy.firstMid), 'Smith J. B.');
        expect(name.zip(by: FlattenedBy.midLast), 'S. John B.');
      });
    });

    group('can be instantiated with', () {
      test('String', () {
        expect(Namefully('John Smith').toString(), equals('John Smith'));
      });

      test('List<String>', () {
        expect(Namefully.fromList(['John', 'Smith']).toString(),
            equals('John Smith'));
      });

      test('Map<String, String>', () {
        expect(
            Namefully.fromJson({'firstName': 'John', 'lastName': 'Smith'})
                .toString(),
            equals('John Smith'));
      });

      test('List<Name>', () {
        expect(Namefully.of([FirstName('John'), LastName('Smith')]).toString(),
            equals('John Smith'));
        expect(
            Namefully.of([
              Name('John', Namon.firstName),
              Name('Smith', Namon.lastName),
            ]).toString(),
            equals('John Smith'));
      });

      test('FullName', () {
        // var fullName =
        expect(
            Namefully.from(FullName()
                  ..rawFirstName('John')
                  ..rawLastName('Smith'))
                .toString(),
            equals('John Smith'));
      });

      test('Parser', () {
        var parser = SimpleParser('John#Smith');
        var config = Config.inline(name: 'simpleParser', parser: parser);
        expect(Namefully.fromParser(config).toString(), equals('John Smith'));
      });
    });

    // group('built with other settings', () {
    //   test('.firstName() returns a first name', () {
    //     var name = Namefully('John Smith', config: Config.inline(name: 'v1'));
    //     expect(name.firstName(), equals('John'));
    //     expect(name.firstName(includeAll: true), equals('John'));
    //   });

    //   test('.lastName() returns a last name', () {
    //     var name = Namefully('John Smith', config: Config.inline(name: 'v2'));
    //     expect(name.lastName(), equals('Smith'));
    //     expect(name.lastName(LastNameFormat.all), equals('Smith'));
    //   });
    // });
  });

  group('Config', () {
    test('creates a default configuration', () {
      var config = Config();
      expect(config.name, equals('default'));
      expect(config.orderedBy, equals(NameOrder.firstName));
      expect(config.separator, equals(Separator.space));
      expect(config.titling, equals(AbbrTitle.uk));
      expect(config.bypass, equals(false));
      expect(config.ending, equals(false));
      expect(config.lastNameFormat, equals(LastNameFormat.father));
      expect(config.parser, isNull);
    });

    test('creates a configuration with inline options', () {
      var inlineConfig = Config.inline(
        orderedBy: NameOrder.lastName,
        separator: Separator.comma,
        titling: AbbrTitle.us,
        lastNameFormat: LastNameFormat.hyphenated,
        bypass: true,
      );
      expect(inlineConfig.name, equals('default'));
      expect(inlineConfig.orderedBy, equals(NameOrder.lastName));
      expect(inlineConfig.separator, equals(Separator.comma));
      expect(inlineConfig.titling, equals(AbbrTitle.us));
      expect(inlineConfig.bypass, equals(true));
      expect(inlineConfig.ending, equals(false));
      expect(inlineConfig.lastNameFormat, equals(LastNameFormat.hyphenated));
      expect(inlineConfig.parser, isNull);
    });

    test('merges a configuration with another', () {
      var other = Config.inline(
        orderedBy: NameOrder.firstName,
        separator: Separator.colon,
        titling: AbbrTitle.us,
        lastNameFormat: LastNameFormat.hyphenated,
        ending: true,
      );
      var mergedConfig = Config.mergeWith(other);
      expect(mergedConfig.name, equals('default'));
      expect(mergedConfig.orderedBy, equals(NameOrder.firstName));
      expect(mergedConfig.separator, equals(Separator.colon));
      expect(mergedConfig.titling, equals(AbbrTitle.us));
      expect(mergedConfig.bypass, equals(false));
      expect(mergedConfig.ending, equals(true));
      expect(mergedConfig.lastNameFormat, equals(LastNameFormat.hyphenated));
      expect(mergedConfig.parser, isNull);
    });

    test('can create more than 1 configuration when necessary', () {
      var defaultConfig = Config('defaultConfig');
      var otherConfig = Config.inline(
        name: 'otherConfig',
        orderedBy: NameOrder.lastName,
        lastNameFormat: LastNameFormat.mother,
        bypass: true,
      );

      // Check the other config is set as defined.
      expect(otherConfig.name, equals('otherConfig'));
      expect(otherConfig.orderedBy, equals(NameOrder.lastName));
      expect(otherConfig.separator, equals(Separator.space));
      expect(otherConfig.titling, equals(AbbrTitle.uk));
      expect(otherConfig.bypass, equals(true));
      expect(otherConfig.ending, equals(false));
      expect(otherConfig.lastNameFormat, equals(LastNameFormat.mother));
      expect(otherConfig.parser, isNull);

      // Check the default config is not altered by the other config.
      expect(defaultConfig.name, equals('defaultConfig'));
      expect(defaultConfig.orderedBy, equals(NameOrder.firstName));
      expect(defaultConfig.separator, equals(Separator.space));
      expect(defaultConfig.titling, equals(AbbrTitle.uk));
      expect(defaultConfig.bypass, equals(false));
      expect(defaultConfig.ending, equals(false));
      expect(defaultConfig.lastNameFormat, equals(LastNameFormat.father));
      expect(defaultConfig.parser, isNull);
    });
  });
}
