/// [FirstName] class definition

import 'enums.dart';
import 'name.dart';
import 'summary.dart';
import '../util.dart';

/// Represents a first name with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class FirstName extends Name {
  /// The additional name parts of a [this].
  List<String> more = [];

  /// Creates an extended version of [Name] flags it as a first name [type].
  ///
  /// Some may consider [more] additional name parts of a given name as their
  /// first names, but not as a middle name. Though, it may mean the same,
  /// [more] provides the liberty to name as-is.
  FirstName(String namon, [this.more]) : super(namon, Namon.firstName);

  @override
  String toString({bool includeAll = false}) =>
      includeAll && hasMore() ? namon + ' ' + more.join(' ') : namon;

  /// Determines whether a [FirstName] has [more] name parts.
  bool hasMore() => more != null && more.isNotEmpty;

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  @override
  Summary stats(
          {bool includeAll = false, List<String> restrictions = const [' ']}) =>
      Summary(toString(includeAll: includeAll), restrictions: restrictions);

  /// Gets the initials of the [FirstName].
  @override
  List<String> initials({bool includeAll = false}) {
    final initials = [namon[0]];
    if (includeAll && hasMore()) {
      initials.addAll(more.map((n) => n[0]).toList());
    }
    return initials;
  }

  /// Capitalizes a [FirstName].
  @override
  void caps([Uppercase option]) {
    if (option == Uppercase.initial) {
      namon = namon[0].toUpperCase() + namon.substring(1);
      if (hasMore()) {
        more = more.map((n) => n[0].toUpperCase() + n.substring(1)).toList();
      }
    } else {
      namon = namon.toUpperCase();
      if (hasMore()) more = more.map((n) => n.toUpperCase()).toList();
    }
  }

  /// De-capitalizes a [FirstName].
  @override
  void decaps([Uppercase option]) {
    if (option == Uppercase.initial) {
      namon = namon[0].toLowerCase() + namon.substring(1);
      if (hasMore()) {
        more = more.map((n) => n[0].toLowerCase() + n.substring(1)).toList();
      }
    } else {
      namon = namon.toUpperCase();
      if (hasMore()) more = more.map((n) => n.toLowerCase()).toList();
    }
  }

  /// Normalizes the [FirstName] as it should be.
  @override
  void normalize() {
    namon = namon[0].toUpperCase() + namon.substring(1).toLowerCase();
    if (hasMore()) {
      more = more
          .map((n) => n[0].toUpperCase() + n.substring(1).toLowerCase())
          .toList();
    }
  }

  /// Creates a password-like representation of a [FirstName].
  @override
  String passwd() => generatePassword(toString(includeAll: true));
}
