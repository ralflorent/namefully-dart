/// [FirstName] class definition

import 'enums.dart';
import 'name.dart';
import 'summary.dart';
import '../util.dart';

/// Representation of a first name with some extra functionalities.
class FirstName extends Name {
  /// The additional name parts of a [this].
  List<String> _more = [];

  /// Creates an extended version of [Name] flags it as a first name [type].
  ///
  /// Some may consider [more] additional name parts of a given name as their
  /// first names, but not as a middle name. Though, it may mean the same,
  /// [more] provides the liberty to name as-is.
  FirstName(String namon, [this._more]) : super(namon, Namon.firstName);

  List<String> get more => _more;

  @override
  String toString({bool includeAll = false}) =>
      includeAll && hasMore() ? '$namon ${_more.join(" ")}' : namon;

  /// Determines whether a [FirstName] has [more] name parts.
  bool hasMore() => _more != null && _more.isNotEmpty;

  /// Returns a combined version of [this] and [more] if any.
  List<Name> asNames() {
    return [
      Name(namon, Namon.firstName),
      if (hasMore()) ..._more.map((n) => Name(n, Namon.firstName))
    ];
  }

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  @override
  Summary stats(
          {bool includeAll = false, List<String> restrictions = const [' ']}) =>
      Summary(toString(includeAll: includeAll), restrictions: restrictions);

  /// Gets the initials of [this].
  @override
  List<String> initials({bool includeAll = false}) =>
      [namon[0], if (includeAll && hasMore()) ..._more.map((n) => n[0])];

  /// Capitalizes [this].
  @override
  void caps([Uppercase option]) {
    option ??= capitalized;
    if (option == Uppercase.initial) {
      namon = capitalize(namon);
      if (hasMore()) _more = _more.map(capitalize).toList();
    } else if (option == Uppercase.all) {
      namon = namon.toUpperCase();
      if (hasMore()) _more = _more.map((n) => n.toUpperCase()).toList();
    }
  }

  /// De-capitalizes [this].
  @override
  void decaps([Uppercase option]) {
    option ??= capitalized;
    if (option == Uppercase.initial) {
      namon = decapitalize(namon);
      if (hasMore()) _more = _more.map(decapitalize).toList();
    } else if (option == Uppercase.all) {
      namon = namon.toUpperCase();
      if (hasMore()) _more = _more.map((n) => n.toLowerCase()).toList();
    }
  }

  /// Normalizes [this] as it should be.
  @override
  void normalize() {
    namon = capitalize(namon);
    if (hasMore()) _more = _more.map(capitalize).toList();
  }

  /// Creates a password-like representation of [this].
  @override
  String passwd() => generatePassword(toString(includeAll: true));
}
