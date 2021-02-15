/// Utils

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
