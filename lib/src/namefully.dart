/// Welcome to namefully!
///
/// `namefully` is a Dart utility for handing person names.
///
/// Sources
/// - repo: https://github.com/ralflorent/namefully-dart
/// - docs: https://namefully.dev
/// - pub:  https://pub.dev/packages/namefully
///
/// @license MIT

import 'config.dart';
import 'constants.dart';
import 'models/enums.dart';
import 'models/full_name.dart';
import 'models/name.dart';
import 'models/summary.dart';
import 'parsers/json_name_parser.dart';
import 'parsers/list_name_parser.dart';
import 'parsers/list_string_parser.dart';
import 'parsers/string_parser.dart';
import 'parsers/parser.dart';
import 'util.dart';
import 'validators/full_name_validator.dart';

/// [Namefully] is a utility for handling person names.
///
/// It does not magically guess which part of the name is what. It relies
/// actually on how the developer indicates the roles of the name parts so that
/// it, internally, can perform certain operations and saves the developer some
/// calculations/processings. Nevertheless, Namefully can be constructed using
/// distinct raw data shapes. This is intended to give some flexibility to the
/// developer so that he or she is not bound to a particular data format.
/// Please do follow closely the APIs to know how to properly use it in order to
/// avoid some errors (mainly validation's).
///
/// [Namefully] also works like a trapdoor. Once a raw data is provided and
/// validated, a developer can only ACCESS in a vast amount of, yet effective
/// ways the name info. NO EDITING is possible. If the name is mistaken, a new
/// instance of [Namefully] must be created. Remember, this utility's primary
/// objective is to help to **handle** a person name.
///
/// Note that the name standards used for the current version of this library
/// are as follows:
///      [Prefix] Firstname [Middlename] Lastname [Suffix]
/// The opening `[` and closing `]` brackets mean that these parts are optional.
/// In other words, the most basic and typical case is a name that looks like
/// this: `John Smith`, where `John` is the first name and `Smith`, the last
/// name.
///
/// @see https://departments.weber.edu/qsupport&training/Data_Standards/Name.htm
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
/// - namon: 1 piece of a name (e.g., firstname)
/// - nama: 2+ pieces of a name (e.g., firstname + lastname)
///
/// Happy name handling!
class Namefully {
  /// A copy of high-quality name data.
  FullName _fullName;

  /// Statistical info on the birth name.
  Summary _summary;

  /// A copy of the default configuration combined with a customized one.
  Config _config;

  Namefully(String names, {Config config}) {
    _build(StringParser(names), config);
  }
  Namefully.fromList(List<String> names, {Config config}) {
    _build(ListStringParser(names), config);
  }
  Namefully.fromJson(Map<String, String> names, {Config config}) {
    _build(JsonNameParser(names), config);
  }
  Namefully.of(List<Name> names, {Config config}) {
    _build(ListNameParser(names), config);
  }
  Namefully.from(FullName fullName, {Config config}) {
    _config = Config.mergeWith(config);
    FullNameValidator().validate(fullName);
    _fullName = fullName;
    _summary = Summary(birthName());
  }
  Namefully.fromParser(Config config) {
    if (config?.parser == null) throw ArgumentError.notNull('Config.parser');
    if (!(config?.parser is Parser)) {
      throw ArgumentError('Config.parser is not a Parser<T>');
    }
    _build(config.parser, config);
  }

  /// The [count] of characters of the [birthName] without spaces.
  int get count => _summary.count;

  /// The number of characters of the [birthName], including spaces.
  int get length => _summary.length;

  /// Gets the [fullName] ordered as configured.
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  ///
  /// [format] may also be used to alter manually the order of appearance of
  /// [fullName].
  ///
  /// For example:
  /// ```dart
  /// var name = Namefully('Jon Novak Snow');
  /// print(name.format('l f m')); // "Snow Jon Novak"
  /// ```
  String fullName([NameOrder orderedBy]) {
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
    return nama.join(' ');
  }

