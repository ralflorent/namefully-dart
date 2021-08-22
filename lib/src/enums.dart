/// The abbreviation type to indicate whether or not to add period to a prefix
/// using the American or British way.
enum AbbrTitle {
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
enum LastNameFormat {
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

/// The distinct variants to indicate how to flatten a [FullName].
enum FlattenedBy {
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
enum Capitalization {
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
enum Namon { prefix, firstName, middleName, lastName, suffix }

/// The token used to indicate how to split string values.
class Separator {
  const Separator._(this.index, this.name, this.token);

  final int index;
  final String name;
  final String token;

  static const Separator comma = Separator._(0, 'comma', ',');

  static const Separator colon = Separator._(1, 'colon', ':');

  static const Separator empty = Separator._(2, 'empty', '');

  static const Separator doubleQuote = Separator._(3, 'doubleQuote', '"');

  static const Separator hyphen = Separator._(4, 'hyphen', '-');

  static const Separator period = Separator._(5, 'period', '.');

  static const Separator semiColon = Separator._(6, 'semiColon', ';');

  static const Separator singleQuote = Separator._(7, 'singleQuote', "'");

  static const Separator space = Separator._(8, 'space', ' ');

  static const Separator underscore = Separator._(9, 'underscore', '_');

  /// All the available separators.
  static const List<Separator> values = [
    comma,
    colon,
    empty,
    doubleQuote,
    hyphen,
    period,
    semiColon,
    singleQuote,
    space,
    underscore,
  ];

  /// All the available tokens.
  static final tokens = List<String>.unmodifiable(values.map((s) => s.token));

  @override
  bool operator ==(Object? other) =>
      other is Separator &&
      other.index == index &&
      other.name == name &&
      other.token == token;

  // Borrowed from the dart sdk: sdk/lib/math/jenkins_smi_hash.dart.
  @override
  int get hashCode {
    int hash = index.hashCode + name.hashCode + token.hashCode;
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  @override
  String toString() => 'Separator.$name';
}
