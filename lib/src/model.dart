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
  FullName.fromMap(Map<String, String> map)
      : prefix = map['prefix'],
        firstName = map['firstName'],
        middleName =
            map['middleName'] != null ? map['middleName'].split(' ') : [],
        lastName = map['lastName'],
        suffix = map['suffix'];
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

  Config(this.orderedBy, this.separator);
}

class Summary {}

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

enum AbbrTitle { us, uk }

enum LastNameFormat { father, mother, hyphenated, all }

enum NameOrder { firstName, lastName }

enum NameType { firstName, middleName, lastName }

/// [Namon] contains the finite set of a representative piece of a name.
///
/// The word `Namon` is the singular form used to refer to a chunk|part|piece of
/// a name. And the plural form is `Nama`. (Same idea as in criterion/criteria)
enum Namon { prefix, firstName, middleName, lastName, suffix }

abstract class Parser<T> {
  /// raw data to be parsed
  T raw;

  /// Parses the raw data into a full name
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat});
}

class StringParser implements Parser<String> {
  @override
  String raw;

  StringParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final names = raw.split(SeparatorToken.extract(separator));
    return ListStringParser(names).parse(orderedBy: orderedBy, bypass: bypass);
  }
}

class ListStringParser implements Parser<List<String>> {
  @override
  List<String> raw;

  ListStringParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final raw = this.raw.map((n) => n.trim()).toList();
    return _distribute(raw);
  }

  FullName _distribute(List<String> raw) {
    final fullName = FullName.fromMap({});
    switch (raw.length) {
      case 2:
        fullName.firstName = raw.elementAt(0);
        fullName.lastName = raw.elementAt(1);
        break;
      case 3:
        fullName.firstName = raw.elementAt(0);
        fullName.middleName.add(raw.elementAt(1));
        fullName.lastName = raw.elementAt(2);
        break;
    }
    return fullName;
  }
}

class SeparatorToken {
  static final comma = ',';
  static final colon = ':';
  static final empty = '';
  static final doubleQuote = '"';
  static final hyphen = '-';
  static final period = '.';
  static final singleQuote = "'";
  static final space = ' ';
  static final underscore = '_';

  static String extract(Separator separator) {
    switch (separator.index) {
      case 0:
        return SeparatorToken.comma;
      case 1:
        return SeparatorToken.colon;
      case 2:
        return SeparatorToken.empty;
      case 3:
        return SeparatorToken.doubleQuote;
      case 4:
        return SeparatorToken.hyphen;
      case 5:
        return SeparatorToken.period;
      case 6:
        return SeparatorToken.singleQuote;
      case 7:
        return SeparatorToken.space;
      case 8:
        return SeparatorToken.underscore;
      default:
        return null;
    }
  }
}
