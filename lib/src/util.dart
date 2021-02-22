/// Utils

import 'extensions.dart';
import 'models/enums.dart';

class NameIndex {
  final int prefix, firstName, middleName, lastName, suffix;
  const NameIndex(
      this.prefix, this.firstName, this.middleName, this.lastName, this.suffix);
}

/// Reorganizes the existing global indexes for array of name parts:
/// [orderedBy] by first or last name, [argLength] length of the provided array,
/// [nameIndex] global preset of indexing.
NameIndex organizeNameIndex(NameOrder orderedBy, int argLength,
    {NameIndex nameIndex}) {
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
String capitalize(String string,
    [Capitalization option = Capitalization.initial]) {
  if (string.isEmpty || option == Capitalization.none) return string;
  final initial = string[0].toUpperCase();
  final rest = string.substring(1).toLowerCase();
  return option == Capitalization.initial
      ? (initial + rest)
      : string.toUpperCase();
}

/// De-capitalizes a [string] via a [Capitalization] option.
String decapitalize(String string,
    [Capitalization option = Capitalization.initial]) {
  if (string.isEmpty || option == Capitalization.none) return string;
  final initial = string[0].toLowerCase();
  final rest = string.substring(1);
  return option == Capitalization.initial
      ? (initial + rest)
      : string.toLowerCase();
}

/// Toggles a [string] representation.
String toggleCase(String string) {
  var chars = [];
  for (final c in string.split('')) {
    if (c == c.toUpperCase()) {
      chars.add(c.toLowerCase());
    } else {
      chars.add(c.toUpperCase());
    }
  }
  return chars.join();
}

final _passwordMapper = Map.fromIterables([
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  '\$'
], [
  {'a', 'A', '@', '4'},
  {'b', 'B', '6', '|)', '|3', '|>'},
  {'c', 'C', '(', '<'},
  {'d', 'D', '(|', '<|'},
  {'e', 'E', '3', '*'},
  {'f', 'F', '7', '(-'},
  {'g', 'G', '8', '&', '**'},
  {'h', 'H', '#', '|-|'},
  {'i', 'I', '!', '1', '|', '--'},
  {'j', 'J', ')', '1'},
  {'k', 'K', '%', '|<'},
  {'l', 'L', '1', '!', '|_'},
  {'m', 'M', '^^', '>>'},
  {'n', 'N', '!=', '++'},
  {'o', 'O', '0', '.', '*'},
  {'p', 'P', '|3', '|)', '|>'},
  {'q', 'Q', '&', '9', '<|'},
  {'r', 'R', '7', '&'},
  {'s', 'S', '5', '\$'},
  {'t', 'T', '7', '['},
  {'u', 'U', '|_|', 'v'},
  {'v', 'V', '>', '<', '^'},
  {'w', 'W', '[|]', 'vv'},
  {'x', 'X', '%', '#'},
  {'y', 'Y', '-/', '-]'},
  {'z', 'Z', '2', '!='},
  {
    '!',
    '@',
    '#',
    '\$',
    '%',
    '^',
    '&',
    '*',
    '(',
    ')',
    '-',
    '+',
    '[',
    '_',
    '=',
    '{',
    '}',
    ':',
    ';',
    ',',
    '.',
    '<',
    '>',
    '|',
    '~',
    ']',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  }
]);

/// Generates a password [str] content.
String generatePassword(String str) {
  var mapper = _passwordMapper;
  return str.split('').map((char) {
    if (mapper.containsKey(char.toLowerCase())) {
      return mapper[char.toLowerCase()].random();
    }
    return mapper['\$'].random();
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
      default:
        return null;
    }
  }
}
