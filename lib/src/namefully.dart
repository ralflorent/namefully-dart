/// Welcome to namefully!
///
/// `namefully` is a Dart utility for handling person names.
///
/// Sources
/// - repo: https://github.com/ralflorent/namefully-dart
/// - pub:  https://pub.dev/packages/namefully
/// - license: MIT
import 'dart:async';

import 'config.dart';
import 'constants.dart';
import 'enums.dart';
import 'exceptions.dart';
import 'full_name.dart';
import 'names.dart';
import 'parsers.dart';
import 'utils.dart';

/// A helper for organizing person names in a particular order, way, or shape.
///
/// Though `namefully` is easy to use, it does not magically guess which part of
/// the name is what (prefix, suffix, first, last, or middle names). It relies
/// actually on how the name parts are indicated (i.e., their roles) so that
/// it can perform internally certain operations and saves us some extra
/// calculations/processing. In addition, [Namefully] can be created using
/// distinct raw data shapes. This is intended to give some flexibility to the
/// developer so that he or she is not bound to a particular data format.
/// By following closely the API reference to know how to harness its usability,
/// this utility aims to save time in formatting names.
///
/// [Namefully] also works like a trapdoor. Once a raw data is provided and
/// validated, a developer can only *access* in a vast amount of, yet effective
/// ways the name info. *No editing* is possible. If the name is mistaken, a new
/// instance of [Namefully] must be created. Remember, this utility's primary
/// objective is to help to **handle** a person name.
///
/// Note that the name standards used for the current version of this library
/// are as follows:
///      `(prefix) firstName (middleName) lastName (suffix)`
/// The opening `(` and closing `)` symbols mean that these parts are optional.
/// In other words, the most basic and typical case is a name that looks like
/// this: `John Smith`, where `John` is the first name and `Smith`, the last
/// name.
///
/// See https://departments.weber.edu/qsupport&training/Data_Standards/Name.htm
/// for more info on name standards.
///
/// **IMPORTANT**: Keep in mind that the order of appearance matters and can be
/// altered through configured parameters, which we will be seeing later on. By
/// default, the order of appearance is as shown above and will be used as a
/// basis for future examples and use cases.
///
/// Once imported, all that is required to do is to create an instance of
/// [Namefully] and the rest will follow.
///
/// Some terminologies used across the library are:
/// - namon: 1 piece of name (e.g., first name)
/// - nama: 2+ pieces of name (e.g., first name + last name)
///
/// Happy name handling!
class Namefully {
  /// A copy of high-quality name data.
  late final FullName _fullName;

  /// A copy of the default configuration (combined with a custom one if any).
  late final Config _config;

  /// The statistical information on the birth name.
  late final Summary _summary;

  /// Creates a name with distinguishable parts from a raw string content.
  ///
  /// An optional [Config]uration may be provided with specifics on how to treat
  /// a full name during its course. By default, all name parts are validated
  /// against some basic validation rules to avoid common runtime exceptions.
  Namefully(String names, {Config? config}) {
    _build(StringParser(names), config);
  }

  /// Creates a name from a list of distinguishable parts.
  Namefully.fromList(List<String> names, {Config? config}) {
    _build(ListStringParser(names), config);
  }

  /// Creates a name from a json-like distinguishable name parts.
  Namefully.fromJson(Map<String, String> names, {Config? config}) {
    _build(JsonNameParser(names), config);
  }

  /// Creates a name from a list of [Name]s.
  ///
  /// [Name] is provided by this utility, representing a namon with some extra
  /// capabilities, compared to a simple string name. This class helps to define
  /// the role of a name part (e.g, prefix) beforehand, which, as a consequence,
  /// gives more flexibility at the time of creating an instance of Namefully.
  Namefully.of(List<Name> names, {Config? config}) {
    _build(ListNameParser(names), config);
  }

  /// Creates a name from a [FullName].
  Namefully.from(FullName fullName, {Config? config}) {
    _config = Config.mergeWith(config);
    _fullName = fullName;
    _summary = Summary(birthName());
  }