  /// Gets the [birthName] ordered as configured, no [prefix] or [suffix].
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  String birthName([NameOrder orderedBy]) {
    orderedBy ??= _config.orderedBy;
    return orderedBy == NameOrder.firstName
        ? (<String>[]
              ..add(firstName())
              ..addAll(middleName())
              ..add(lastName()))
            .join(' ')
        : (<String>[]
              ..add(lastName())
              ..add(firstName())
              ..addAll(middleName()))
            .join(' ');
  }

  /// Gets the [firstName] part of the [fullName].
  ///
  /// The [includeAll] param determines whether to include other pieces of the
  /// [FirstName].
  String firstName({bool includeAll = true}) =>
      _fullName.firstName.toString(includeAll: includeAll);

  /// Gets the [lastName] part of the [fullName].
  ///
  /// the last name [format] overrides the how-to formatting of a surname
  /// output, considering its subparts.
  String lastName([LastNameFormat format]) =>
      _fullName.lastName.toString(format: format);

  /// Gets the [middleName] part of the [fullName].
  List<String> middleName() =>
      _fullName.middleName.map((n) => n.namon).toList();

  /// Returns true if any [middleName]'s set.
  bool hasMiddleName() => has(Namon.middleName);

  /// Gets the [prefix] part of the [fullName].
  String prefix() => _fullName.prefix?.toString();

  /// Gets the [suffix] part of the [fullName].
  String suffix() => _fullName.suffix?.toString();

