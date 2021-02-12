/// [LastName] class definition

import './enums.dart';
import './name.dart';
import './summary.dart';

/// Represents a first name with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class LastName extends Name {
  String father;
  String mother;
  LastNameFormat format;

  /// Constructs a [LastName] from a [Namon] by indicating a first name [type]
  /// while considering [more] additional pieces of a given name.
  LastName(this.father, [this.mother, this.format = LastNameFormat.father])
      : super(father, Namon.lastName);

  /// Returns a string representation of the namon.
  @override
  String toString({LastNameFormat format}) {
    format = format ?? this.format;
    switch (format.index) {
      case 0:
        return father;
      case 1:
        return mother ?? '';
      case 2:
        return hasMother() ? '$father-$mother' : father;
      case 3:
        return hasMother() ? '$father-$mother' : father;
      default:
        return null;
    }
  }

  /// Determines whether a [LastName] has more name parts.
  bool hasMother() {
    return mother != null && mother.isNotEmpty;
  }

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  @override
  Summary stats({bool includeAll = false}) {
    throw UnimplementedError();
  }

  /// Gets the initials of the [LastName].
  @override
  List<String> initials({bool includeAll = false}) {
    throw UnimplementedError();
  }

  /// Capitalizes a [LastName].
  @override
  LastName cap([Capitalization option]) {
    throw UnimplementedError();
  }

  /// De-capitalizes a [LastName].
  @override
  LastName decap([Capitalization option]) {
    throw UnimplementedError();
  }

  /// Normalizes the [LastName] as it should be.
  @override
  LastName norm() {
    throw UnimplementedError();
  }

  /// Creates a password-like representation of a [FirstName].
  @override
  String passwd() {
    throw UnimplementedError();
  }
}
