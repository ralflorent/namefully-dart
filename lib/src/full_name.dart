import 'config.dart';
import 'enums.dart';
import 'models.dart';
import 'validators.dart';

/// The core component of this utility.
///
/// This component is comprised of five entities that make it easy to handle a
/// full name set: prefix, first name, middle name, last name, and suffix.
///
/// This class is intended for internal processes. However, it is understandable
/// that it might be needed at some point for additional purposes. For this rea-
/// son, it's made available.
///
/// It is recommended to avoid using [FullName] unless it is highly necessary or
/// a custom parser is used for uncommon use cases. This utility tries to cover
/// as many use cases as possible.
///
/// To harness Dart cascade features, a good use of it may look like this:
///
///```dart
/// var fullName = FullName()
///     ..rawPrefix('Mr')
///     ..rawFirstName('John')
///     ..rawMiddleName(['Ben', 'Carl'])
///     ..rawLastName('Smith')
///     ..rawSuffix('Ph.D');
/// print(fullName.shorten()); // John Smith
/// ```
///
/// Additionally, a optional [Config]uration can be used to indicate some speci-
/// fic behaviors related to that name handling.
class FullName {
  Name? _prefix;
  late FirstName _firstName;
  List<Name> _middleName = [];
  late LastName _lastName;
  Name? _suffix;
  final Config _config;

  FullName({Config? config}) : _config = config ?? Config();

  FullName.fromJson(Map<String, String> jsonName, {Config? config})
      : _config = config ?? Config() {
    _parseJsonName(jsonName);
  }

  Name? get prefix => _prefix;
  set prefix(Name? name) {
    if (name == null) return;
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
    if (!_config.bypass) Validators.middleName.validate(names);
    _middleName = names;
  }

  LastName get lastName => _lastName;
  set lastName(LastName name) {
    if (!_config.bypass) Validators.lastName.validate(name);
    _lastName = name;
  }

  Name? get suffix => _suffix;
  set suffix(Name? name) {
    if (name == null) return;
    if (!_config.bypass) Validators.suffix.validate(name);
    _suffix = name;
  }

  bool has(Namon namon) {
    if (namon == Namon.prefix) return prefix?.isNotEmpty == true;
    if (namon == Namon.firstName) return firstName.isNotEmpty;
    if (namon == Namon.lastName) return lastName.isNotEmpty;
    if (namon == Namon.suffix) return suffix?.isNotEmpty == true;
    if (namon == Namon.middleName) {
      return middleName.isNotEmpty && middleName.every((n) => n.isNotEmpty);
    }
    return false;
  }

  /// Sets a [prefix] using string values.
  void rawPrefix(String namon) => prefix = Name(namon, Namon.prefix);

  /// Sets a [firstName] using string values.
  void rawFirstName(String namon, {List<String>? more}) =>
      firstName = FirstName(namon, more);

  /// Sets a [middleName] using string values.
  void rawMiddleName(List<String> names) =>
      middleName = names.map((n) => Name(n, Namon.middleName)).toList();

  /// Sets a [lastName] using string values.
  void rawLastName(String father, {String? mother, LastNameFormat? format}) =>
      lastName = LastName(father, mother, format ?? LastNameFormat.father);

  /// Sets a [suffix] using string values.
  void rawSuffix(String namon) => suffix = Name(namon, Namon.suffix);

  void _parseJsonName(Map<String, String> json) {
    try {
      if (json['prefix'] != null) prefix = Name(json['prefix']!, Namon.prefix);
      if (json['middleName'] != null) {
        middleName = json['middleName']!
            .split(' ')
            .map((n) => Name(n, Namon.middleName))
            .toList();
      }
      if (json['suffix'] != null) suffix = Name(json['suffix']!, Namon.suffix);
      firstName = FirstName(json['firstName']!);
      lastName = LastName(json['lastName']!);
    } catch (error) {
      throw ValidationError('invalid content! \n$error');
    }
  }
}
