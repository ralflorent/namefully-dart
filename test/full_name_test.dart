import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

void main() {
  // ignore: no_leading_underscores_for_local_identifiers
  void _runExpectations(FullName fullName) {
    expect(fullName.prefix, isA<Name>());
    expect(fullName.firstName, isA<FirstName>());
    expect(fullName.middleName, isA<List<Name>>());
    expect(fullName.lastName, isA<LastName>());
    expect(fullName.suffix, isA<Name>());

    expect(fullName.prefix.toString(), equals('Mr'));
    expect(fullName.firstName.toString(), equals('John'));
    expect(fullName.middleName.map((n) => n.toString()).join(' '), 'Ben Carl');
    expect(fullName.lastName.toString(), equals('Smith'));
    expect(fullName.suffix.toString(), equals('Ph.D'));
  }

  group('FullName', () {
    late Name prefix;
    late Name suffix;
    late FirstName firstName;
    late List<Name> middleName;
    late LastName lastName;
    late FullName fullName;

    setUp(() {
      prefix = Name.prefix('Mr');
      firstName = FirstName('John');
      middleName = [Name.middle('Ben'), Name.middle('Carl')];
      lastName = LastName('Smith');
      suffix = Name.suffix('Ph.D');
    });

    test('creates a full name from a json name', () {
      fullName = FullName.fromJson({
        'prefix': 'Mr',
        'firstName': 'John',
        'middleName': 'Ben Carl',
        'lastName': 'Smith',
        'suffix': 'Ph.D'
      });
      _runExpectations(fullName);
    });

    test('creates a full name from raw string content', () {
      fullName = FullName.raw(
        prefix: 'Mr',
        firstName: 'John',
        middleName: ['Ben', 'Carl'],
        lastName: 'Smith',
        suffix: 'Ph.D',
      );
      _runExpectations(fullName);
    });

    test('builds a full name as it goes', () {
      fullName = FullName()
        ..prefix = prefix
        ..firstName = firstName
        ..middleName = middleName
        ..lastName = lastName
        ..suffix = suffix;

      _runExpectations(fullName);
    });

    test('builds a full name with no validation rules', () {
      fullName = FullName(config: Config(name: 'withBypass', bypass: true))
        ..firstName = FirstName('2Pac')
        ..lastName = LastName('Shakur');

      expect(fullName.firstName, isA<FirstName>());
      expect(fullName.lastName, isA<LastName>());
      expect(fullName.firstName.toString(), equals('2Pac'));
      expect(fullName.lastName.toString(), equals('Shakur'));
    });

    test('creates a full name as it goes from raw strings', () {
      fullName = FullName()
        ..rawPrefix('Mr')
        ..rawFirstName('John')
        ..rawMiddleName(['Ben', 'Carl'])
        ..rawLastName('Smith')
        ..rawSuffix('Ph.D');

      _runExpectations(fullName);
    });

    test('.has() indicates whether a full name has a specific namon', () {
      fullName = FullName()
        ..rawPrefix('Ms')
        ..rawFirstName('Jane')
        ..rawLastName('Doe');

      expect(fullName.has(Namon.prefix), equals(true));
      expect(fullName.has(Namon.firstName), equals(true));
      expect(fullName.has(Namon.middleName), equals(false));
      expect(fullName.has(Namon.lastName), equals(true));
      expect(fullName.has(Namon.suffix), equals(false));
    });
  });
}
