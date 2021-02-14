/// Name class definition

import './enums.dart';
import './summary.dart';

/// Represents a namon with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class Name {
  final String _initial;
  final String _body;
  String namon;
  Namon type;

  /// Constructs a [Name] from a [Namon] by indicating which name [type] to use.
  ///
  /// [cap] determines how a [Name] should be capitalized.
  Name(this.namon, this.type, [Capitalization cap])
      : _initial = namon[0],
        _body = namon.substring(1) {
    if (cap != null) this.cap(cap);
  }

  /// Returns a [String] representation of the namon.
  @override
  String toString() {
    return namon;
  }

  /// Returns true if [other] is equal to this [Name].
  @override
  bool operator ==(other) => other.namon == namon && other.type == type;

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  Summary stats() {
    return Summary(namon);
  }

  /// Gets the initials of the [Name].
  List<String> initials() {
    return [_initial];
  }

  /// Capitalizes a [Name].
  Name cap([Capitalization option]) {
    final initial = _initial.toUpperCase();
    if (option == Capitalization.initial) {
      namon = '$initial$_body';
    } else {
      namon = '$initial${_body.toUpperCase()}';
    }
    return this;
  }

  /// De-capitalizes a [Name].
  Name decap([Capitalization option]) {
    final initial = _initial.toLowerCase();
    if (option == Capitalization.initial) {
      namon = '$initial$_body';
    } else {
      namon = '$initial${_body.toLowerCase()}';
    }
    return this;
  }

  /// Normalizes the [Name] as it should be.
  Name norm() {
    namon = '${_initial.toUpperCase()}${_body.toLowerCase()}';
    return this;
  }

  /// Resets to the initial namon.
  Name reset() {
    namon = '$_initial${_body}';
    return this;
  }

  /// Creates a password-like representation of a [Name].
  String passwd() {
    throw UnimplementedError();
  }
}
