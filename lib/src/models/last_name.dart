/// [LastName] class definition

import 'enums.dart';
import 'name.dart';
import 'summary.dart';
import '../util.dart';

/// Representation of a last name with some extra functionalities.
class LastName extends Name {
  String _mother;
  LastNameFormat format;

  /// Creates an extended version of [Name] flags it as a last name [type].
  ///
  /// Some people may keep their [mother]'s surname and want to keep a clear cut
  /// between it and their [father]'s surname. However, there are no clear rules
  /// about it.
  LastName(String father, [this._mother, this.format = LastNameFormat.father])
      : super(father, Namon.lastName);

  /// The surname inherited from a father side.
  String get father => namon;

  /// The surname inherited from a mother side.
  String get mother => _mother;

  /// Returns a string representation of [this].
  @override
  String toString({LastNameFormat format}) {
    format = format ?? this.format;
    switch (format) {
      case LastNameFormat.father:
        return namon;
      case LastNameFormat.mother:
        return _mother;
      case LastNameFormat.hyphenated:
        return hasMother() ? '$namon-$_mother' : namon;
      case LastNameFormat.all:
        return hasMother() ? '$namon $_mother' : namon;
      default:
        return null;
    }
  }

  /// Returns `true` if the [mother]'s surname is defined.
  bool hasMother() => _mother != null && _mother.isNotEmpty;

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  @override
  Summary stats(
          {LastNameFormat format, List<String> restrictions = const [' ']}) =>
      Summary(toString(format: format), restrictions: restrictions);

  /// Gets the initials of [this].
  @override
  List<String> initials({LastNameFormat format}) {
    format ??= this.format;
    final initials = <String>[];
    switch (format) {
      case LastNameFormat.father:
        initials.add(namon[0]);
        break;
      case LastNameFormat.mother:
        if (hasMother()) initials.add(_mother[0]);
        break;
      case LastNameFormat.hyphenated:
      case LastNameFormat.all:
        initials.add(namon[0]);
        if (hasMother()) initials.add(_mother[0]);
        break;
      default:
        initials.add(namon[0]);
    }
    return initials;
  }

  /// Capitalizes [this].
  @override
  void caps([Uppercase option]) {
    option ??= capitalized;
    if (option == Uppercase.initial) {
      namon = capitalize(namon);
      if (hasMother()) _mother = capitalize(_mother);
    } else if (option == Uppercase.all) {
      namon = namon.toUpperCase();
      if (hasMother()) _mother = _mother.toUpperCase();
    }
  }

  /// De-capitalizes [this].
  @override
  void decaps([Uppercase option]) {
    option ??= capitalized;
    if (option == Uppercase.initial) {
      namon = decapitalize(namon);
      if (hasMother()) _mother = decapitalize(_mother);
    } else if (option == Uppercase.all) {
      namon = namon.toLowerCase();
      if (hasMother()) _mother = _mother.toLowerCase();
    }
  }

  /// Normalizes [this] as it should be.
  @override
  void normalize() {
    namon = capitalize(namon);
    if (hasMother()) _mother = _mother.toLowerCase();
  }

  /// Creates a password-like representation of [this].
  @override
  String passwd() => generatePassword(toString());
}
