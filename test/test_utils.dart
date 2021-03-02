import 'package:namefully/namefully.dart';

String findName(int index) => nameCases[index]['name'] as String;

final nameCases = [
  {
    'name': 'John Smith',
    'options': {},
  },
  {
    'name': ['George', 'Walker', 'Bush'],
    'options': {},
  },
  {
    'name': [
      FirstName('Emilia'),
      Name('Isobel', Namon.middleName),
      Name('Euphemia', Namon.middleName),
      Name('Rose', Namon.middleName),
      LastName('Clarke')
    ],
    'options': {}
  },
  {
    'name': [
      FirstName('Daniel', ['Michael', 'Blake']),
      LastName('Day-Lewis'),
    ],
    'options': {}
  },
  {
    'name': 'Obama Barack',
    'options': Config.inline(orderedBy: NameOrder.lastName),
  },
  {
    'name': {'prefix': 'Dr', 'firstName': 'Albert', 'lastName': 'Einstein'},
    'options': Config.inline(titling: AbbrTitle.us),
  },
  {
    'name': {'firstName': 'Fabrice', 'lastName': 'Piazza', 'suffix': 'PhD'},
    'options': Config.inline(ending: true),
  },
  {
    'name': 'Thiago, Da Silva',
    'options': Config.inline(separator: Separator.comma),
  },
  {
    'name': [
      FirstName('Shakira', ['Isabel']),
      LastName('Mebarak', 'Ripoll')
    ],
    'options': Config.inline(lastNameFormat: LastNameFormat.mother)
  },
  {
    'name': {
      'prefix': 'Mme',
      'firstName': 'Marine',
      'lastName': 'Le Pen',
      'suffix': 'M.Sc.'
    },
    'options': Config.inline(bypass: true, ending: true, titling: AbbrTitle.us)
  },
];