  /// Creates a name from a customized [Parser].
  Namefully.fromParser(Parser<dynamic> parser, {Config? config}) {
    _build(parser, config);
  }

  /// The number of characters of the [birthName] without spaces.
  int get count => _summary.count;

  /// The number of characters of the [birthName], including spaces.
  int get length => _summary.length;

  /// The prefix part.
  String? get prefix => _fullName.prefix?.toString();

  /// The first name.
  String get first => firstName();

  /// The first middle name if any.
  String? get middle => middleName().firstOrNull;

  /// The last name.
  String get last => lastName();

  /// The suffix part.
  String? get suffix => _fullName.suffix?.toString();

  /// The birth name.
  String get birth => birthName();

  /// The shortest version of a person name.
  String get short => shorten();

  /// The longest version of a person name.
  String get long => birth;

  /// The entire name set.
  String get full => fullName();

  /// The first name combined with the last name's initial.
  String get public => format(r'f $l');

  /// Returns the full name as set.
  @override
  String toString() => fullName();

  /// Gets the full name ordered as configured.
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  ///
  /// [format] may also be used to alter manually the order of appearance of
  /// [fullName].
  ///
  /// For example:
  /// ```dart
  /// var name = Namefully('Jon Stark Snow');
  /// print(name.format('l f m')); // "Snow Jon Stark"
  /// ```
  String fullName([NameOrder? orderedBy]) {
    orderedBy ??= _config.orderedBy;
    final sep = _config.ending ? ',' : '';
    final nama = <String>[];
    if (_fullName.prefix != null) nama.add(_fullName.prefix.toString());
    if (orderedBy == NameOrder.firstName) {
      nama.add(firstName());
      nama.addAll(middleName());
      nama.add(lastName() + sep);
    } else {
      nama.add(lastName());
      nama.add(firstName());
      nama.add(middleName().join(' ') + sep);
    }
    if (_fullName.suffix != null) nama.add(_fullName.suffix.toString());
    return nama.join(' ').trim();
  }

  /// Gets a Map or json-like representation of the [fullName].
  Map<String, String?> toMap() => {
        'prefix': prefix,
        'firstName': first,
        'middleName': middleName().join(' '),
        'lastName': last,
        'suffix': suffix,
      };

  /// Gets a list representation of the [fullName].
  List<String?> toList() => [
        prefix,
        first,
        middleName().join(' '),
        last,
        suffix,
      ];

  /// Confirms that a name part has been set.
  bool has(Namon namon) => _fullName.has(namon);

  /// Gets the birth name ordered as configured, no [prefix] or [suffix].
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  String birthName([NameOrder? orderedBy]) {
    orderedBy ??= _config.orderedBy;
    return orderedBy == NameOrder.firstName
        ? <String>[firstName(), ...middleName(), lastName()].join(' ')
        : <String>[lastName(), firstName(), ...middleName()].join(' ');
  }

  /// Gets the [firstName] part of the [fullName].
  ///
  /// The [includeAll] param determines whether to include other pieces of the
  /// [FirstName].
  String firstName({bool includeAll = true}) {
    return _fullName.firstName.toString(includeAll: includeAll);
  }

  /// Gets the [lastName] part of the [fullName].
  ///
  /// The last name [format] overrides the how-to formatting of a surname
  /// output, considering its sub-parts.
  String lastName([LastNameFormat? format]) {
    return _fullName.lastName.toString(format: format);
  }

  /// Gets the [middleName] part of the [fullName].
  List<String> middleName() {
    return _fullName.middleName.map((n) => n.namon).toList();
  }

  /// Returns true if any [middleName]'s been set.
  bool hasMiddleName() => _fullName.has(Namon.middleName);

