/// Models

import 'package:meta/meta.dart';

abstract class Nama {
  String prefix, firstName, lastName, suffix;
  List<String> middleName;
}

class FullName implements Nama {
  String prefix, firstName, lastName, suffix;
  List<String> middleName;
  FullName(
      {this.prefix,
      @required this.firstName,
      this.middleName = const [],
      @required this.lastName,
      this.suffix});
}

class Config {
  /// The order of appearance of a full name: by [firstName] or [lastName].
  NameOrder orderedBy = NameOrder.firstName;

  /// For literal `String` input, this is the parameter used to indicate the
  /// token to utilize to split the string names.
  Separator separator;

  /// Whether or not to add period to a prefix using the American or British way.
  AbbrTitle titling;

  /// Indicates if the ending suffix should be separated with a comma or space.
  bool ending;

  /// Bypass the validation rules with this option. Since I only provide a
  /// handful of suffixes or prefixes in English, this parameter is ideal to
  /// avoid checking their validity.
  bool bypass;

  /// Custom parser, a user-defined parser indicating how the name set is
  /// organized. [Namefully] cannot guess it.
  dynamic parser;

  /// how to format a surname:
  /// - 'father' (father name only)
  /// - 'mother' (mother name only)
  /// - 'hyphenated' (joining both father and mother names with a hyphen)
  /// - 'all' (joining both father and mother names with a space).
  ///
  /// This parameter can be set either by an instance of a last name or during
  /// the creation of a namefully instance. To avoid ambiguity, we prioritize as
  /// source of truth the value set as optional parameter when instantiating
  /// namefully.
  LastNameFormat lastNameFormat;
}

class Summary {}

/// The [Separator] values representing some of the ASCII characters
enum Separator {
  colon,
  comma,
  empty,
  hyphen,
  period,
  space,
  singleQuote,
  doubleQuote,
  underscore
}

enum AbbrTitle { us, uk }

enum LastNameFormat { father, mother, hyphenated, all }

enum NameOrder { firstName, lastName }

enum NameType { firstName, middleName, lastName }

/// [Namon] contains the finite set of a representative piece of a name.
///
/// The word `Namon` is the singular form used to refer to a chunk|part|piece of
/// a name. And the plural form is `Nama`. (Same idea as in criterion/criteria)
enum Namon { prefix, firstName, middleName, lastName, suffix }
