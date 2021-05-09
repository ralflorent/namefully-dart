const List<String> kAllowedTokens = [
  '.',
  ',',
  ' ',
  '-',
  '_',
  'b',
  'B',
  'f',
  'F',
  'l',
  'L',
  'm',
  'M',
  'n',
  'N',
  'o',
  'O',
  'p',
  'P',
  's',
  'S',
  '\$',
];
const int kMinNumberOfNameParts = 2;
const int kMaxNumberOfNameParts = 5;
const List<String> kRestrictedChars = [' ', "'", '-', '.', ','];
final Map<String, Set<String>> kPasswordMapper = Map.fromIterables([
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
