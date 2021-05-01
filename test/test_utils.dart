import 'package:namefully/namefully.dart';
import 'package:namefully/src/validators.dart';
import 'package:test/test.dart';

final Matcher throwsValidationError = throwsA(TypeMatcher<ValidationError>());
final Matcher throwsNotAllowedError = throwsA(TypeMatcher<NotAllowedError>());

class SimpleParser implements Parser<String> {
  @override
  Config? config;

  @override
  String raw;

  SimpleParser(this.raw);

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
    'options': Config.inline(name: 'simpleName'),
  },
  'byLastName': {
    'name': 'Obama Barack',
    'options': Config.inline(name: 'byLastName', orderedBy: NameOrder.lastName),
  },
  'manyFirstNames': {
    'name': [
      FirstName('Daniel', ['Michael', 'Blake']),
      LastName('Day-Lewis'),
    ],
    'options': Config.inline(name: 'manyFirstNames'),
  },
  'manyMiddleNames': {
    'name': [
      FirstName('Emilia'),
      Name('Isobel', Namon.middleName),
      Name('Euphemia', Namon.middleName),
      Name('Rose', Namon.middleName),
      LastName('Clarke')
    ],
    'options': Config.inline(name: 'manyMiddleNames'),
  },
  'manyLastNames': {
    'name': [
      FirstName('Shakira', ['Isabel']),
      LastName('Mebarak', 'Ripoll')
    ],
    'options': Config.inline(
      name: 'manyLastNames',
      lastNameFormat: LastNameFormat.mother,
    )
  },
  'withTitling': {
    'name': {'prefix': 'Dr', 'firstName': 'Albert', 'lastName': 'Einstein'},
    'options': Config.inline(name: 'withTitling', titling: AbbrTitle.us),
  },
  'withEnding': {
    'name': {'firstName': 'Fabrice', 'lastName': 'Piazza', 'suffix': 'Ph.D'},
    'options': Config.inline(name: 'withEnding', ending: true),
  },
  'withSeparator': {
    'name': 'Thiago, Da Silva',
    'options': Config.inline(
      name: 'withSeparator',
      separator: Separator.comma,
    ),
  },
  'withBypass': {
    'name': {
      'prefix': 'Mme',
      'firstName': 'Marine',
      'lastName': 'Le Pen',
      'suffix': 'M.Sc.'
    },
    'options': Config.inline(
      name: 'withBypass',
      bypass: true,
      ending: true,
      titling: AbbrTitle.us,
    )
  },
};
