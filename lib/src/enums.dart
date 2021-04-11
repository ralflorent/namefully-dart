/// The abbreviation type to indicate whether or not to add period to a prefix
/// using the American or British way.
enum AbbrTitle {
  us,
  uk,
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

  /// The first part of a full name, usually the last piece of a person name.
  lastName
}

/// The types of name handled in this according the name standards.
enum NameType { firstName, middleName, lastName, birthName }

/// The distinct variants to indicate how to flatten a [FullName].
enum FlattenedBy { firstName, middleName, lastName, firstMid, midLast, all }

/// The range to use when capitalizing a string content.
enum CapsRange { none, initial, all }

/// The types of capitalization cases supported in this utility.
enum Capitalization {
  camel,
  dot,
  hyphen,
  kebab,
  lower,
  pascal,
  snake,
  toggle,
  upper
}

/// The types of name handled in this utility according the name standards.
///
/// **Note**:
/// The word `namon` does not exist. It is a singular form used to refer to a
/// piece of name. And the plural form is `nama`.
enum Namon { prefix, firstName, middleName, lastName, suffix }

/// The token used to indicate how to split string values.
enum Separator {
  comma,
  colon,
  empty,
  doubleQuote,
  hyphen,
  period,
  singleQuote,
  space,
  underscore
}
