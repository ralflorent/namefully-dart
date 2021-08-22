import 'dart:math';

import 'constants.dart';
import 'enums.dart';

/// A fixed set of values to handle specific positions for list of names.
///
/// As for list of names, this helps to follow a specific order based on the
/// count of elements. It is expected that the list has to be between two and
/// five elements. Also, the order of appearance set in the [Config]uration
/// influences how the parsing is carried out.
///
/// Ordered by first name, the parser works as follows:
/// - 2 elements: firstName lastName
/// - 3 elements: firstName middleName lastName
/// - 4 elements: prefix firstName middleName lastName
/// - 5 elements: prefix firstName middleName lastName suffix
///
/// Ordered by last name, the parser works as follows:
/// - 2 elements: lastName firstName
/// - 3 elements: lastName firstName middleName
/// - 4 elements: prefix lastName firstName middleName
/// - 5 elements: prefix lastName firstName middleName suffix
///
/// For example, `Jane Smith` (ordered by first name) is expected to be indexed:
/// `['Jane', 'Smith']`.
class NameIndex {
  final int prefix, firstName, middleName, lastName, suffix;
  const NameIndex(
    this.prefix,
    this.firstName,
    this.middleName,
    this.lastName,
    this.suffix,
  );
}

/// Reorganizes the existing global indexes for list of name parts:
/// [orderedBy] first or last name, of [argLength] of the provided array, using
/// [nameIndex] as a global preset of indexing.
NameIndex organizeNameIndex(
  NameOrder orderedBy,
  int argLength, {
  NameIndex? nameIndex,
}) {
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

/// Capitalizes a [string] via a [CapsRange] option.
String capitalize(String string, [CapsRange range = CapsRange.initial]) {
  if (string.isEmpty || range == CapsRange.none) return string;
  final initial = string[0].toUpperCase();
  final rest = string.substring(1).toLowerCase();
  return range == CapsRange.initial ? (initial + rest) : string.toUpperCase();
}

/// De-capitalizes a [string] via a [CapsRange] option.
String decapitalize(String string, [CapsRange range = CapsRange.initial]) {
  if (string.isEmpty || range == CapsRange.none) return string;
  final initial = string[0].toLowerCase();
  final rest = string.substring(1);
  return range == CapsRange.initial ? (initial + rest) : string.toLowerCase();
}

/// Toggles a [string] representation.
String toggleCase(String string) {
  var chars = <String>[];
  for (final c in string.split('')) {
    chars.add(c == c.toUpperCase() ? c.toLowerCase() : c.toUpperCase());
  }
  return chars.join();
}

/// Makes a [Set] capable of [random]izing its elements.
extension CharSet<E> on Set<E> {
  /// Shuffles the elements within a set and returns a random one.
  E random() => List<E>.from(this).elementAt(Random().nextInt(length));
}

/// Add validation capabilities to [String].
extension StringValidation on String {
  /// A minimum 2 characters must be provided.
  bool get isValid => trim().isNotEmpty && trim().length > 1;

  /// A minimum 2 characters must be provided.
  bool get isInvalid => !isValid;
}

/// Enable nullable check for first values on [Iterable]s.
extension FirstOrNullIterable<E> on Iterable<E> {
  /// The first value if any.
  E? get firstOrNull => length == 0 ? null : elementAt(0);
}

/// Generates a password-like content from a [string].
String generatePassword(String string) {
  var mapper = kPasswordMapper;
  return string.toLowerCase().split('').map((char) {
    return mapper.containsKey(char)
        ? mapper[char]!.random()
        : mapper['\$']!.random();
  }).join();
}

abstract class NamonKey {
  static const prefix = 'prefix';
  static const firstName = 'firstName';
  static const middleName = 'middleName';
  static const lastName = 'lastName';
  static const suffix = 'suffix';

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

  static Namon? cast(String string) {
    switch (string) {
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