  /// Gets the [initials] of the [fullName].
  ///
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  /// [withMid] determines whether to include the initials of [middleName]
  ///
  /// @example
  /// Given the names:
  /// - `John Smith` => ['J', 'S']
  /// - `John Ben Smith` => ['J', 'S']
  /// when [withMid] is set to true:
  /// - `John Ben Smith` => ['J', 'B', 'S']
  ///
  /// **NOTE**:
  /// Ordered by last name obeys the following format:
  ///  `lastName firstName [middleName]`
  /// which means that if no middle name was set, setting [withMid] to true
  /// will output nothing and warn the end user about it.
  List<String> initials({NameOrder orderedBy, bool withMid = false}) {
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
  /// [what] indicates which variant to use when describing a name part
  ///
  /// Treated as a categorical dataset, the summary contains the following info:
  /// [count]: the number of *unrestricted* characters of the name;
  /// [frequency]: the highest frequency within the characters;
  /// [top]: the character with the highest frequency;
  /// [unique]: the count of unique characters of the name;
  /// [distribution]: the characters' distribution.
  ///
  /// @example
  /// Given the name "Thomas Alva Edison", the summary will output as follows:
  ///
  /// Descriptive statistics for "Thomas Alva Edison"
  ///  count    : 16
  ///  frequency: 3
  ///  top      : A
  ///  unique   : 12
  ///  distribution: { T: 1, H: 1, O: 2, M: 1, A: 2, S: 2, ' ': 2, L: 1, V: 1,
  ///  E: 1, D: 1, I: 1, N: 1 }
  ///
  /// **NOTE:**
  /// During the setup, a set of restricted characters can be defined to be
  /// removed from the stats. By default, the only restricted character is the
  /// `space`. That is why the [count] for the example below results in `16`
  /// instead of `18`.
  ///
  /// Another thing to consider is that the summary is case *insensitive*. Note
  /// that the letter `a` has the top frequency, be it `3`.
  Summary stats({NameType what, List<String> restrictions = const [' ']}) {
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
  /// @example
  /// For a given name such as `Mr Keanu Charles Reeves`, shortening this name
  /// is equivalent to making it `Keanu Reeves`.
  ///
  /// As a shortened name, the namon of the first name is favored over the other
  /// names forming part of the entire first names, if any. Meanwhile, for
  /// the last name, the configured `lastnameFormat` is prioritized.
  ///
  /// @example
  /// For a given `Firstname Fathername Mothername`, shortening this name when
  /// the lastnameFormat is set as `mother` is equivalent to making it:
  /// `Firstname Mothername`.
  String shorten({NameOrder orderedBy}) {
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
  /// if the set limit is violated, [warning] warns the user about it.
  ///
  /// @example
  /// The flattening operation is only executed iff there is valid entry and it
  /// surpasses the limit set. In the examples below, let us assume that the
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
  String flatten(
      {int limit = 20,
      FlattenedBy by = FlattenedBy.middleName,
      bool warning = true}) {
    if (fullName().length <= limit) return fullName();

    var sep = '.',
        fn = _fullName.firstName,
        mn = middleName().join(' '),
        ln = _fullName.lastName,
        hasMid = hasMiddleName(),
        firsts = fn.initials().join(sep) + sep,
        lasts = ln.initials().join(sep) + sep,
        mids = hasMiddleName()
            ? _fullName.middleName.map((n) => n.initials()).join(sep) + sep
            : '',
        gname = <String>[];

    if (_config.orderedBy == NameOrder.firstName) {
      switch (by) {
        case FlattenedBy.firstName:
          gname =
              hasMid ? [firsts, mn, ln.toString()] : [firsts, ln.toString()];
          break;
        case FlattenedBy.lastName:
          gname = hasMid ? [fn.toString(), mn, lasts] : [fn.toString(), lasts];
          break;
        case FlattenedBy.middleName:
          gname = hasMid
              ? [fn.toString(), mids, ln.toString()]
              : [fn.toString(), ln.toString()];
          break;
        case FlattenedBy.firstMid:
          gname =
              hasMid ? [firsts, mids, ln.toString()] : [firsts, ln.toString()];
          break;
        case FlattenedBy.midLast:
          gname =
              hasMid ? [fn.toString(), mids, lasts] : [fn.toString(), lasts];
          break;
        case FlattenedBy.all:
          gname = hasMid ? [firsts, mids, lasts] : [firsts, lasts];
          break;
      }
    } else {
      switch (by) {
        case FlattenedBy.firstName:
          gname =
              hasMid ? [ln.toString(), firsts, mn] : [ln.toString(), firsts];
          break;
        case FlattenedBy.lastName:
          gname = hasMid ? [lasts, fn.toString(), mn] : [lasts, fn.toString()];
          break;
        case FlattenedBy.middleName:
          gname = hasMid
              ? [ln.toString(), fn.toString(), mids]
              : [ln.toString(), fn.toString()];
          break;
        case FlattenedBy.firstMid:
          gname =
              hasMid ? [ln.toString(), firsts, mids] : [ln.toString(), firsts];
          break;
        case FlattenedBy.midLast:
          gname =
              hasMid ? [lasts, fn.toString(), mids] : [lasts, fn.toString()];
          break;
        case FlattenedBy.all:
          gname = hasMid ? [firsts, mids, lasts] : [firsts, lasts];
          break;
      }
    }

    var flat = by == FlattenedBy.all ? gname.join() : gname.join(' ');
    if (warning && flat.length > limit) {
      print('The flattened name <$flat> still surpasses the set limit $limit');
    }
    return flat;
  }

  /// Zips or compacts a name using different forms of variants.
  ///
  /// See [flatten()] for more details.
  String zip({FlattenedBy by = FlattenedBy.midLast}) =>
      flatten(limit: 0, by: by, warning: false);

  /// Formats the [fullName] as desired.
  ///
  /// [how] to format it?
  /// string format
  /// -------------
  /// 'short': typical first + last name
  /// 'long': birth name (without prefix and suffix)
  ///
  /// char format
  /// -----------
  /// 'b': birth name
  /// 'B': capitalized birth name
  /// 'f': first name
  /// 'F': capitalized first name
  /// 'l': last name (official)
  /// 'L': capitalized last name
  /// 'm': middle names
  /// 'M': capitalized middle names
  /// 'o': official document format
  /// 'O': official document format in capital letters
  /// 'p': prefix
  /// 'P': capitalized prefix
  /// 's': suffix
  /// 'S': capitalized suffix
  ///
  /// punctuations
  /// ------------
  /// '.': period
  /// ',': comma
  /// ' ': space
  /// '-': hyphen
  /// '_': underscore
  ///
  /// @example
  /// Given the name `Joe Jim Smith`, call [format] with the how string.
  /// - format('l f') => 'Smith Joe'
  /// - format('L, f') => 'SMITH, Joe'
  /// - format('short') => 'Joe Smith'
  /// - format() => 'SMITH, Joe Jim'
  String format([String how = 'official']) {
    if (how == 'short') return shorten();
    if (how == 'long') return birthName();
    if (how == 'official') how = 'o';

    final formatted = <String>[];
    for (var c in how.split('')) {
      if (!allowedTokens.contains(c)) {
        throw ArgumentError('<$c> is an invalid character for the formatting.');
      }
      formatted.add(_map(c) ?? '');
    }
    return formatted.join().trim();
  }

  /// Transforms a [birthName] to UPPERCASE.
  String upper() => birthName().toUpperCase();

  /// Transforms a [birthName]  to lowercase.
  String lower() => birthName().toLowerCase();

  /// Transforms a [birthName]  to camelCase.
  String camel() => decapitalize(pascal());

  /// Transforms a [birthName]  to PascalCase.
  String pascal() => split().map((n) => capitalize(n)).join();

  /// Transforms a [birthName]  to snake_case.
  String snake() => split().map((n) => n.toLowerCase()).join('_');

  /// Transforms a [birthName] to hyphen-case (or kebab-case).
  String hyphen() => split().map((n) => n.toLowerCase()).join('-');

  /// Transforms a [birthName]  to dot.case.
  String dot() => split().map((n) => n.toLowerCase()).join('.');

  /// Transforms a [birthName]  to ToGgLe CaSe.
  String toggle() => toggleCase(birthName());

  /// Transforms a [birthName] to a specific title [case].
  String to([Capitalization _case]) {
    switch (_case) {
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
      default:
        return null;
    }
  }

  /// Splits a [birthName] using a [separator].
  List<String> split([RegExp separator]) {
    separator ??= RegExp(r"[' -]");
    return birthName().replaceAll(separator, ' ').split(' ');
  }

  /// Joins the name parts of a [birthName] using a [separator].
  String join([String separator = '']) => split().join(separator);

  /// Returns a password-like representation of a name.
  String passwd([NameType what]) {
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

  /// Confirms that a name part was set.
  bool has(Namon namon) => _fullName.has(namon);

  /// Gets a Map(json-like) representation of the [fullName].
  Map<String, String> toMap() => {
        'prefix': prefix(),
        'firstName': firstName(),
        'middleName': middleName().join(' '),
        'lastName': lastName(),
        'suffix': suffix()
      };

  /// Gets an array-like representation of the [fullName].
  List<String> toList() =>
      [prefix(), firstName(), middleName().join(' '), lastName(), suffix()];

  void _build<T>(Parser<T> parser, [Config options]) {
    _config = Config.mergeWith(options);
    _fullName = parser.parse(options: options);
    FullNameValidator().validate(_fullName);
    _summary = Summary(birthName());
  }

  String _map(String char) {
    switch (char) {
      case '.':
        return '.';
      case ',':
        return ',';
      case ' ':
        return ' ';
      case '-':
        return '-';
      case '_':
        return '_';
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
        var sxSep = _config.ending ? ',' : '';
        const nama = <String>[];

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
        return _fullName.prefix?.toString()?.toUpperCase();
      case 's':
        return _fullName.suffix?.toString();
      case 'S':
        return _fullName.suffix?.toString()?.toUpperCase();
      default:
        return null;
    }
  }
}
