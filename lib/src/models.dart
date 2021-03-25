import 'enums.dart';
import 'utils.dart';

/// Representation of a string type name with some extra functionalities.
///
/// It helps to define and understand the concept of namon/nama.
class Name {
  late String _namon;
  late String _initial;
  late String _body;
  final CapsRange _cap;
  Namon type;
  late bool isEmpty;
  late bool isNotEmpty;

  /// Creates augmented names by adding extra functionalities to a string name.
  ///
  /// A name [type] must be indicated to categorize [this] name so it can be
  /// treated accordingly. [cap] determines how a [this] name should be
  /// capitalized.
  Name(String namon, this.type, [CapsRange? cap])
      : _cap = cap ?? CapsRange.initial {
    this.namon = namon;
    if (cap != null) caps(cap);
  }

  String get namon => _namon;
  set namon(String namon) {
    if (namon.isEmpty || namon.length < 2) {
      throw ArgumentError('non-empty string value');
    }
    _namon = namon;
    isEmpty = _namon.isEmpty;
    isNotEmpty = _namon.isNotEmpty;
    _initial = _namon[0];
    _body = _namon.substring(1);
  }

  CapsRange get capitalized => _cap;

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
  void caps([CapsRange? option]) {
    option ??= _cap;
    if (option == CapsRange.initial) {
      namon = '${_initial.toUpperCase()}$_body';
    } else if (option == CapsRange.all) {
      namon = '${_initial.toUpperCase()}${_body.toUpperCase()}';
    } else {
      namon = _namon.toLowerCase();
    }
  }

