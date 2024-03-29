import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

final throwsNameException = throwsA(TypeMatcher<NameException>());
final throwsInputException = throwsA(TypeMatcher<InputException>());
final throwsValidationException = throwsA(TypeMatcher<ValidationException>());
final throwsNotAllowedException = throwsA(TypeMatcher<NotAllowedException>());
final throwsUnknownException = throwsA(TypeMatcher<UnknownException>());

class SimpleParser extends Parser<String> {
  const SimpleParser(super.names);

  @override
  FullName parse({Config? options}) {
    final names = raw.split('#'); // simple parsing logic :P
    return FullName.fromJson({
      'firstName': names[0].trim(),
      'lastName': names[1].trim(),
    }, config: options);
  }
}

class NameCase {
  final dynamic name;
  final Config config;
  NameCase(this.name, this.config);
}

NameCase findName(String name) => NameCase(
      nameCases[name]!['name'],
      nameCases[name]!['options'] as Config,
    );

final nameCases = {
  'simpleName': {
    'name': 'John Smith',
    'options': Config(name: 'simpleName'),
  },
  'byLastName': {
    'name': 'Obama Barack',
    'options': Config(name: 'byLastName', orderedBy: NameOrder.lastName),
  },
  'manyFirstNames': {
    'name': [
      FirstName('Daniel', ['Michael', 'Blake']),
      LastName('Day-Lewis'),
    ],
    'options': Config(name: 'manyFirstNames'),
  },
  'manyMiddleNames': {
    'name': [
      FirstName('Emilia'),
      Name.middle('Isobel'),
      Name.middle('Euphemia'),
      Name.middle('Rose'),
      LastName('Clarke')
    ],
    'options': Config(name: 'manyMiddleNames'),
  },
  'manyLastNames': {
    'name': [
      FirstName('Shakira', ['Isabel']),
      LastName('Mebarak', 'Ripoll')
    ],
    'options': Config(
      name: 'manyLastNames',
      surname: Surname.mother,
    )
  },
  'withTitling': {
    'name': {'prefix': 'Dr', 'firstName': 'Albert', 'lastName': 'Einstein'},
    'options': Config(name: 'withTitling', title: Title.us),
  },
  'withEnding': {
    'name': {'firstName': 'Fabrice', 'lastName': 'Piazza', 'suffix': 'Ph.D'},
    'options': Config(name: 'withEnding', ending: true),
  },
  'withSeparator': {
    'name': 'Thiago, Da Silva',
    'options': Config(
      name: 'withSeparator',
      separator: Separator.comma,
    ),
  },
  'noBypass': {
    'name': {
      'prefix': 'Mme',
      'firstName': 'Marine',
      'lastName': 'Le Pen',
      'suffix': 'M.Sc.'
    },
    'options': Config(
      name: 'noBypass',
      bypass: false,
      ending: true,
      title: Title.us,
    )
  },
};
