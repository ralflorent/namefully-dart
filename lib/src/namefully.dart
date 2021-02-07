/// Welcome to namefully!
///
/// namefully is a dart utility for handing person names.
///
/// Sources
/// - repo: https://github.com/ralflorent/namefully-dart
/// - docs: https://namefully.dev
/// - pub:  https://pub.dev/packages/namefully
///
/// @license MIT
///
///
import 'package:meta/meta.dart';

class Namefully {
  /// Holds a copy high quality of name data
  FullName _fullName;

  /// Holds statistical info on the name data
  dynamic _summary;

  /// Holds a copy of the preset configuration
  Config _config;

  Namefully(String name, {Config options}) {
    _buildFromString(name);
  }
  Namefully.fromList(List<String> names, [Config config]);
  Namefully.fromJson(Map<String, String> nama, [Config config]);

  String fullName() {
    return 'namefully';
  }

  String birthName([NameOrder orderedBy]) {
    var by = orderedBy ?? NameOrder.firstName;
    if (by == NameOrder.firstName) {
      return '${_fullName.firstName} ${_fullName.lastName}';
    } else {
      return '${_fullName.lastName} ${_fullName.firstName}';
    }
  }

  void _buildFromString(String name) {
    // shortcut for parsing
    List<String> names = name.split(' ');
    _fullName = FullName(firstName: names[0], lastName: names[1]);
  }
}

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

/// [Namon] contains the finite set of a representative piece of a name
///
/// The word `Namon` is the singular form used to refer to a chunk|part|piece of
/// a name. And the plural form is `Nama`. (Same idea as in criterion/criteria)
enum Namon { prefix, firstName, middleName, lastName, suffix }
