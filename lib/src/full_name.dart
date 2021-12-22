import 'config.dart';
import 'types.dart';
import 'exception.dart';
import 'name.dart';
import 'validator.dart';

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
/// Additionally, an optional [Config]uration can be used to indicate some speci-
/// fic behaviors related to that name handling.
class FullName {
  Name? _prefix;
  late FirstName _firstName;
  List<Name> _middleName = [];
  late LastName _lastName;
  Name? _suffix;
  final Config _config;

  /// Creates a full name as it goes.
  FullName({Config? config}) : _config = config ?? Config();

  /// Creates a full name json-like string content.
  FullName.fromJson(Map<String, String> jsonName, {Config? config})
      : _config = config ?? Config() {
    _parseJsonName(jsonName);
  }

  /// Creates a full name with raw string content.
  FullName.raw({
    String? prefix,
    required String firstName,
    List<String>? middleName,
    required String lastName,
    String? suffix,
    Config? config,
  }) : _config = config ?? Config() {
    if (prefix != null) rawPrefix(prefix);
    rawFirstName(firstName);
    if (middleName != null) rawMiddleName(middleName);
    rawLastName(lastName);
    if (suffix != null) rawSuffix(suffix);
  }

  /// A snapshot of the configuration used to set up this full name.
  Config get config => _config;

  /// The prefix part of the full name.
  Name? get prefix => _prefix;
  set prefix(Name? name) {
    if (name == null) return;
    if (!_config.bypass) Validators.prefix.validate(name);
    _prefix = Name(
      _config.title == Title.us ? (name.namon + '.') : name.namon,
      Namon.prefix,
    );
  }

  /// The first name part of the full name.
  FirstName get firstName => _firstName;
  set firstName(FirstName name) {
    if (!_config.bypass) Validators.firstName.validate(name);
    _firstName = name;
  }

  /// The middle name part of the full name.
  List<Name> get middleName => _middleName;
  set middleName(List<Name> names) {
    if (!_config.bypass) Validators.middleName.validate(names);
    _middleName = names;
  }

  /// The last name part of the full name.
  LastName get lastName => _lastName;
  set lastName(LastName name) {
    if (!_config.bypass) Validators.lastName.validate(name);
    _lastName = name;
  }

  /// The suffix part of the full name.
  Name? get suffix => _suffix;
  set suffix(Name? name) {
    if (name == null) return;
    if (!_config.bypass) Validators.suffix.validate(name);
    _suffix = name;
  }

  /// Returns true if a [namon] has been set.
  bool has(Namon namon) {
    if (namon == Namon.prefix) return prefix != null;
    if (namon == Namon.firstName || namon == Namon.lastName) return true;
    if (namon == Namon.suffix) return suffix != null;
    if (namon == Namon.middleName) return middleName.isNotEmpty;

    return false;
  }

  /// Sets a [prefix] using string values.
  void rawPrefix(String namon) => prefix = Name(namon, Namon.prefix);

  /// Sets a [firstName] using string values.
  void rawFirstName(String namon, {List<String>? more}) {
    firstName = FirstName(namon, more);
  }

  /// Sets a [middleName] using string values.
  void rawMiddleName(List<String> names) {
    middleName = names.map((n) => Name(n, Namon.middleName)).toList();
  }

  /// Sets a [lastName] using string values.
  void rawLastName(String father, {String? mother, Surname? format}) {
    lastName = LastName(father, mother, format ?? Surname.father);
  }

  /// Sets a [suffix] using string values.
  void rawSuffix(String namon) => suffix = Name(namon, Namon.suffix);

  /// Parses a [json] name into a full name.
  void _parseJsonName(Map<String, String> json) {
    try {
      if (json[Namon.prefix.key] != null) rawPrefix(json[Namon.prefix.key]!);
      if (json[Namon.middleName.key] != null) {
        rawMiddleName(json[Namon.middleName.key]!.split(' '));
      }
      if (json[Namon.suffix.key] != null) rawSuffix(json[Namon.suffix.key]!);
      rawFirstName(json[Namon.firstName.key]!);
      rawLastName(json[Namon.lastName.key]!);
    } on NameException {
      rethrow; // Let a name exception run its course.
    } catch (error) {
      throw UnknownException(
        source: json.values.join(' '),
        message: 'could not parse Map<String, String> content',
        error: error,
      );
    }
  }
}
