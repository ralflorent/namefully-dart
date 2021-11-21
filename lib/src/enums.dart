import 'utils.dart';

/// The abbreviation type to indicate whether or not to add period to a prefix
/// using the American or British way.
enum Title {
  /// A period after the prefix.
  us,

  /// No period after the prefix.
  uk
}

/// An option indicating how to format a surname:
///
/// This enum can be set via [Config] or when creating a [LastName]. As this can
/// become ambiguous at the time of handling it, the value set in [Config] is
/// prioritized and viewed as the source of truth for future considerations.
enum Surname {
  /// The fatherly surname only.
  father,

  /// The motherly surname only.
  mother,

  /// The junction of both the fatherly and motherly surnames with a hyphen.
  hyphenated,

  /// The junction of both the fatherly and motherly surnames with a space.
  all
}

/// The order of appearance of a [FullName].
enum NameOrder {
  /// The first part of a full name, usually the first piece of a person name.
  firstName,

  /// The last part of a full name, usually the last piece of a person name.
  lastName
}

/// The types of name handled in this according the name standards.
enum NameType { firstName, middleName, lastName, birthName }

/// The possible variants to indicate how to flatten a [FullName].
enum Flat {
  /// Use the first name's initial combined the remaining parts.
  firstName,

  /// Use the middle name's initial combined the remaining parts.
  middleName,

  /// Use the last name's initial combined the remaining parts.
  lastName,

  /// Use both the first and middle names' initials combined the remaining parts.
  firstMid,

  /// Use both the last and middle names' initials combined the remaining parts.
  midLast,

  /// Use the first, middle and last names' initials combined the remaining parts.
  all
}

/// The range to use when capitalizing a string content.
enum CapsRange {
  /// No capitalization.
  none,

  /// Apply capitalization to the first letter.
  initial,

  /// Apply capitalization to all the letters.
  all
}

/// The types of capitalization cases supported in this utility.
enum Case {
  /// A camelCase transformation.
  camel,

  /// A dot.case transformation.
  dot,

  /// A hyphen-case transformation.
  hyphen,

  /// A kebab-case transformation.
  kebab,

  /// A lowerase transformation.
  lower,

  /// A PascalCase transformation.
  pascal,

  /// A snake_case transformation.
  snake,

  /// A ToGgLe transformation.
  toggle,

  /// An UPPERCASE transformation.
  upper
}

/// The types of name handled in this utility according the name standards.
///
/// **Note**:
/// The word `namon` does not exist. It is a singular form used to refer to a
/// piece of name. And the plural form is `nama`.
class Namon {
  const Namon._(this.index, this.key);

  /// The integer-based indexing factor.
  final int index;

  /// The string name of a namon.
  final String key;

  static const Namon prefix = Namon._(0, 'prefix');

  static const Namon firstName = Namon._(1, 'firstName');

  static const Namon middleName = Namon._(2, 'middleName');

  static const Namon lastName = Namon._(3, 'lastName');

  static const Namon suffix = Namon._(4, 'suffix');

  /// The list of supported name types.
  static const List<Namon> values = [
    prefix,
    firstName,
    middleName,
    lastName,
    suffix,
  ];

  /// The predefined name types as a [Map].
  static Map<String, Namon> get nama => {
        prefix.key: prefix,
        firstName.key: firstName,
        middleName.key: middleName,
        lastName.key: lastName,
        suffix.key: suffix,
      };

  @override
  bool operator ==(Object? other) =>
      other is Namon && other.index == index && other.key == key;

  @override
  int get hashCode => hashValues(index, key);

  @override
  String toString() => 'Namon.$key';

  /// Whether this string [key] is part of the predefined keys.
  static bool containsKey(String key) => nama.containsKey(key);

  /// Makes a string [key] a namon type.
  static Namon? cast(String key) => containsKey(key) ? nama[key] : null;
}

/// The token used to indicate how to split string values.
class Separator {
  const Separator._(this.name, this.token);

  /// The name of the separator.
  final String name;

  /// The character representative of the separator.
  final String token;

  static const Separator comma = Separator._('comma', ',');

  static const Separator colon = Separator._('colon', ':');

  static const Separator doubleQuote = Separator._('doubleQuote', '"');

  static const Separator empty = Separator._('empty', '');

  static const Separator hyphen = Separator._('hyphen', '-');

  static const Separator period = Separator._('period', '.');

  static const Separator semiColon = Separator._('semiColon', ';');

  static const Separator singleQuote = Separator._('singleQuote', "'");

  static const Separator space = Separator._('space', ' ');

  static const Separator underscore = Separator._('underscore', '_');

  /// All the available separators.
  static final Map<String, Separator> values = Map.unmodifiable({
    comma.name: comma,
    colon.name: colon,
    doubleQuote.name: doubleQuote,
    empty.name: empty,
    hyphen.name: hyphen,
    period.name: period,
    semiColon.name: semiColon,
    singleQuote.name: singleQuote,
    space.name: space,
    underscore.name: underscore,
  });

  /// All the available tokens.
  static final Set<String> tokens = values.values.map((s) => s.token).toSet();

  @override
  bool operator ==(Object? other) =>
      other is Separator && other.name == name && other.token == token;

  @override
  int get hashCode => hashValues(name, token);

  @override
  String toString() => 'Separator.$name';
}