  /// Gets the initials of the [fullName].
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  ///
  /// [withMid] determines whether to include the initials of [middleName].
  ///
  /// For example, given the names:
  /// - `John Smith` => ['J', 'S']
  /// - `John Ben Smith` => ['J', 'S'].
  /// when [withMid] is set to true:
  /// - `John Ben Smith` => ['J', 'B', 'S'].
  ///
  /// **Note**:
  /// Ordered by last name obeys the following format:
  ///  `lastName firstName [middleName]`
  /// which means that if no middle name was set, setting [withMid] to true
  /// will output nothing and warn the end user about it.
  List<String> initials({NameOrder? orderedBy, bool withMid = false}) {
    orderedBy ??= _config.orderedBy;
    var midInits = _fullName.middleName.map((n) => n.initials()).toList();
    final initials = <String>[];

    if (withMid && !hasMiddleName()) {
      print('No initials for middleName since none was set.');
    }

    if (orderedBy == NameOrder.firstName) {
      initials.addAll(_fullName.firstName.initials());
      if (withMid) midInits.forEach(initials.addAll);
      initials.addAll(_fullName.lastName.initials());
    } else {
      initials.addAll(_fullName.lastName.initials());
      initials.addAll(_fullName.firstName.initials());
      if (withMid) midInits.forEach(initials.addAll);
    }
    return initials;
  }

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
  ///
  /// [what] indicates which variant to use when describing a name part.
  ///
  /// Treated as a categorical dataset, the summary contains the following info:
  /// - `count`: the number of *unrestricted* characters of the name;
  /// - `frequency`: the highest frequency within the characters;
  /// - `top`: the character with the highest frequency;
  /// - `unique`: the count of unique characters of the name;
  /// - `distribution`: the characters' distribution.
  ///
  /// Given the name `Thomas Alva Edison`, the summary will output as follows:
  ///
  /// Descriptive statistics for "Thomas Alva Edison"
  ///  - count    : 16
  ///  - frequency: 3
  ///  - top      : A
  ///  - unique   : 12
  ///  - distribution: { T: 1, H: 1, O: 2, M: 1, A: 2, S: 2, ' ': 2, L: 1, V: 1,
  ///  E: 1, D: 1, I: 1, N: 1 }
  ///
  /// **Note:**
  /// During the setup, a set of restricted characters can be defined to be
  /// removed from the stats. By default, the only restricted character is the
  /// `space`. That is why the [count] for the example below results in `16`
  /// instead of `18`.
  ///
  /// Another thing to consider is that the summary is case *insensitive*. Note
  /// that the letter `a` has the top frequency, be it `3`.
  Summary? stats({NameType? what, List<String> restrictions = const [' ']}) {
    switch (what) {
      case NameType.firstName:
        return _fullName.firstName
            .stats(includeAll: true, restrictions: restrictions);
      case NameType.middleName:
        if (!hasMiddleName()) {
          print('No Summary for middleName since none was set.');
          return null;
        }
        return Summary(middleName().join(' '));
      case NameType.lastName:
        return _fullName.lastName
            .stats(format: _config.lastNameFormat, restrictions: restrictions);
      case NameType.birthName:
        return _summary;
      default:
        return Summary(fullName());
    }
  }

  /// Shortens a complex full name to a simple typical name, a combination of
  /// [firstName] and [lastName].
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  ///
  /// For a given name such as `Mr Keanu Charles Reeves`, shortening this name
  /// is equivalent to making it `Keanu Reeves`.
  ///
  /// As a shortened name, the namon of the first name is favored over the other
  /// names forming part of the entire first names, if any. Meanwhile, for
  /// the last name, the configured `lastNameFormat` is prioritized.
  ///
  /// For a given `FirstName FatherName MotherName`, shortening this name when
  /// the lastNameFormat is set as `mother` is equivalent to making it:
  /// `FirstName MotherName`.
  String shorten({NameOrder? orderedBy}) {
    orderedBy ??= _config.orderedBy;
    return orderedBy == NameOrder.firstName
        ? [_fullName.firstName.namon, _fullName.lastName.toString()].join(' ')
        : [_fullName.lastName.toString(), _fullName.firstName.namon].join(' ');
  }

