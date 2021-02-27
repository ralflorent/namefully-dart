/// Name class definition

import 'enums.dart';
import 'summary.dart';
import '../util.dart';

/// Representation of a string type name with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class Name {
  String _namon;
  String _initial;
  String _body;
  final Uppercase _cap;
  Namon type;
  bool isEmpty;
  bool isNotEmpty;

  /// Creates augmented names by adding extra functionalities to a string name.
  ///
  /// A name [type] must be indicated to categorize [this] name so it can
  /// be treated accordingly. [cap] determines how a [this] name should be
  /// capitalized.
  Name(this._namon, this.type, [Uppercase cap])
      : isEmpty = _namon.isEmpty,
        isNotEmpty = _namon.isNotEmpty,
        _initial = _namon[0],
        _body = _namon.substring(1),
        _cap = cap ?? Uppercase.initial {
    if (cap != null) caps(cap);
  }

  String get namon => _namon;
  set namon(String namon) {
    _namon = namon;
    isEmpty = _namon.isEmpty;
    isNotEmpty = _namon.isNotEmpty;
    _initial = _namon[0];
    _body = _namon.substring(1);
    caps(_cap);
  }

  Uppercase get capitalized => _cap;

  @override
  String toString() => _namon;

  /// Returns true if [other] is equal to [this].
  @override
  bool operator ==(other) =>
      other is Name && other.namon == namon && other.type == type;

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  Summary stats() => Summary(_namon);

  /// Gets the initials (first character) of [this].
  List<String> initials() => [_initial];

  /// Capitalizes [this].
  void caps([Uppercase option]) {
    option ??= _cap;
    if (option == Uppercase.initial) {
      namon = '${_initial.toUpperCase()}$_body';
    } else if (option == Uppercase.all) {
      namon = '${_initial.toUpperCase()}${_body.toUpperCase()}';
    } else {
      namon = _namon.toLowerCase();
    }
  }

  /// De-capitalizes [this].
  void decaps([Uppercase option]) {
    option ??= _cap;
    if (option == Uppercase.initial) {
      namon = '${_initial.toLowerCase()}$_body';
    } else if (option == Uppercase.all) {
      namon = '${_initial.toLowerCase()}${_body.toLowerCase()}';
    } else {
      namon = _namon.toUpperCase();
    }
  }

  /// Normalizes [this] as it should be.
  void normalize() =>
      _namon = '${_initial.toUpperCase()}${_body.toLowerCase()}';

  /// Creates a password-like representation of [this].
  String passwd() => generatePassword(namon);
}
