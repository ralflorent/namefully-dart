/// [LastName] class definition

import 'enums.dart';
import 'name.dart';
import 'summary.dart';
import '../util.dart';

/// Represents a last name with some extra functionalities.
class LastName extends Name {
  String father;
  String mother;
  LastNameFormat format;

  /// Creates a [LastName] from a [Namon] by indicating a first name [type]
  /// while considering [more] additional pieces of a given name.
  LastName(this.father, [this.mother, this.format = LastNameFormat.father])
      : super(father, Namon.lastName);

  /// Returns a string representation of the namon.
  @override
  String toString({LastNameFormat format}) {
    format = format ?? this.format;
    switch (format) {
      case LastNameFormat.father:
        return father;
      case LastNameFormat.mother:
        return mother ?? '';
      case LastNameFormat.hyphenated:
        return hasMother() ? '$father-$mother' : father;
      case LastNameFormat.all:
        return hasMother() ? '$father $mother' : father;
      default:
        return null;
    }
  }

  /// Determines whether a [LastName] has more name parts.
  bool hasMother() => mother != null && mother.isNotEmpty;

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  @override
  Summary stats(
          {LastNameFormat format, List<String> restrictions = const [' ']}) =>
      Summary(toString(format: format), restrictions: restrictions);

  /// Gets the initials of the [LastName].
  @override
  List<String> initials({LastNameFormat format}) {
    format ??= this.format;
    final initials = <String>[];
    switch (format) {
      case LastNameFormat.father:
        initials.add(father[0]);
        break;
      case LastNameFormat.mother:
        if (hasMother()) initials.add(mother[0]);
        break;
      case LastNameFormat.hyphenated:
      case LastNameFormat.all:
        initials.add(father[0]);
        if (hasMother()) initials.add(mother[0]);
        break;
      default:
        initials.add(father[0]);
    }
    return initials;
  }

  /// Capitalizes a [LastName].
  @override
  void caps([Uppercase option]) {
    super.caps(option);
    if (option == Uppercase.initial) {
      father = father[0].toUpperCase() + father.substring(1);
      if (hasMother()) mother = mother[0].toUpperCase() + mother.substring(1);
    } else {
      father = father.toUpperCase();
      if (hasMother()) mother = mother.toUpperCase();
    }
  }

  /// De-capitalizes a [LastName].
  @override
  void decaps([Uppercase option]) {
    super.decaps(option);
    if (option == Uppercase.initial) {
      father = father[0].toLowerCase() + father.substring(1);
      if (hasMother()) mother = mother[0].toLowerCase() + mother.substring(1);
    } else {
      father = father.toLowerCase();
      if (hasMother()) mother = mother.toLowerCase();
    }
  }

  /// Normalizes the [LastName] as it should be.
  @override
  void normalize() {
    father = father[0].toUpperCase() + father.substring(1).toLowerCase();
    if (hasMother()) {
      mother = mother[0].toUpperCase() + mother.substring(1).toLowerCase();
    }
  }

  /// Creates a password-like representation of a [LastName].
  @override
  String passwd() => generatePassword(toString());
}