  /// De-capitalizes [this].
  void decaps([CapsRange? option]) {
    option ??= _cap;
    if (option == CapsRange.initial) {
      namon = '${_initial.toLowerCase()}$_body';
    } else if (option == CapsRange.all) {
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
  /// The additional name parts of [this] first name.
  List<String> _more = [];

  /// Creates an extended version of [Name] and flags it as a first name [type].
  ///
  /// Some may consider [more] additional name parts of a given name as their
  /// first names, but not as their middle names. Though, it may mean the same,
  /// [more] provides the freedom to do it as it pleases.
  FirstName(String namon, [List<String>? more])
      : _more = more ?? [],
        super(namon, Namon.firstName);

  List<String> get more => _more;

  @override
  String toString({bool includeAll = false}) =>
      includeAll && hasMore() ? '$namon ${_more.join(" ")}'.trim() : namon;

  /// Determines whether a [FirstName] has [more] name parts.
  bool hasMore() => _more.isNotEmpty;

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
  void caps([CapsRange? option]) {
    option ??= capitalized;
    if (option == CapsRange.initial) {
      namon = capitalize(namon);
      if (hasMore()) _more = _more.map(capitalize).toList();
    } else if (option == CapsRange.all) {
      namon = namon.toUpperCase();
      if (hasMore()) _more = _more.map((n) => n.toUpperCase()).toList();
    }
  }

  /// De-capitalizes [this].
  @override
  void decaps([CapsRange? option]) {
    option ??= capitalized;
    if (option == CapsRange.initial) {
      namon = decapitalize(namon);
      if (hasMore()) _more = _more.map(decapitalize).toList();
    } else if (option == CapsRange.all) {
      namon = namon.toLowerCase();
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
  String passwd({bool includeAll = false}) =>
      generatePassword(toString(includeAll: true));
}

/// Representation of a last name with some extra functionalities.
class LastName extends Name {
  String? _mother;
  LastNameFormat format;

  /// Creates an extended version of [Name] and flags it as a last name [type].
  ///
  /// Some people may keep their [mother]'s surname and want to keep a clear cut
  /// from their [father]'s surname. However, there are no clear rules about it.
  LastName(String father, [this._mother, this.format = LastNameFormat.father])
      : super(father, Namon.lastName);

  /// The surname inherited from a father side.
  String get father => namon;

  /// The surname inherited from a mother side.
  String? get mother => _mother;

  /// Returns a string representation of [this] last name.
  @override
  String toString({LastNameFormat? format}) {
    format = format ?? this.format;
    switch (format) {
      case LastNameFormat.father:
        return namon;
      case LastNameFormat.mother:
        return _mother ?? '';
      case LastNameFormat.hyphenated:
        return hasMother() ? '$namon-$_mother' : namon;
      case LastNameFormat.all:
        return hasMother() ? '$namon $_mother' : namon;
    }
  }

  /// Returns `true` if the [mother]'s surname is defined.
  bool hasMother() => _mother?.isNotEmpty == true;

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  @override
  Summary stats(
          {LastNameFormat? format, List<String> restrictions = const [' ']}) =>
      Summary(toString(format: format), restrictions: restrictions);

  /// Gets the initials of [this].
  @override
  List<String> initials({LastNameFormat? format}) {
    format ??= this.format;
    final initials = <String>[];
    switch (format) {
      case LastNameFormat.father:
        initials.add(namon[0]);
        break;
      case LastNameFormat.mother:
        if (hasMother()) initials.add(_mother![0]);
        break;
      case LastNameFormat.hyphenated:
      case LastNameFormat.all:
        initials.add(namon[0]);
        if (hasMother()) initials.add(_mother![0]);
        break;
      default:
        initials.add(namon[0]);
    }
    return initials;
  }

  /// Capitalizes [this].
  @override
  void caps([CapsRange? option]) {
    option ??= capitalized;
    if (option == CapsRange.initial) {
      namon = capitalize(namon);
      if (hasMother()) _mother = capitalize(_mother!);
    } else if (option == CapsRange.all) {
      namon = namon.toUpperCase();
      if (hasMother()) _mother = _mother!.toUpperCase();
    }
  }

  /// De-capitalizes [this].
  @override
  void decaps([CapsRange? option]) {
    option ??= capitalized;
    if (option == CapsRange.initial) {
      namon = decapitalize(namon);
      if (hasMother()) _mother = decapitalize(_mother!);
    } else if (option == CapsRange.all) {
      namon = namon.toLowerCase();
      if (hasMother()) _mother = _mother!.toLowerCase();
    }
  }

  /// Normalizes [this] as it should be.
  @override
  void normalize() {
    namon = capitalize(namon);
    if (hasMother()) _mother = capitalize(_mother!);
  }

  /// Creates a password-like representation of [this] last name.
  @override
  String passwd({LastNameFormat? format}) =>
      generatePassword(toString(format: format));
}

/// Summary of descriptive (categorical) statistics of name components.
class Summary with Summarizer {
  Summary(String namon, {List<String>? restrictions}) {
    super.compute(namon, restrictions: restrictions);
  }
}

/// A component that knows how to help a class extend some basic categorical
/// statistics on string values.
mixin Summarizer {
  Map<String, int> _distribution = {};
  int _count = 0;
  int _frequency = 0;
  String _top = '';
  int _unique = 0;
  late final String _string;
  late final List<String> _restrictions;

  /// The characters' distribution along with their frequencies.
  Map<String, int> get distribution => _distribution;

  /// The number of characters of the distribution, excluding the restricted
  /// ones.
  int get count => _count;

  /// The total number of characters of the content.
  int get length => _string.length;

  /// The count of the most repeated characters.
  int get frequency => _frequency;

  /// The most repeated character.
  String get top => _top;

  /// The count of unique characters
  int get unique => _unique;

  /// Creates a summary of a given string of alphabetical characters.
  Summarizer compute(String string, {List<String>? restrictions}) {
    _string = string;
    _restrictions = restrictions ?? const [' '];
    if (string.isEmpty || string.length < 2) {
      throw ArgumentError('non-empty string value');
    }
    _distribution = _groupByChar();
    _unique = _distribution.keys.length;
    _count = _distribution.values.reduce((acc, val) => acc + val);

    for (var entry in _distribution.entries) {
      if (entry.value >= _frequency) {
        _frequency = entry.value;
        _top = entry.key;
      }
    }
    return this;
  }

  /// Creates the distribution, taking the restricted characters into account.
  Map<String, int> _groupByChar() {
    final frequencies = <String, int>{};
    var restrictions = _restrictions.map((n) => n.toUpperCase());
    for (var char in _string.toUpperCase().split('')) {
      if (restrictions.contains(char)) continue;
      if (frequencies.containsKey(char)) {
        frequencies[char] = frequencies[char]! + 1;
      } else {
        frequencies[char] = 1;
      }
    }
    return frequencies;
  }
}
