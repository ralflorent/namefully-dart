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
          config: Config(name: 'generic', orderedBy: NameOrder.firstName),
        );
      });

      test('.has() determines if the full name has a specific namon', () {
        expect(name.has(Namon.prefix), equals(true));
        expect(name.has(Namon.suffix), equals(true));
        expect(name.has(Namon.middleName), equals(true));
        expect(name.hasMiddle, equals(true));
      });

      test('.toString() returns a String version of the full name', () {
        expect(name.toString(), equals('Mr John Ben Smith Ph.D'));
      });

      test('.equals() checks whether two names are equal', () {
        expect(name.equals(Namefully('Mr John Ben Smith Ph.D')), equals(true));
        expect(name.equals(Namefully('Mr John Ben Smith')), equals(false));
      });

      test('[] gets the raw form of a name', () {
        expect(name[Namon.prefix],
            isA<Name>().having((n) => n.value, 'namon', 'Mr'));
        expect(name[Namon.firstName],
            isA<FirstName>().having((n) => n.value, 'namon', 'John'));
        expect(name[Namon.middleName],
            isA<List<Name>>().having((n) => n.first.value, 'namon', 'Ben'));
        expect(name[Namon.lastName],
            isA<LastName>().having((n) => n.value, 'namon', 'Smith'));
        expect(name[Namon.suffix],
            isA<Name>().having((n) => n.value, 'namon', 'Ph.D'));
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

      test('.parts returns an Iterable of Names', () {
        var names = name.parts;
        expect(names.length, equals(5));
        expect(names.first, isA<Name>().having((n) => n.value, 'value', 'Mr'));
        expect(names.elementAt(1),
            isA<FirstName>().having((n) => n.value, 'value', 'John'));
        expect(names.elementAt(2),
            isA<Name>().having((n) => n.value, 'value', 'Ben'));
        expect(names.elementAt(3),
            isA<LastName>().having((n) => n.value, 'value', 'Smith'));
        expect(names.last, isA<Name>().having((n) => n.value, 'value', 'Ph.D'));
      });

      test('.format() formats a full name as desired', () {
        expect(name.format('short'), equals('John Smith'));
        expect(name.format('long'), equals('John Ben Smith'));
        expect(name.format('public'), equals('John S'));
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

        expect(Namefully('John Smith').format('o'), equals('SMITH, John'));
      });

      test('converts a birth name to a specific capitalization case', () {
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
          config: Config(name: 'byFirstName', orderedBy: NameOrder.firstName),
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
          name.flatten(limit: 10, by: Flat.middleName),
          equals('John B. Smith'),
        );
        expect(
          name.flatten(
            limit: 10,
            by: Flat.middleName,
            withPeriod: false,
          ),
          equals('John B Smith'),
        );
        expect(
          Namefully('John Smith').flatten(
            limit: 10,
            by: Flat.middleName,
            withPeriod: false,
          ),
          equals('John Smith'),
        );
        expect(
          Namefully('John Smith').flatten(
            limit: 8,
            by: Flat.firstMid,
            withPeriod: true,
          ),
          equals('J. Smith'),
        );
        expect(name.flatten(limit: 10, recursive: true), equals('John B. S.'));
        expect(name.flatten(limit: 5, recursive: true), equals('J. B. S.'));
        expect(
          name.flatten(limit: 10, recursive: true, withPeriod: false),
          equals('John Ben S'),
        );
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'John B. S.');
        expect(name.zip(by: Flat.firstName), 'J. Ben Smith');
        expect(name.zip(by: Flat.middleName), 'John B. Smith');
        expect(name.zip(by: Flat.lastName), 'John Ben S.');
        expect(name.zip(by: Flat.firstMid), 'J. B. Smith');
        expect(name.zip(by: Flat.midLast), 'John B. S.');
        expect(name.zip(by: Flat.all), 'J. B. S.');
      });
    });

    group('(by last name)', () {
      late Namefully name;

      setUp(() {
        name = Namefully('Mr Smith John Ben Ph.D', config: Config.byLastName());
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
          name.flatten(limit: 10, by: Flat.middleName),
          equals('Smith John B.'),
        );
        expect(
          name.flatten(
            limit: 10,
            by: Flat.middleName,
            withPeriod: false,
          ),
          equals('Smith John B'),
        );
        expect(
          Namefully('Smith John', config: Config(name: 'byLastName')).flatten(
            limit: 10,
            by: Flat.middleName,
            withPeriod: false,
          ),
          equals('Smith John'),
        );
        expect(
          Namefully('Smith John', config: Config(name: 'byLastName')).flatten(
            limit: 8,
            by: Flat.firstMid,
            withPeriod: true,
          ),
          equals('Smith J.'),
        );
      });

      test('.zip() flattens a full name', () {
        expect(name.zip(), 'S. John B.');
        expect(name.zip(withPeriod: false), 'S John B');
        expect(name.zip(by: Flat.firstName), 'Smith J. Ben');
        expect(name.zip(by: Flat.middleName), 'Smith John B.');
        expect(name.zip(by: Flat.lastName), 'S. John Ben');
        expect(name.zip(by: Flat.firstMid), 'Smith J. B.');
        expect(name.zip(by: Flat.midLast), 'S. John B.');
        expect(name.zip(by: Flat.all), 'S. J. B.');
      });
    });

    group('can be instantiated with', () {
      test('String', () {
        expect(Namefully('John Smith').full, equals('John Smith'));
      });

      test('List<String>', () {
        expect(Namefully.fromList(['John', 'Smith']).toString(), 'John Smith');
      });

      test('Map<String, String>', () {
        const names = {'firstName': 'John', 'lastName': 'Smith'};
        expect(Namefully.fromJson(names).full, 'John Smith');
      });

      test('List<Name>', () {
        final names = [FirstName('John'), LastName('Smith')];
        expect(Namefully.of(names).full, 'John Smith');
        expect(
          Namefully.of([
            Name.first('John'),
            Name.last('Smith'),
            Name.suffix('Ph.D'),
          ]).birth,
          equals('John Smith'),
        );
      });

      test('FullName', () {
        var fullName = FullName()
          ..rawFirstName('John')
          ..rawLastName('Smith');
        expect(Namefully.from(fullName).full, equals('John Smith'));
      });

      test('NameBuilder', () {
        final names = [FirstName('John'), LastName('Smith')];
        final middles = [Name.middle('Ben'), Name.middle('Carl')];
        expect(NameBuilder.of(names).build().full, 'John Smith');

        var builder = NameBuilder()
          ..addAll(names)
          ..addFirst(middles[0]);
        expect(builder.build().full, 'John Ben Smith');

        builder.removeFirst();
        expect(builder.build().full, 'John Smith');

        builder.removeLast();
        builder.addLast(LastName('Doe'));
        builder.addAll(middles);
        expect(builder.build().full, 'John Ben Carl Doe');

        builder.remove(names.elementAt(0));
        builder.retainWhere((name) => !name.isMiddleName);
        builder.add(FirstName('Jack'));
        expect(builder.build().full, 'Jack Doe');

        builder.addAll(middles);
        expect(builder.build().full, 'Jack Ben Carl Doe');

        builder.removeWhere((name) => name.isMiddleName);
        expect(builder.build().full, 'Jack Doe');

        builder.clear();
        expect(() => builder.build(), throwsInputException);
      });

      test('Parser<T> (Custom Parser)', () {
        expect(
          Namefully.fromParser(
            SimpleParser('John#Smith'), // simple parsing logic :P
            config: Config(name: 'simpleParser'),
          ).full,
          equals('John Smith'),
        );
      });

      test('only (specific parts)', () {
        expect(
          Namefully.only(firstName: 'John', lastName: 'Smith').full,
          equals('John Smith'),
        );
      });

      test('tryParse()', () {
        var parsed = Namefully.tryParse('John Smith');
        expect(parsed, isNotNull);
        expect(parsed?.short, equals('John Smith'));
        expect(parsed?.first, equals('John'));
        expect(parsed?.last, equals('Smith'));
        expect(parsed?.middle, equals(null));

        parsed = Namefully.tryParse('John Ben Smith');
        expect(parsed, isNotNull);
        expect(parsed?.short, equals('John Smith'));
        expect(parsed?.first, equals('John'));
        expect(parsed?.last, equals('Smith'));
        expect(parsed?.middle, equals('Ben'));

        parsed = Namefully.tryParse('John Some Other Name Parts Smith');
        expect(parsed, isNotNull);
        expect(parsed?.short, equals('John Smith'));
        expect(parsed?.first, equals('John'));
        expect(parsed?.last, equals('Smith'));
        expect(parsed?.middle, equals('Some'));
        expect(parsed?.middleName().join(' '), equals('Some Other Name Parts'));

        expect(Namefully.tryParse('John'), isNull);
      });

      test('parse()', () async {
        var parsed = await Namefully.parse('John Smith');
        expect(parsed.short, equals('John Smith'));
        expect(parsed.first, equals('John'));
        expect(parsed.last, equals('Smith'));
        expect(parsed.middle, equals(null));

        parsed = await Namefully.parse('John Ben Smith');
        expect(parsed.short, equals('John Smith'));
        expect(parsed.first, equals('John'));
        expect(parsed.last, equals('Smith'));
        expect(parsed.middle, equals('Ben'));

        parsed = await Namefully.parse('John Some Other Name Parts Smith');
        expect(parsed.short, equals('John Smith'));
        expect(parsed.first, equals('John'));
        expect(parsed.last, equals('Smith'));
        expect(parsed.middle, equals('Some'));
        expect(parsed.middleName().join(' '), equals('Some Other Name Parts'));

        expect(() async => await Namefully.parse('John'), throwsNameException);
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
        expect(name.firstName(withMore: false), equals('Daniel'));
        expect(name.firstName(), equals('Daniel Michael Blake'));
        expect(name.hasMiddle, equals(false));
      });

      test('containing many middle names', () {
        var nameCase = findName('manyMiddleNames');
        var name = Namefully.of(
          nameCase.name as List<Name>,
          config: nameCase.config,
        );
        expect(name.toString(), 'Emilia Isobel Euphemia Rose Clarke');
        expect(name.hasMiddle, equals(true));
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
        expect(name.lastName(format: Surname.all), 'Mebarak Ripoll');
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

  group('can be built with derivatives', () {
    Config? config;

    setUp(() => config = Config(name: 'misc'));

    test('for basic nesting operations', () {
      final namefully = Namefully('Jane Mari Doe', config: config);
      var derivative = NameDerivative.of(namefully)..shorten();
      expect(derivative.done().toString(), equals('Jane Doe'));
      expect(derivative.isDone, equals(true));
      expect(derivative.context.toString(), equals('Jane Doe'));
      expect(derivative.toString(), endsWith('context[closed]: Jane Doe'));
    });

    test('and roll back on demand', () {
      final namefully = Namefully('Jane Mari Doe', config: config);
      var derivative = namefully.derivative
        ..lower() // 'jane mari doe'
        ..flip() // 'doe mari jane'
        ..shorten(); // 'doe jane'

      expect(derivative.context.toString(), equals('doe jane'));

      derivative
        ..rollback() // back to 'doe mari joe'
        ..rollback() // back to 'jane mari doe'
        ..rollback() // back to 'Jane Mari Doe'
        ..rollback() // last rollback is a no-op
        ..close();

      expect(derivative.context.toString(), equals('Jane Mari Doe'));
    });

    test('and broadcasts its name states', () {
      var derivative = Namefully('Jane Mari Doe', config: config).derivative;
      var stream = derivative.stream;
      derivative
        ..shorten()
        ..flip()
        ..byFirstName()
        ..close();

      // ignore: no_leading_underscores_for_local_identifiers
      _predicate(String expected) => predicate<Namefully>((value) {
            expect(value.toString(), expected);
            return true;
          });

      expect(
          stream,
          emitsInOrder([
            _predicate('Jane Mari Doe'),
            _predicate('Jane Doe'),
            _predicate('Doe Jane'),
            _predicate('Jane Doe'),
            emitsDone,
          ]));
    });
  });

  group('Config', () {
    test('creates a default configuration', () {
      var config = Config();
      expect(config.name, equals('default'));
      expect(config.orderedBy, equals(NameOrder.firstName));
      expect(config.separator, equals(Separator.space));
      expect(config.title, equals(Title.uk));
      expect(config.bypass, equals(true));
      expect(config.ending, equals(false));
      expect(config.surname, equals(Surname.father));
    });

    test('creates a configuration with inline options', () {
      var inlineConfig = Config(
        orderedBy: NameOrder.lastName,
        separator: Separator.comma,
        title: Title.us,
        surname: Surname.hyphenated,
        bypass: true,
      );
      expect(inlineConfig.name, equals('default'));
      expect(inlineConfig.orderedBy, equals(NameOrder.lastName));
      expect(inlineConfig.separator, equals(Separator.comma));
      expect(inlineConfig.title, equals(Title.us));
      expect(inlineConfig.bypass, equals(true));
      expect(inlineConfig.ending, equals(false));
      expect(inlineConfig.surname, equals(Surname.hyphenated));
    });

    test('merges a configuration with another', () {
      var other = Config(
        orderedBy: NameOrder.firstName,
        separator: Separator.colon,
        title: Title.us,
        surname: Surname.hyphenated,
        ending: true,
      );
      var mergedConfig = Config.merge(other);
      expect(mergedConfig.name, equals('default'));
      expect(mergedConfig.orderedBy, equals(NameOrder.firstName));
      expect(mergedConfig.separator, equals(Separator.colon));
      expect(mergedConfig.title, equals(Title.us));
      expect(mergedConfig.bypass, equals(true));
      expect(mergedConfig.ending, equals(true));
      expect(mergedConfig.surname, equals(Surname.hyphenated));
    });

    test('can create more than 1 configuration when necessary', () {
      var defaultConfig = Config(name: 'defaultConfig');
      var otherConfig = Config(
        name: 'otherConfig',
        orderedBy: NameOrder.lastName,
        surname: Surname.mother,
        bypass: false,
      );

      // Check the other config is set as defined.
      expect(otherConfig.name, equals('otherConfig'));
      expect(otherConfig.orderedBy, equals(NameOrder.lastName));
      expect(otherConfig.separator, equals(Separator.space));
      expect(otherConfig.title, equals(Title.uk));
      expect(otherConfig.bypass, equals(false));
      expect(otherConfig.ending, equals(false));
      expect(otherConfig.surname, equals(Surname.mother));

      // Check the default config is not altered by the other config.
      expect(defaultConfig.name, equals('defaultConfig'));
      expect(defaultConfig.orderedBy, equals(NameOrder.firstName));
      expect(defaultConfig.separator, equals(Separator.space));
      expect(defaultConfig.title, equals(Title.uk));
      expect(defaultConfig.bypass, equals(true));
      expect(defaultConfig.ending, equals(false));
      expect(defaultConfig.surname, equals(Surname.father));
    });

    test('can create a copy from an existing configuration', () {
      var config = Config(name: 'config');
      var copyConfig = config.copyWith(
        name: 'config', // can be omitted.
        orderedBy: NameOrder.lastName,
        surname: Surname.mother,
        bypass: false,
      );
      var cloneCopyConfig = copyConfig.clone();

      // Check that the copied config is set as defined.
      expect(copyConfig.name, equals('config_copy'));
      expect(copyConfig.orderedBy, equals(NameOrder.lastName));
      expect(copyConfig.separator, equals(Separator.space));
      expect(copyConfig.title, equals(Title.uk));
      expect(copyConfig.bypass, equals(false));
      expect(copyConfig.ending, equals(false));
      expect(copyConfig.surname, equals(Surname.mother));

      // Check that the clone copy config is same as the copy config.
      expect(cloneCopyConfig.name, equals('config_copy_copy'));
      expect(copyConfig.orderedBy, cloneCopyConfig.orderedBy);
      expect(copyConfig.separator, cloneCopyConfig.separator);
      expect(copyConfig.title, cloneCopyConfig.title);
      expect(copyConfig.bypass, cloneCopyConfig.bypass);
      expect(copyConfig.ending, cloneCopyConfig.ending);
      expect(copyConfig.surname, cloneCopyConfig.surname);

      // Check that the config is not altered by the copy config.
      expect(config.name, equals('config'));
      expect(config.orderedBy, equals(NameOrder.firstName));
      expect(config.separator, equals(Separator.space));
      expect(config.title, equals(Title.uk));
      expect(config.bypass, equals(true));
      expect(config.ending, equals(false));
      expect(config.surname, equals(Surname.father));

      // Resets the copy config to the default.
      copyConfig.reset();
      expect(copyConfig.name, equals('config_copy'));
      expect(copyConfig.orderedBy, equals(NameOrder.firstName));
      expect(copyConfig.separator, equals(Separator.space));
      expect(copyConfig.title, equals(Title.uk));
      expect(copyConfig.bypass, equals(true));
      expect(copyConfig.ending, equals(false));
      expect(copyConfig.surname, equals(Surname.father));
    });
  });
}
