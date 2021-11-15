import 'package:namefully/name_builder.dart';
import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Namefully', () {
    group('(default settings)', () {
      late Namefully name;

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
        expect(name.stats()?.count, equals(18));
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

        expect(name.format(r'f $l'), equals('John S'));
        expect(name.format(r'f $l.'), equals('John S.'));
        expect(name.format(r'f $m. l'), equals('John B. Smith'));
        expect(name.format(r'$F.$M.$L'), equals('J.B.S'));
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
        expect(name.birth, equals('Smith John Ben'));
        expect(name.first, equals('John'));
        expect(name.last, equals('Smith'));
        name.flip(); // flip back to the firstName name order.
      });
    });

    group('(by first name)', () {
      late Namefully name;

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
        expect(name.prefix, 'Mr');
        expect(name.first, 'John');
        expect(name.middle, equals('Ben'));
        expect(name.last, 'Smith');
        expect(name.suffix, 'Ph.D');
        expect(name.birth, 'John Ben Smith');
        expect(name.short, 'John Smith');
        expect(name.long, 'John Ben Smith');
        expect(name.public, 'John S');
        expect(name.full, 'Mr John Ben Smith Ph.D');
        expect(name.fullName(), 'Mr John Ben Smith Ph.D');
        expect(name.fullName(NameOrder.lastName), 'Mr Smith John Ben Ph.D');
        expect(name.birthName(), 'John Ben Smith');
        expect(name.birthName(NameOrder.lastName), 'Smith John Ben');
      });

      test('.initials() returns the initials of the full name', () {
        expect(name.initials(), equals(['J', 'S']));
        expect(name.initials(withMid: true), equals(['J', 'B', 'S']));
        expect(
          name.initials(orderedBy: NameOrder.lastName),
          equals(['S', 'J']),
        );
        expect(
          name.initials(orderedBy: NameOrder.lastName, withMid: true),
          equals(['S', 'J', 'B']),
        );
        expect(name.initials(only: NameType.firstName), equals(['J']));
        expect(name.initials(only: NameType.middleName), equals(['B']));
        expect(name.initials(only: NameType.lastName), equals(['S']));
      });

      test('.shorten() shortens a full name to a first and last name', () {
        expect(name.shorten(), equals('John Smith'));
        expect(name.shorten(orderedBy: NameOrder.lastName), 'Smith John');
      });

      test('.flatten() flattens a full name based on specs', () {
        expect(
          name.flatten(limit: 10, by: FlattenedBy.middleName),
          equals('John B. Smith'),
        );
        expect(
          name.flatten(
            limit: 10,
            by: FlattenedBy.middleName,
            withPeriod: false,
          ),
          equals('John B Smith'),
        );
        expect(
          Namefully('John Smith').flatten(
            limit: 10,
            by: FlattenedBy.middleName,
            withPeriod: false,
          ),
          equals('John Smith'),
        );
        expect(
          Namefully('John Smith').flatten(
            limit: 8,
            by: FlattenedBy.firstMid,
            withPeriod: true,
          ),
          equals('J. Smith'),
        );
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'John B. S.');
        expect(name.zip(by: FlattenedBy.firstName), 'J. Ben Smith');
        expect(name.zip(by: FlattenedBy.middleName), 'John B. Smith');
        expect(name.zip(by: FlattenedBy.lastName), 'John Ben S.');
        expect(name.zip(by: FlattenedBy.firstMid), 'J. B. Smith');
        expect(name.zip(by: FlattenedBy.midLast), 'John B. S.');
        expect(name.zip(by: FlattenedBy.all), 'J. B. S.');
      });
    });

    group('(by last name)', () {
      late Namefully name;

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
        expect(name.prefix, 'Mr');
        expect(name.first, 'John');
        expect(name.middle, equals('Ben'));
        expect(name.last, 'Smith');
        expect(name.suffix, 'Ph.D');
        expect(name.fullName(), 'Mr Smith John Ben Ph.D');
        expect(name.fullName(NameOrder.firstName), 'Mr John Ben Smith Ph.D');
        expect(name.birthName(), 'Smith John Ben');
        expect(name.birthName(NameOrder.firstName), 'John Ben Smith');
      });

      test('.initials() returns the initials of the full name', () {
        expect(name.initials(), equals(['S', 'J']));
        expect(name.initials(withMid: true), equals(['S', 'J', 'B']));
        expect(
          name.initials(orderedBy: NameOrder.firstName),
          equals(['J', 'S']),
        );
        expect(
          name.initials(orderedBy: NameOrder.firstName, withMid: true),
          equals(['J', 'B', 'S']),
        );
        expect(name.initials(only: NameType.firstName), equals(['J']));
        expect(name.initials(only: NameType.middleName), equals(['B']));
        expect(name.initials(only: NameType.lastName), equals(['S']));
      });

      test('.shorten() shortens a full name to a first and last name', () {
        expect(name.shorten(), 'Smith John');
        expect(name.shorten(orderedBy: NameOrder.firstName), 'John Smith');
      });

      test('.flatten() flattens a full name based on specs', () {
        expect(
          name.flatten(limit: 10, by: FlattenedBy.middleName),
          equals('Smith John B.'),
        );
        expect(
          name.flatten(
            limit: 10,
            by: FlattenedBy.middleName,
            withPeriod: false,
          ),
          equals('Smith John B'),
        );
        expect(
          Namefully('Smith John', config: Config('byLastName')).flatten(
            limit: 10,
            by: FlattenedBy.middleName,
            withPeriod: false,
          ),
          equals('Smith John'),
        );
        expect(
          Namefully('Smith John', config: Config('byLastName')).flatten(
            limit: 8,
            by: FlattenedBy.firstMid,
            withPeriod: true,
          ),
          equals('Smith J.'),
        );
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'S. John B.');
        expect(name.zip(withPeriod: false), 'S John B');
        expect(name.zip(by: FlattenedBy.firstName), 'Smith J. Ben');
        expect(name.zip(by: FlattenedBy.middleName), 'Smith John B.');
        expect(name.zip(by: FlattenedBy.lastName), 'S. John Ben');
        expect(name.zip(by: FlattenedBy.firstMid), 'Smith J. B.');
        expect(name.zip(by: FlattenedBy.midLast), 'S. John B.');
        expect(name.zip(by: FlattenedBy.all), 'S. J. B.');
      });
    });

    group('can be instantiated with', () {
      test('String', () {
        expect(Namefully('John Smith').full, equals('John Smith'));
        expect(NameBuilder('John Smith').build().full, equals('John Smith'));
        expect(
            NameBuilder.only(firstName: 'John', lastName: 'Smith').build().full,
            equals('John Smith'));
      });

      test('List<String>', () {
        expect(Namefully.fromList(['John', 'Smith']).toString(), 'John Smith');
        expect(NameBuilder.fromList(['John', 'Smith']).build().full,
            equals('John Smith'));
      });

      test('Map<String, String>', () {
        expect(
          Namefully.fromJson({'firstName': 'John', 'lastName': 'Smith'}).full,
          equals('John Smith'),
        );
        expect(
          NameBuilder.fromJson({'firstName': 'John', 'lastName': 'Smith'})
              .build()
              .full,
          equals('John Smith'),
        );
      });

      test('List<Name>', () {
        expect(
          Namefully.of([FirstName('John'), LastName('Smith')]).full,
          equals('John Smith'),
        );
        expect(
          Namefully.of([
            Name('John', Namon.firstName),
            Name('Smith', Namon.lastName),
            Name('Ph.D', Namon.suffix),
          ]).birth,
          equals('John Smith'),
        );
        expect(
          NameBuilder.of([FirstName('John'), LastName('Smith')]).build().full,
          equals('John Smith'),
        );
      });

      test('FullName', () {
        var fullName = FullName()
          ..rawFirstName('John')
          ..rawLastName('Smith');
        expect(Namefully.from(fullName).full, equals('John Smith'));
        expect(NameBuilder.from(fullName).build().full, equals('John Smith'));
      });

      test('Parser<T> (Custom Parser)', () {
        expect(
          Namefully.fromParser(
            SimpleParser('John#Smith'), // simple parsing logic :P
            config: Config.inline(name: 'simpleParser'),
          ).full,
          equals('John Smith'),
        );
        expect(
          NameBuilder.fromParser(
            SimpleParser('John#Smith'), // simple parsing logic :P
            config: Config.inline(name: 'simpleParser'),
          ).build().full,
          equals('John Smith'),
        );
      });
    });

    group('can be built with a name', () {
      test('ordered by lastName', () {
        var nameCase = findName('byLastName');
        var name = Namefully(nameCase.name as String, config: nameCase.config);
        expect(name.toString(), 'Obama Barack');
        expect(name.firstName(), 'Barack');
        expect(name.lastName(), 'Obama');
      });

      test('containing many first names', () {
        var nameCase = findName('manyFirstNames');
        var name = Namefully.of(
          nameCase.name as List<Name>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Daniel Michael Blake Day-Lewis');
        expect(name.firstName(includeAll: false), equals('Daniel'));
        expect(name.firstName(), equals('Daniel Michael Blake'));
        expect(name.hasMiddleName(), equals(false));
      });

      test('containing many middle names', () {
        var nameCase = findName('manyMiddleNames');
        var name = Namefully.of(
          nameCase.name as List<Name>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Emilia Isobel Euphemia Rose Clarke');
        expect(name.hasMiddleName(), equals(true));
        expect(name.middleName(), equals(['Isobel', 'Euphemia', 'Rose']));
      });

      test('containing many last names', () {
        var nameCase = findName('manyLastNames');
        var name = Namefully.of(
          nameCase.name as List<Name>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Shakira Isabel Ripoll');
        expect(name.lastName(), equals('Ripoll'));
        expect(name.lastName(LastNameFormat.all), 'Mebarak Ripoll');
      });

      test('containing a US title', () {
        var nameCase = findName('withTitling');
        var name = Namefully.fromJson(
          nameCase.name as Map<String, String>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Dr. Albert Einstein');
        expect(name.prefix, equals('Dr.'));
      });

      test('separated by commas', () {
        var nameCase = findName('withSeparator');
        var name = Namefully(nameCase.name as String, config: nameCase.config);
        expect(name.toString(), 'Thiago Da Silva');
        expect(name.lastName(), equals('Da Silva'));
      });

      test('containing a suffix', () {
        var nameCase = findName('withEnding');
        var name = Namefully.fromJson(
          nameCase.name as Map<String, String>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Fabrice Piazza, Ph.D');
        expect(name.birthName(), equals('Fabrice Piazza'));
        expect(name.suffix, equals('Ph.D'));
      });

      test('with validation rules', () {
        var nameCase = findName('noBypass');
        expect(
          () {
            Namefully.fromJson(
              nameCase.name as Map<String, String>,
              config: nameCase.config,
            );
          },
          throwsNameException,
        );
        expect(
          () => Namefully('Mr John Joe Sm1th', config: nameCase.config),
          throwsNameException,
        );
        expect(
          () => Namefully('Mr John Joe Smith Ph+', config: nameCase.config),
          throwsNameException,
        );
      });
    });
  });

  group('can be built on the fly', () {
    Config? config;

    setUp(() => config = Config('NameBuilder'));

    test('for basic nesting operations', () {
      var builder = NameBuilder('Jane Mari Doe', config: config)..shorten();
      var name = builder.build();
      expect(builder.isClosed, equals(true));

      expect(name.toString(), equals('Jane Doe'));
      expect(name.toList(), equals([null, 'Jane', '', 'Doe', null]));

      expect(builder.asString, equals('Jane Doe'));
      expect(builder.toString(),
          "NameBuilder's current context[closed]: Jane Doe");
    });

    test('and roll back on demand', () {
      var builder = NameBuilder('Jane Mari Doe', config: config)
        ..lower() // 'jane mari doe'
        ..flip() // 'doe mari jane'
        ..shorten(); // 'doe jane'

      expect(builder.asString, equals('doe jane'));

      builder
        ..rollback() // back to 'doe mari joe'
        ..rollback() // back to 'jane mari doe'
        ..rollback() // back to 'Jane Mari Doe'
        ..rollback() // last rollback is a no-op
        ..close();

      expect(builder.asString, equals('Jane Mari Doe'));
    });

    test('and broadcasts its name states', () {
      var builder = NameBuilder('Jane Mari Doe', config: config);
      var stream = builder.stream;
      builder
        ..shorten()
        ..upper()
        ..close();
      stream.listen(
        expectAsync1<void, Namefully>(
          (name) => expect(name.toString(), isNotEmpty),
          max: 3,
        ),
      );
    }, skip: true);
  });

  group('Config', () {
    test('creates a default configuration', () {
      var config = Config();
      expect(config.name, equals('default'));
      expect(config.orderedBy, equals(NameOrder.firstName));
      expect(config.separator, equals(Separator.space));
      expect(config.titling, equals(AbbrTitle.uk));
      expect(config.bypass, equals(true));
      expect(config.ending, equals(false));
      expect(config.lastNameFormat, equals(LastNameFormat.father));
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
    });

    test('merges a configuration with another', () {
      var other = Config.inline(
        orderedBy: NameOrder.firstName,
        separator: Separator.colon,
        titling: AbbrTitle.us,
        lastNameFormat: LastNameFormat.hyphenated,
        ending: true,
      );
      var mergedConfig = Config.merge(other);
      expect(mergedConfig.name, equals('default'));
      expect(mergedConfig.orderedBy, equals(NameOrder.firstName));
      expect(mergedConfig.separator, equals(Separator.colon));
      expect(mergedConfig.titling, equals(AbbrTitle.us));
      expect(mergedConfig.bypass, equals(true));
      expect(mergedConfig.ending, equals(true));
      expect(mergedConfig.lastNameFormat, equals(LastNameFormat.hyphenated));
    });

    test('can create more than 1 configuration when necessary', () {
      var defaultConfig = Config('defaultConfig');
      var otherConfig = Config.inline(
        name: 'otherConfig',
        orderedBy: NameOrder.lastName,
        lastNameFormat: LastNameFormat.mother,
        bypass: false,
      );

      // Check the other config is set as defined.
      expect(otherConfig.name, equals('otherConfig'));
      expect(otherConfig.orderedBy, equals(NameOrder.lastName));
      expect(otherConfig.separator, equals(Separator.space));
      expect(otherConfig.titling, equals(AbbrTitle.uk));
      expect(otherConfig.bypass, equals(false));
      expect(otherConfig.ending, equals(false));
      expect(otherConfig.lastNameFormat, equals(LastNameFormat.mother));

      // Check the default config is not altered by the other config.
      expect(defaultConfig.name, equals('defaultConfig'));
      expect(defaultConfig.orderedBy, equals(NameOrder.firstName));
      expect(defaultConfig.separator, equals(Separator.space));
      expect(defaultConfig.titling, equals(AbbrTitle.uk));
      expect(defaultConfig.bypass, equals(true));
      expect(defaultConfig.ending, equals(false));
      expect(defaultConfig.lastNameFormat, equals(LastNameFormat.father));
    });

    test('can create a copy from an existing configuration', () {
      var config = Config('config');
      var copyConfig = config.copyWith(
        orderedBy: NameOrder.lastName,
        lastNameFormat: LastNameFormat.mother,
        bypass: false,
      );

      // Check the copied config is set as defined.
      expect(copyConfig.name, equals('config_copy'));
      expect(copyConfig.orderedBy, equals(NameOrder.lastName));
      expect(copyConfig.separator, equals(Separator.space));
      expect(copyConfig.titling, equals(AbbrTitle.uk));
      expect(copyConfig.bypass, equals(false));
      expect(copyConfig.ending, equals(false));
      expect(copyConfig.lastNameFormat, equals(LastNameFormat.mother));

      // Check the config is not altered by the copy config.
      expect(config.name, equals('config'));
      expect(config.orderedBy, equals(NameOrder.firstName));
      expect(config.separator, equals(Separator.space));
      expect(config.titling, equals(AbbrTitle.uk));
      expect(config.bypass, equals(true));
      expect(config.ending, equals(false));
      expect(config.lastNameFormat, equals(LastNameFormat.father));
    });
  });
}
