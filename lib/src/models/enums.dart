/// Enumerated types

enum AbbrTitle { us, uk }

enum LastNameFormat { father, mother, hyphenated, all }

enum NameOrder { firstName, lastName }

enum NameType { firstName, middleName, lastName }

enum FlattenedBy { firstName, middleName, lastName, firstMid, midLast, all }

enum Capitalization { none, initial, all }

enum TitleCase {
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

/// [Namon] contains the finite set of a representative piece of a name.
///
/// The word `Namon` is the singular form used to refer to a chunk|part|piece of
/// a name. And the plural form is `Nama`. (Same idea as in criterion/criteria)
enum Namon { prefix, firstName, middleName, lastName, suffix }

/// The [Separator] values representing some of the ASCII characters
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