  /// Flattens a long name using the name types as variants.
  ///
  /// While [limit] sets a threshold as a limited number of characters
  /// supported to flatten a [FullName], [FlattenedBy] indicates which variant
  /// to use when doing so. By default, a full name gets flattened by
  /// [FlattenedBy.middleName].
  ///
  /// if the set limit is violated, a [warning] is given to the user about it.
  ///
  /// The flattening operation is only executed iff there is a valid entry and
  /// it surpasses the limit set. In the examples below, let us assume that the
  /// name goes beyond the limit value.
  ///
  /// Flattening a long name refers to reducing the name to the following forms.
  /// For example, `John Winston Ono Lennon` flattened by:
  /// * [FlattenedBy.firstName]: => 'J. Winston Ono Lennon'
  /// * [FlattenedBy.middleName]: => 'John W. O. Lennon'
  /// * [FlattenedBy.lastName]: => 'John Winston Ono L.'
  /// * [FlattenedBy.firstMid]: => 'J. W. O. Lennon'
  /// * [FlattenedBy.midLast]: => 'John W. O. L.'
  /// * [FlattenedBy.all]: => 'J. W. O. L.'
  ///
  /// A shorter version of this method is [zip()].
  String flatten({
    int limit = 20,
    FlattenedBy by = FlattenedBy.middleName,
    bool withPeriod = true,
    bool warning = true,
  }) {
    if (count <= limit) return fullName();

    var sep = withPeriod ? '.' : '',
        fn = _fullName.firstName,
        mn = middleName().join(' '),
        ln = _fullName.lastName,
        hasMid = hasMiddleName(),
        firsts = fn.initials().join('$sep ') + sep,
        lasts = ln.initials().join('$sep ') + sep,
        mids = hasMiddleName()
            ? _fullName.middleName.map((n) => n.initials()[0]).join('$sep ') +
                sep
            : '',
        name = <String>[];

    if (_config.orderedBy == NameOrder.firstName) {
      switch (by) {
        case FlattenedBy.firstName:
          name = hasMid ? [firsts, mn, ln.toString()] : [firsts, ln.toString()];
          break;
        case FlattenedBy.lastName:
          name = hasMid ? [fn.toString(), mn, lasts] : [fn.toString(), lasts];
          break;
        case FlattenedBy.middleName:
          name = hasMid
              ? [fn.toString(), mids, ln.toString()]
              : [fn.toString(), ln.toString()];
          break;
        case FlattenedBy.firstMid:
          name = hasMid
              ? [
                  firsts,
                  mids,
                  ln.toString(),
                ]
              : [firsts, ln.toString()];
          break;
        case FlattenedBy.midLast:
          name = hasMid ? [fn.toString(), mids, lasts] : [fn.toString(), lasts];
          break;
        case FlattenedBy.all:
          name = hasMid ? [firsts, mids, lasts] : [firsts, lasts];
          break;
      }
    } else {
      switch (by) {
        case FlattenedBy.firstName:
          name = hasMid ? [ln.toString(), firsts, mn] : [ln.toString(), firsts];
          break;
        case FlattenedBy.lastName:
          name = hasMid ? [lasts, fn.toString(), mn] : [lasts, fn.toString()];
          break;
        case FlattenedBy.middleName:
          name = hasMid
              ? [ln.toString(), fn.toString(), mids]
              : [ln.toString(), fn.toString()];
          break;
        case FlattenedBy.firstMid:
          name = hasMid
              ? [
                  ln.toString(),
                  firsts,
                  mids,
                ]
              : [ln.toString(), firsts];
          break;
        case FlattenedBy.midLast:
          name = hasMid ? [lasts, fn.toString(), mids] : [lasts, fn.toString()];
          break;
        case FlattenedBy.all:
          name = hasMid ? [firsts, mids, lasts] : [firsts, lasts];
          break;
      }
    }

    final flat = by == FlattenedBy.all ? name.join() : name.join(' ');
    if (warning && flat.length > limit) {
      print('The flattened name <$flat> still surpasses the set limit $limit');
    }
    return flat;
  }

