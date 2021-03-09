/// Utils

import 'constants.dart';
import 'enums.dart';
import 'extensions.dart';

class NameIndex {
  final int prefix, firstName, middleName, lastName, suffix;
  const NameIndex(
      this.prefix, this.firstName, this.middleName, this.lastName, this.suffix);
}

/// Reorganizes the existing global indexes for array of name parts:
/// [orderedBy] by first or last name, [argLength] length of the provided array,
/// [nameIndex] global preset of indexing.
NameIndex organizeNameIndex(NameOrder orderedBy, int argLength,
    {NameIndex? nameIndex}) {
  var out = nameIndex ?? const NameIndex(0, 1, 2, 3, 4);
  if (orderedBy == NameOrder.firstName) {
    switch (argLength) {
      case 2: // first name + last name
        out = const NameIndex(-1, 0, -1, 1, -1);
        break;
      case 3: // first name + middle name + last name
        out = const NameIndex(-1, 0, 1, 2, -1);
        break;
      case 4: // prefix + first name + middle name + last name
        out = const NameIndex(0, 1, 2, 3, -1);
        break;
      case 5: // prefix + first name + middle name + last name + suffix
        out = const NameIndex(0, 1, 2, 3, 4);
        break;
    }
  } else {
    switch (argLength) {
      case 2: // last name + first name
        out = const NameIndex(-1, 1, -1, 0, -1);
        break;
      case 3: // last name + first name + middle name
        out = const NameIndex(-1, 1, 2, 0, -1);
        break;
      case 4: // prefix + last name + first name + middle name
        out = const NameIndex(0, 2, 3, 1, -1);
        break;
      case 5: // prefix + last name + first name + middle name + suffix
        out = const NameIndex(0, 2, 3, 1, 4);
        break;
    }
  }
  return out;
}

/// Capitalizes a [string] via a [Capitalization] option.
String capitalize(String string, [Uppercase option = Uppercase.initial]) {
  if (string.isEmpty || option == Uppercase.none) return string;
  final initial = string[0].toUpperCase();
  final rest = string.substring(1).toLowerCase();
  return option == Uppercase.initial ? (initial + rest) : string.toUpperCase();
}

/// De-capitalizes a [string] via a [Capitalization] option.
String decapitalize(String string, [Uppercase option = Uppercase.initial]) {
  if (string.isEmpty || option == Uppercase.none) return string;
  final initial = string[0].toLowerCase();
  final rest = string.substring(1);
  return option == Uppercase.initial ? (initial + rest) : string.toLowerCase();
}

/// Toggles a [string] representation.
String toggleCase(String string) {
  var chars = [];
  for (final c in string.split('')) {
    chars.add(c == c.toUpperCase() ? c.toLowerCase() : c.toUpperCase());
  }
  return chars.join();
}

/// Generates a password [str] content.
String generatePassword(String str) {
  var mapper = passwordMapper;
  return str.split('').map((char) {
    if (mapper.containsKey(char.toLowerCase())) {
      return mapper[char.toLowerCase()]!.random();
    }
    return mapper['\$']!.random();
  }).join();
}

class SeparatorChar {
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
    switch (separator) {
      case Separator.comma:
        return SeparatorChar.comma;
      case Separator.colon:
        return SeparatorChar.colon;
      case Separator.empty:
        return SeparatorChar.empty;
      case Separator.doubleQuote:
        return SeparatorChar.doubleQuote;
      case Separator.hyphen:
        return SeparatorChar.hyphen;
      case Separator.period:
        return SeparatorChar.period;
      case Separator.singleQuote:
        return SeparatorChar.singleQuote;
      case Separator.space:
        return SeparatorChar.space;
      case Separator.underscore:
        return SeparatorChar.underscore;
    }
  }
}

class NamonKey {
  static final prefix = 'prefix';
  static final firstName = 'firstName';
  static final middleName = 'middleName';
  static final lastName = 'lastName';
  static final suffix = 'suffix';

  static String castFrom(Namon namon) {
    switch (namon) {
      case Namon.prefix:
        return NamonKey.prefix;
      case Namon.firstName:
        return NamonKey.firstName;
      case Namon.middleName:
        return NamonKey.middleName;
      case Namon.lastName:
        return NamonKey.lastName;
      case Namon.suffix:
        return NamonKey.suffix;
    }
  }

  static Namon? castTo(String str) {
    switch (str) {
      case 'prefix':
        return Namon.prefix;
      case 'firstName':
        return Namon.firstName;
      case 'middleName':
        return Namon.middleName;
      case 'lastName':
        return Namon.lastName;
      case 'suffix':
        return Namon.suffix;
      default:
        return null;
    }
  }
}
