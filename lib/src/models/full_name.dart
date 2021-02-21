/// Full name

import '../config.dart';
import 'enums.dart';
import 'first_name.dart';
import 'name.dart';
import 'last_name.dart';

class FullName {
  Name _prefix, _suffix;
  FirstName _firstName;
  List<Name> _middleName = [];
  LastName _lastName;
  final Config _config;

  FullName({Config config}) : _config = config;
  FullName.fromMap(Map<String, String> map, {Config config})
      : _config = config {
    prefix = map['prefix'] != null ? Name(map['prefix'], Namon.prefix) : null;
    firstName = FirstName(map['firstName']);
    middleName = map['middleName'] != null
        ? map['middleName']
            .split(' ')
            .map((n) => Name(n, Namon.middleName))
            .toList()
        : [];
    lastName = LastName(map['lastName']);
    suffix = map['suffix'] != null ? Name(map['suffix'], Namon.suffix) : null;
  }

  Name get prefix => _prefix;
  set prefix(Name name) => _prefix = Name(
      _config?.titling == AbbrTitle.us ? (name.namon + '.') : name.namon,
      Namon.prefix);

  FirstName get firstName => _firstName;
  set firstName(FirstName name) => _firstName = name;

  List<Name> get middleName => _middleName;
  set middleName(List<Name> names) => _middleName = names;

  LastName get lastName => _lastName;
  set lastName(LastName name) => _lastName = name;

  Name get suffix => _suffix;
  set suffix(Name name) => _suffix = name;

  bool has(Namon namon) {
    if (namon == Namon.prefix) return _hasPrefix();
    if (namon == Namon.firstName) return _hasFirstName();
    if (namon == Namon.middleName) return _hasMiddleName();
    if (namon == Namon.lastName) return _hasLastName();
    if (namon == Namon.suffix) return _hasSuffix();
    return false;
  }

  bool _hasPrefix() => prefix?.isNotEmpty;
  bool _hasFirstName() => firstName?.isNotEmpty;
  bool _hasMiddleName() =>
      middleName.isNotEmpty && middleName.every((n) => n.isNotEmpty);
  bool _hasLastName() => lastName?.isNotEmpty;
  bool _hasSuffix() => suffix?.isNotEmpty;
}