  /// Zips or compacts a name using different forms of variants.
  ///
  /// See [flatten()] for more details.
  String zip({FlattenedBy by = FlattenedBy.midLast, bool withPeriod = true}) {
    return flatten(limit: 0, by: by, warning: false, withPeriod: withPeriod);
  }

  /// Formats the [fullName] as desired.
  ///
  /// [how] to format it?
  /// string format
  /// -------------
  /// * 'short': typical first + last name
  /// * 'long': birth name (without prefix and suffix)
  ///
  /// char format
  /// -----------
  /// * 'b': birth name
  /// * 'B': capitalized birth name
  /// * 'f': first name
  /// * 'F': capitalized first name
  /// * 'l': last name (official)
  /// * 'L': capitalized last name
  /// * 'm': middle names
  /// * 'M': capitalized middle names
  /// * 'o': official document format
  /// * 'O': official document format in capital letters
  /// * 'p': prefix
  /// * 'P': capitalized prefix
  /// * 's': suffix
  /// * 'S': capitalized suffix
  ///
  /// punctuations
  /// ------------
  /// * '.': period
  /// * ',': comma
  /// * ' ': space
  /// * '-': hyphen
  /// * '_': underscore
  /// * '$': an escape character to select only the initial of the next char.
  ///
  /// Given the name `Joe Jim Smith`, call [format] with the [how] string.
  /// - format('l f') => 'Smith Joe'
  /// - format('L, f') => 'SMITH, Joe'
  /// - format('short') => 'Joe Smith'
  /// - format() => 'SMITH, Joe Jim'
  /// - format(r'f $l.') => 'Joe S.'.
  ///
  /// Do note that the escape character is only valid for the birth name parts:
  /// first, middle, and last names.
  String format([String how = 'official']) {
    if (how == 'short') return shorten();
    if (how == 'long') return birthName();
    if (how == 'official') how = 'o';

    var set = ''; // set of chars.
    final formatted = <String>[];
    for (var c in how.split('')) {
      if (!kAllowedTokens.contains(c)) {
        throw NotAllowedException(
          source: full,
          message: '<$c> is an invalid character for the formatting.',
        );
      }
      set += c;
      if (c == r'$') continue;
      formatted.add(_map(set) ?? '');
      set = '';
    }
    return formatted.join().trim();
  }

  /// Transforms a [birthName] to UPPERCASE.
  String upper() => birthName().toUpperCase();

  /// Transforms a [birthName] to lowercase.
  String lower() => birthName().toLowerCase();

  /// Transforms a [birthName] to camelCase.
  String camel() => decapitalize(pascal());

  /// Transforms a [birthName] to PascalCase.
  String pascal() => split().map((n) => capitalize(n)).join();

  /// Transforms a [birthName] to snake_case.
  String snake() => split().map((n) => n.toLowerCase()).join('_');

  /// Transforms a [birthName] to hyphen-case (or kebab-case).
  String hyphen() => split().map((n) => n.toLowerCase()).join('-');

  /// Transforms a [birthName] to dot.case.
  String dot() => split().map((n) => n.toLowerCase()).join('.');

  /// Transforms a [birthName] to ToGgLe CaSe.
  String toggle() => toggleCase(birthName());

  /// Transforms a [birthName] to a specific title [capitalization].
  String to(Capitalization capitalization) {
    switch (capitalization) {
      case Capitalization.camel:
        return camel();
      case Capitalization.dot:
        return dot();
      case Capitalization.hyphen:
      case Capitalization.kebab:
        return hyphen();
      case Capitalization.lower:
        return lower();
      case Capitalization.pascal:
        return pascal();
      case Capitalization.snake:
        return snake();
      case Capitalization.toggle:
        return toggle();
      case Capitalization.upper:
        return upper();
    }
  }

