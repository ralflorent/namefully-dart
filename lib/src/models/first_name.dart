/// [FirstName] class definition

import 'enums.dart';
import 'name.dart';
import 'summary.dart';
import '../util.dart';

/// Represents a first name with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class FirstName extends Name {
  List<String> more;

  /// Constructs a [FirstName] from a [Namon] by indicating a first name [type]
  /// while considering [more] additional pieces of a given name.
  FirstName(String namon, [this.more]) : super(namon, Namon.firstName);

  /// Returns a string representation of the namon.
  @override
  String toString({bool includeAll = false}) {
    return includeAll && hasMore() ? namon + ' ' + more.join(' ') : namon;
  }

  /// Determines whether a [FirstName] has [more] name parts.
  bool hasMore() {
    return more != null && more.isNotEmpty;
  }

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  @override
  Summary stats(
      {bool includeAll = false, List<String> restrictions = const [' ']}) {
    return Summary(toString(includeAll: includeAll),
        restrictions: restrictions);
  }

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
  FirstName cap([Capitalization option]) {
    if (option == Capitalization.initial) {
      namon = namon[0].toUpperCase() + namon.substring(1);
      if (hasMore()) {
        more = more.map((n) => n[0].toUpperCase() + n.substring(1)).toList();
      }
    } else {
      namon = namon.toUpperCase();
      if (hasMore()) more = more.map((n) => n.toUpperCase()).toList();
    }
    return this;
  }

  /// De-capitalizes a [FirstName].
  @override
  FirstName decap([Capitalization option]) {
    if (option == Capitalization.initial) {
      namon = namon[0].toLowerCase() + namon.substring(1);
      if (hasMore()) {
        more = more.map((n) => n[0].toLowerCase() + n.substring(1)).toList();
      }
    } else {
      namon = namon.toUpperCase();
      if (hasMore()) more = more.map((n) => n.toLowerCase()).toList();
    }
    return this;
  }

  /// Normalizes the [FirstName] as it should be.
  @override
  FirstName norm() {
    namon = namon[0].toUpperCase() + namon.substring(1).toLowerCase();
    if (hasMore()) {
      more = more
          .map((n) => n[0].toUpperCase() + n.substring(1).toLowerCase())
          .toList();
    }
    return this;
  }

  /// Creates a password-like representation of a [FirstName].
  @override
  String passwd() {
    return generatePassword(toString(includeAll: true));
  }
}
