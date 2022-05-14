import 'types.dart';
import 'exception.dart';
import 'utils.dart';

/// Representation of a string type name with some extra capabilities.
///
/// It helps to define and understand the concept of namon/nama.
class Name {
  late String _namon;
  late String _initial;

  final CapsRange _capsRange;
  final Namon type;

  /// Creates augmented names by adding extra functionality to a string name.
  ///
  /// A name [type] must be indicated to categorize the name so it can be
  /// treated accordingly. [capsRange] determines how the name should be
  /// capitalized.
  Name(String value, this.type, [CapsRange? capsRange])
      : _capsRange = capsRange ?? CapsRange.initial {
    this.value = value;
    if (capsRange != null) caps(capsRange);
  }

  /// Creates a prefix.
  Name.prefix(String value) : this(value, Namon.prefix);

  /// Creates a first name.
  Name.first(String value) : this(value, Namon.firstName);

  /// Creates a middle name.
  Name.middle(String value) : this(value, Namon.middleName);

  /// Creates a last name.
  Name.last(String value) : this(value, Namon.lastName);

  /// Creates a suffix.
  Name.suffix(String value) : this(value, Namon.suffix);

  /// The piece of string treated as a name.
  String get value => _namon;
  set value(String newValue) {
    if (newValue.isInvalid) {
      throw InputException(source: newValue, message: 'must be 2+ characters');
    }

    _namon = newValue;
    _initial = newValue[0];
  }

  /// The length of the name.
  int get length => _namon.length;

  @override
  String toString() => _namon;

  /// Returns true if [other] is equal to this name.
  @override
  bool operator ==(other) {
    return other is Name && other.value == value && other.type == type;
  }

  @override
  int get hashCode => hashValues(value, type);

  /// Gets the initials (first character) of this name.
  List<String> initials() => List.unmodifiable([_initial]);

  /// Capitalizes the name.
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    value = capitalize(_namon, range);
  }

  /// De-capitalizes the name.
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    value = decapitalize(_namon, range);
  }

  /// Normalizes the name as it should be.
  void normalize() => caps(CapsRange.initial);
}

/// Representation of a first name with some extra functionality.
class FirstName extends Name {
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
  late List<String> _more;

  /// Determines whether a first name has [more] name parts.
  bool get hasMore => _more.isNotEmpty;

  @override
  int get length {
    return super.length +
        (hasMore ? (_more.reduce((acc, n) => acc + n)).length : 0);
  }

  @override
  String toString({bool includeAll = false}) {
    return includeAll && hasMore ? '$value ${_more.join(" ")}'.trim() : value;
  }

  /// Returns a combined version of the [value] and [more] if any.
  List<Name> asNames() {
    return [
      Name(value, Namon.firstName),
      if (hasMore) ..._more.map((n) => Name(n, Namon.firstName))
    ];
  }

  /// Gets the initials of the first name.
  @override
  List<String> initials({bool includeAll = false}) {
    return List.unmodifiable([
      _initial,
      if (includeAll && hasMore) ..._more.map((n) => n[0]),
    ]);
  }

  /// Capitalizes the first name.
  @override
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    value = capitalize(value, range);
    if (hasMore) _more = _more.map((n) => capitalize(n, range!)).toList();
  }

  /// De-capitalizes the first name.
  @override
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    value = decapitalize(value, range);
    if (hasMore) _more = _more.map((n) => decapitalize(n, range!)).toList();
  }
}

/// Representation of a last name with some extra functionality.
class LastName extends Name {
  /// Creates an extended version of [Name] and flags it as a last name [type].
  ///
  /// Some people may keep their [mother]'s surname and want to keep a clear cut
  /// from their [father]'s surname. However, there are no clear rules about it.
  LastName(String father, [this._mother, this.format = Surname.father])
      : super(father, Namon.lastName);

  /// The internal last name format.
  final Surname format;

  @override
  int get length => _namon.length + (_mother?.length ?? 0);

  /// The surname inherited from a father side.
  String get father => _namon;

  /// The surname inherited from a mother side.
  String? get mother => _mother;
  String? _mother;

  /// Returns `true` if the [mother]'s surname is defined.
  bool get hasMother => _mother?.isNotEmpty ?? false;

  /// Returns a string representation of the last name.
  @override
  String toString({Surname? format}) {
    format = format ?? this.format;
    switch (format) {
      case Surname.father:
        return value;
      case Surname.mother:
        return _mother ?? '';
      case Surname.hyphenated:
        return hasMother ? '$value-$_mother' : value;
      case Surname.all:
        return hasMother ? '$value $_mother' : value;
    }
  }

  /// Gets the initials of the last name.
  @override
  List<String> initials({Surname? format}) {
    format ??= this.format;
    var initials = <String>[];
    switch (format) {
      case Surname.father:
        initials.add(_initial);
        break;
      case Surname.mother:
        if (hasMother) initials.add(_mother![0]);
        break;
      case Surname.hyphenated:
      case Surname.all:
        initials.add(_initial);
        if (hasMother) initials.add(_mother![0]);
        break;
    }
    return List.unmodifiable(initials);
  }

  /// Capitalizes the last name.
  @override
  void caps([CapsRange? range]) {
    range ??= _capsRange;
    value = capitalize(value, range);
    if (hasMother) _mother = capitalize(_mother!, range);
  }

  /// De-capitalizes the last name.
  @override
  void decaps([CapsRange? range]) {
    range ??= _capsRange;
    value = decapitalize(value, range);
    if (hasMother) _mother = decapitalize(_mother!, range);
  }
}
