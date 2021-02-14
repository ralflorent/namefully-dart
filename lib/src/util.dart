/// Utils

import 'models/enums.dart';

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