  /// Splits a [birthName] using a [separator].
  List<String> split([RegExp? separator]) {
    separator ??= RegExp("[' -.]");
    return birthName().replaceAll(separator, ' ').split(' ');
  }

  /// Joins the name parts of a [birthName] using a [separator].
  String join([String separator = '']) => split().join(separator);

  /// Returns a password-like representation of a name.
  String? passwd([NameType? what]) {
    switch (what) {
      case NameType.firstName:
        return _fullName.firstName.passwd();
      case NameType.middleName:
        if (!hasMiddleName()) {
          print('No password for middleName since none was set.');
          return null;
        }
        return _fullName.middleName.map((n) => n.passwd()).join();
      case NameType.lastName:
        return _fullName.lastName.passwd();
      default:
        return generatePassword(birthName());
    }
  }

  /// Flips definitely the name order from the preset/current config.
  void flip() {
    if (_config.orderedBy == NameOrder.firstName) {
      _config.orderedBy = NameOrder.lastName;
      print('The name order is now changed to: lastName');
    } else {
      _config.orderedBy = NameOrder.firstName;
      print('The name order is now changed to: firstName');
    }
  }

  /// Builds the core elements for name data.
  void _build<T>(Parser<T> parser, [Config? options]) {
    _config = Config.mergeWith(options);
    _fullName = parser.parse(options: _config);
    _summary = Summary(birthName());
  }

  /// Maps each [char]acter to a specific name piece.
  String? _map(String char) {
    switch (char) {
      case '.':
      case ',':
      case ' ':
      case '-':
      case '_':
        return char;
      case 'b':
        return birthName();
      case 'B':
        return birthName().toUpperCase();
      case 'f':
        return _fullName.firstName.toString();
      case 'F':
        return _fullName.firstName.toString().toUpperCase();
      case 'l':
        return _fullName.lastName.toString();
      case 'L':
        return _fullName.lastName.toString().toUpperCase();
      case 'm':
      case 'M':
        if (!hasMiddleName()) {
          print('No formatting for middle names since none was set.');
          return null;
        }
        return char == 'm'
            ? _fullName.middleName.map((n) => n.namon).join(' ')
            : _fullName.middleName.map((n) => n.namon.toUpperCase()).join(' ');
      case 'o':
      case 'O':
        final sxSep = _config.ending ? ',' : '';
        final nama = <String>[];

        if (_fullName.prefix != null) {
          nama.add(_fullName.prefix.toString());
        }
        nama.add('${_fullName.lastName.toString()},'.toUpperCase());
        if (hasMiddleName()) {
          nama.add(_fullName.firstName.toString());
          nama.add(_fullName.middleName.map((n) => n.namon).join(' ') + sxSep);
        } else {
          nama.add(_fullName.firstName.toString() + sxSep);
        }
        if (_fullName.suffix != null) nama.add(_fullName.suffix.toString());

        var official = nama.join(' ').trim();
        return char == 'o' ? official : official.toUpperCase();
      case 'p':
        return _fullName.prefix?.toString();
      case 'P':
        return _fullName.prefix?.toString().toUpperCase();
      case 's':
        return _fullName.suffix?.toString();
      case 'S':
        return _fullName.suffix?.toString().toUpperCase();
      case r'$f':
      case r'$F':
        return _fullName.firstName.initials().first;
      case r'$l':
      case r'$L':
        return _fullName.lastName.initials().first;
      case r'$m':
      case r'$M':
        return _fullName.middleName.map((n) => n.initials().first).first;
      default:
        return null;
    }
  }
}

