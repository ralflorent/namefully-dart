import 'enums.dart';
import 'exceptions.dart';
import 'utils.dart';

/// Representation of a string type name with some extra capabilities.
///
/// It helps to define and understand the concept of namon/nama.
class Name {
  late String _namon;
  late String _initial;
  late String _body;

  final CapsRange _capsRange;
  final Namon type;

  /// Creates augmented names by adding extra functionality to a string name.
  ///
  /// A name [type] must be indicated to categorize the name so it can be
  /// treated accordingly. [capsRange] determines how the name should be
  /// capitalized.
  Name(String namon, this.type, [CapsRange? capsRange])
      : _capsRange = capsRange ?? CapsRange.initial {
    this.namon = namon;
    if (capsRange != null) caps(capsRange);
  }

  /// The piece of string treated as a name.
  String get namon => _namon;
  set namon(String namon) {
    if (namon.isInvalid) {
      throw InputException(source: namon, message: 'must be 2+ characters');
    }

    _namon = namon;
    _initial = _namon[0];
    _body = _namon.substring(1);
  }

  /// The length of the name.
  int get length => _namon.length;

  @override
  String toString() => _namon;

  /// Returns true if [other] is equal to this name.
  @override
  bool operator ==(other) {
    return other is Name && other.namon == namon && other.type == type;
  }

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  Summary stats() => Summary(_namon);

  /// Gets the initials (first character) of this name.
  List<String> initials() => List.unmodifiable([_initial]);

  /// Capitalizes the name.
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = '${_initial.toUpperCase()}$_body';
    } else if (range == CapsRange.all) {
      namon = '${_initial.toUpperCase()}${_body.toUpperCase()}';
    } else {
      namon = _namon.toLowerCase();
    }
  }

  /// De-capitalizes the name.
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = '${_initial.toLowerCase()}$_body';
    } else if (range == CapsRange.all) {
      namon = '${_initial.toLowerCase()}${_body.toLowerCase()}';
    } else {
      namon = _namon.toUpperCase();
    }
  }

  /// Normalizes the name as it should be.
  void normalize() => _namon = _initial.toUpperCase() + _body.toLowerCase();

  /// Creates a password-like representation of the name.
  String passwd() => generatePassword(namon);
}

/// Representation of a first name with some extra functionality.
class FirstName extends Name {
  List<String> _more = [];

  /// Creates an extended version of [Name] and flags it as a first name [type].
  ///
  /// Some may consider [more] additional name parts of a given name as their
  /// first names, but not as their middle names. Though, it may mean the same,
  /// [more] provides the freedom to do it as it pleases.
  FirstName(String namon, [List<String>? more])
      : _more = more ?? [],
        super(namon, Namon.firstName);

  /// The additional name parts of the first name.
  List<String> get more => _more;

  @override
  int get length => _namon.length + (_more.reduce((acc, n) => acc + n)).length;

  @override
  String toString({bool includeAll = false}) {
    return includeAll && hasMore() ? '$namon ${_more.join(" ")}'.trim() : namon;
  }

  /// Determines whether a first name has [more] name parts.
  bool hasMore() => _more.isNotEmpty;

  /// Returns a combined version of the [namon] and [more] if any.
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
  Summary stats({
    bool includeAll = false,
    List<String> restrictions = const [' '],
  }) {
    return Summary(
      toString(includeAll: includeAll),
      restrictions: restrictions,
    );
  }

  /// Gets the initials of the first name.
  @override
  List<String> initials({bool includeAll = false}) {
    return List.unmodifiable([
      _initial,
      if (includeAll && hasMore()) ..._more.map((n) => n[0]),
    ]);
  }

  /// Capitalizes the first name.
  @override
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = capitalize(namon);
      if (hasMore()) _more = _more.map(capitalize).toList();
    } else if (range == CapsRange.all) {
      namon = namon.toUpperCase();
      if (hasMore()) _more = _more.map((n) => n.toUpperCase()).toList();
    }
  }

  /// De-capitalizes the first name.
  @override
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = decapitalize(namon);
      if (hasMore()) _more = _more.map(decapitalize).toList();
    } else if (range == CapsRange.all) {
      namon = namon.toLowerCase();
      if (hasMore()) _more = _more.map((n) => n.toLowerCase()).toList();
    }
  }

  /// Normalizes the first name as it should be.
  @override
  void normalize() {
    namon = capitalize(namon);
    if (hasMore()) _more = _more.map(capitalize).toList();
  }

  /// Creates a password-like representation of the first name.
  @override
  String passwd({bool includeAll = false}) {
    return generatePassword(toString(includeAll: includeAll));
  }
}

/// Representation of a last name with some extra functionality.
class LastName extends Name {
  String? _mother;

  /// The internal last name format.
  final LastNameFormat format;

  /// Creates an extended version of [Name] and flags it as a last name [type].
  ///
  /// Some people may keep their [mother]'s surname and want to keep a clear cut
  /// from their [father]'s surname. However, there are no clear rules about it.
  LastName(String father, [this._mother, this.format = LastNameFormat.father])
      : super(father, Namon.lastName);

  @override
  int get length => _namon.length + (_mother?.length ?? 0);

  /// The surname inherited from a father side.
  String get father => _namon;

  /// The surname inherited from a mother side.
  String? get mother => _mother;

  /// Returns a string representation of the last name.
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
  bool hasMother() => _mother?.isNotEmpty ?? false;

  /// Gives some descriptive statistics.
  ///
  /// The statistical description summarizes the central tendency, dispersion
  /// and shape of the characters' distribution. See [Summary] for more details.
  @override
  Summary stats({
    LastNameFormat? format,
    List<String> restrictions = const [' '],
  }) {
    return Summary(toString(format: format), restrictions: restrictions);
  }

  /// Gets the initials of the last name.
  @override
  List<String> initials({LastNameFormat? format}) {
    format ??= this.format;
    var initials = <String>[];
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
    return List.unmodifiable(initials);
  }

  /// Capitalizes the last name.
  @override
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = capitalize(namon);
      if (hasMother()) _mother = capitalize(_mother!);
    } else if (range == CapsRange.all) {
      namon = namon.toUpperCase();
      if (hasMother()) _mother = _mother!.toUpperCase();
    }
  }

  /// De-capitalizes the last name.
  @override
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    if (range == CapsRange.initial) {
      namon = decapitalize(namon);
      if (hasMother()) _mother = decapitalize(_mother!);
    } else if (range == CapsRange.all) {
      namon = namon.toLowerCase();
      if (hasMother()) _mother = _mother!.toLowerCase();
    }
  }

  /// Normalizes the last name as it should be.
  @override
  void normalize() {
    namon = capitalize(namon);
    if (hasMother()) _mother = capitalize(_mother!);
  }

  /// Creates a password-like representation of the last name.
  @override
  String passwd({LastNameFormat? format}) {
    return generatePassword(toString(format: format));
  }
}

/// Summary of descriptive (categorical) statistics of name components.
class Summary with Summarizable {
  Summary(String namon, {List<String>? restrictions}) {
    summarize(namon, restrictions: restrictions);
  }
}

/// A component that knows how to help a class extend some basic categorical
/// statistics on string values.
mixin Summarizable {
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

  /// The count of unique characters.
  int get unique => _unique;

  /// Creates a summary of a given string of alphabetical characters.
  Summarizable summarize(String string, {List<String>? restrictions}) {
    _string = string;
    _restrictions = restrictions ?? const [' '];

    if (string.isInvalid) {
      throw InputException(source: string, message: 'must be 2+ characters');
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
