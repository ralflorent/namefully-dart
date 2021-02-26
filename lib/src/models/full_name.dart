/// Full name

import '../config.dart';
import 'enums.dart';
import 'first_name.dart';
import 'name.dart';
import 'last_name.dart';
import '../validators.dart';

class FullName {
  Name _prefix;
  FirstName _firstName;
  List<Name> _middleName = [];
  LastName _lastName;
  Name _suffix;
  final Config _config;

  FullName({Config config}) : _config = config ?? Config();
  FullName.fromJson(Map<String, String> map, {Config config})
      : _config = config ?? Config() {
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
  set prefix(Name name) {
    if (!_config.bypass) Validators.prefix.validate(name);
    _prefix = Name(
        _config.titling == AbbrTitle.us ? (name.namon + '.') : name.namon,
        Namon.prefix);
  }

  FirstName get firstName => _firstName;
  set firstName(FirstName name) {
    if (!_config.bypass) Validators.firstName.validate(name);
    _firstName = name;
  }

  List<Name> get middleName => _middleName;
  set middleName(List<Name> names) {
    if (!_config.bypass) names?.forEach(Validators.middleName.validate);
    _middleName = names ?? [];
  }

  LastName get lastName => _lastName;
  set lastName(LastName name) {
    if (!_config.bypass) Validators.lastName.validate(name);
    _lastName = name;
  }

  Name get suffix => _suffix;
  set suffix(Name name) {
    if (!_config.bypass) Validators.suffix.validate(name);
    _suffix = name;
  }

  bool has(Namon namon) {
    if (namon == Namon.prefix) return prefix?.isNotEmpty == true;
    if (namon == Namon.firstName) return firstName?.isNotEmpty == true;
    if (namon == Namon.lastName) return lastName?.isNotEmpty == true;
    if (namon == Namon.suffix) return suffix?.isNotEmpty == true;
    if (namon == Namon.middleName) {
      return middleName.isNotEmpty && middleName.every((n) => n.isNotEmpty);
    }
    return false;
  }

  FullName withPrefix(String namon) {
    prefix = Name(namon, Namon.prefix);
    return this;
  }

  FullName withFirstName(String namon, {List<String> more}) {
    firstName = FirstName(namon, more);
    return this;
  }

  FullName withMiddleName(List<String> names) {
    middleName = names?.map((n) => Name(n, Namon.middleName))?.toList();
    return this;
  }

  FullName withLastName(String father, {String mother, LastNameFormat format}) {
    lastName = LastName(father, mother, format);
    return this;
  }

  FullName withSuffix(String namon) {
    suffix = Name(namon, Namon.suffix);
    return this;
  }
}