/// An on-the-fly name builder.
///
/// This builder knows how to take a [name] from distinct raw forms and build it
/// through a state management mechanism. That is, as the name changes, its
/// states are persisted and notified to any subscriber listening to those
/// changes, thanks to a stream controller that broadcasts them.
///
/// The builder starts by creating an initial state of the created name. If a
/// change event occurs to this name, this change is hence viewed as the current
/// name state to consider, and the previous one becomes history. As this works
/// like a state store, this gives a rollback flexibility in case an undesirable
/// change is made.
///
/// Once the builder finishes building up the name, the changes are committed
/// and the store is freed as well as the stream controller for performance
/// purposes. That means, the builder may no longer change the final name state
/// and should live up to that last change.
///
/// In the following example, a listener prints out the different states of the
/// name: `Jane Ann Doe`.
///
/// ```dart
/// var builder = NameBuilder('Jane Ann Doe', config: Config('NameBuilder'))
///   ..stream.listen((d) => print('stream name: $d'))
///   ..shorten()     // stream name: 'Jane Doe'
///   ..upper()       // stream name: 'JANE DOE'
///   ..byLastName()  // stream name: 'DOE JANE'
///   ..lower();      // stream name: 'doe jane'
/// print(builder.build()); // 'doe jane'
/// ```
///
/// NOTE: Most of the operations supported in the name builder can be performed
/// with [Namefully.format]. This builder is an expensive operation and should
/// be used in specific use cases, or when judged extremely necessary. Otherwise,
/// keep it sane and simple using the traditional `Namefully`.
class NameBuilder {
  /// The context in which the name is being built up.
  Namefully _context;

  /// Whether this builder can continue building additional name states.
  bool _canBuild = true;

  /// The state of the changing name.
  final _NamefullyState _state;

  /// The controller providing the on-the-fly updates of the changing name.
  final _streamer = StreamController<Namefully>();

  /// The name changes made available for listeners.
  Stream<Namefully> get stream => _streamer.stream.asBroadcastStream();

  /// The name for the current context.
  Namefully get name => _context;

  /// The name for the current context as a string.
  String get asString => _context.toString();

  /// Whether the builder can perform more nesting operations.
  bool get isClosed => !_canBuild;

  /// Creates the initial state of the given [name] under a specific [stateName]
  /// if provided.
  NameBuilder._(Namefully name, [String? stateName])
      : _context = name,
        _state = _NamefullyState(name, id: stateName) {
    _streamer.sink.add(_context);
  }

  /// Creates a name with distinguishable parts from a raw string content.
  ///
  /// An optional [Config]uration may be provided with specifics on how to treat
  /// a full name during its course. By default, all name parts are validated
  /// against some basic validation rules to avoid common runtime exceptions.
  factory NameBuilder(String names, {Config? config}) =>
      NameBuilder._(Namefully(
        names,
        config: config,
      ));

  /// Creates a name on the fly.
  factory NameBuilder.only({
    required String firstName,
    List<String>? middleName,
    required String lastName,
    Config? config,
  }) =>
      NameBuilder._(Namefully.from(
        FullName.raw(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          config: config,
        ),
        config: config,
      ));

  /// Creates a name from a list of distinguishable parts.
  factory NameBuilder.fromList(List<String> names, {Config? config}) =>
      NameBuilder._(Namefully.fromList(
        names,
        config: config,
      ));

  /// Creates a name from a list of [Name]s.
  ///
  /// [Name] is provided by this utility, representing a namon with some extra
  /// capabilities, compared to a simple string name. This class helps to define
  /// the role of a name part (e.g, prefix) beforehand, which, as a consequence,
  /// gives more flexibility at the time of creating an instance of Namefully.
  factory NameBuilder.of(List<Name> names, {Config? config}) =>
      NameBuilder._(Namefully.of(
        names,
        config: config,
      ));

  /// Creates a name from a [FullName].
  factory NameBuilder.from(FullName names, {Config? config}) =>
      NameBuilder._(Namefully.from(
        names,
        config: config,
      ));

  /// Creates a name from a json-like distinguishable name parts.
  factory NameBuilder.fromJson(Map<String, String> names, {Config? config}) =>
      NameBuilder._(Namefully.fromJson(
        names,
        config: config,
      ));

  /// Creates a name from a customized [Parser].
  factory NameBuilder.fromParser(Parser names, {Config? config}) =>
      NameBuilder._(Namefully.fromParser(
        names,
        config: config,
      ));

