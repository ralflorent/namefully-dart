/// Name class definition
import 'enums.dart';
import 'util.dart';

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

/// Summary of descriptive stats of the name
class Summary {
  Map<String, int> _distribution = {};
  int _count = 0;
  int _frequency = 0;
  String _top = '';
  int _unique = 0;
  final String _namon;

  /// Creates a [Summary] of a given string of alphabetical characters
  Summary(this._namon, {List<String> restrictions = const [' ']}) {
    _compute(restrictions);
  }

  Map<String, int> get distribution => _distribution;
  int get count => _count;
  int get frequency => _frequency;
  String get top => _top;
  int get unique => _unique;
  int get length => _namon?.length;

  void _compute(List<String> restrictions) {
    _distribution = _groupByChar();
    for (var char in _distribution.keys) {
      if (restrictions.contains(_distribution[char]) == false) {
        _count += _distribution[char];
        if (_distribution[char] >= _frequency) {
          _frequency = _distribution[char];
          _top = char;
        }
        _unique++;
      }
    }
  }

  Map<String, int> _groupByChar() {
    final frequencies = <String, int>{};
    for (var char in _namon.split('')) {
      if (frequencies.containsKey(char)) {
        frequencies[char] += 1;
      } else {
        frequencies[char] = 1;
      }
    }
    return frequencies;
  }
}