  @override
  String toString() {
    return "NameBuilder's current context[" +
        (isClosed ? 'closed' : 'open') +
        ']: $asString';
  }

  /// Arranges the name by [NameOrder.firstName].
  void byFirstName() => _order(NameOrder.firstName);

  /// Arranges the name by [NameOrder.lastName].
  void byLastName() => _order(NameOrder.lastName);

  /// Shortens a full name to a typical name, a combination of [firstName] and
  /// [lastName].
  ///
  /// See [Namefully.shorten] for more info.
  void shorten() {
    if (!_canBuild) throw _builderException(asString);
    _context = Namefully(_state.last.shorten(), config: _state.last._config);
    _state.add(_context, id: 'shorten');
    _streamer.sink.add(_context);
  }

  /// Transforms a [birthName] to UPPERCASE.
  void upper() {
    if (!_canBuild) throw _builderException(asString);
    _context = Namefully(_state.last.upper(), config: _state.last._config);
    _state.add(_context, id: 'upper');
    _streamer.sink.add(_context);
  }

  /// Transforms a [birthName] to lowercase.
  void lower() {
    if (!_canBuild) throw _builderException(asString);
    _context = Namefully(_state.last.lower(), config: _state.last._config);
    _state.add(_context, id: 'lower');
    _streamer.sink.add(_context);
  }

  /// Returns the final state of the changing name.
  Namefully build() {
    if (!_canBuild) throw _builderException(asString);
    close();
    return _context;
  }

  /// Closes this builder on demand.
  void close() {
    _canBuild = false;
    _streamer.close();
    _state.dispose();
  }

  /// Rolls back to the previous context.
  void rollback() {
    if (!_canBuild) throw _builderException(asString);
    _context = _state.rollback();
    _streamer.sink.add(_context);
  }

  /// Arranges the name [by] the specified order: [NameOrder.firstName] or
  /// [NameOrder.lastName].
  void _order(NameOrder by) {
    if (!_canBuild) throw _builderException(asString);
    _context = Namefully(
      _state.last.fullName(by),
      config: _state.last._config.copyWith(orderedBy: by),
    );
    _state.add(_context, id: 'order');
    _streamer.sink.add(_context);
  }
}

NameException _builderException(String source) {
  return NotAllowedException(
    source: source,
    message: 'builder has been closed',
  );
}

/// An in-memory name state management.
///
/// The [current] and [previous] states of a name built on the fly are saved in
/// memory, and can be easily access through historical data as long as the
/// object persists in memory. An [id] is automatically generated, if none has
/// been provided during its creation.
class _NamefullyState extends _State<Namefully> {
  /// The previous name state.
  @override
  final Namefully? previous;

  /// The current name state.
  @override
  final Namefully current;

  /// A generated state id, if not provided.
  final String id;

  /// The historical name states.
  static final Set<_NamefullyState> _history = {};

  /// The very first name state.
  Namefully get last => _history.last.current;

  /// The very last name state.
  Namefully get first => _history.first.current;

  /// Convenient generative constructor.
  _NamefullyState._(this.id, this.current, this.previous);

  /// Creates an in-memory name state management.
  factory _NamefullyState(Namefully initialState, {String? id}) {
    _history.add(_NamefullyState._(
      id ?? 'state_${_history.length}',
      initialState,
      null,
    ));
    return _history.last;
  }

  /// Adds a new name state.
  @override
  void add(Namefully current, {String? id}) {
    _history.add(_NamefullyState._(
      id ?? 'state_${_history.length}',
      current,
      _history.last.current,
    ));
  }

  /// Performs rollback on existing values only until the very first one.
  @override
  Namefully rollback() {
    if (_history.length > 1) {
      _history.remove(_history.last);
      return last;
    }
    return first;
  }

  /// Clears the memory.
  @override
  void dispose() => _history.clear();
}

/// A lightweight state management approach.
abstract class _State<T> {
  late final T? previous;

  late final T current;

  void add(T state);

  T rollback();

  void dispose();
}
