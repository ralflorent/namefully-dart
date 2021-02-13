/// Welcome to namefully!
///
/// namefully is a dart utility for handing person names.
///
/// Sources
/// - repo: https://github.com/ralflorent/namefully-dart
/// - docs: https://namefully.dev
/// - pub:  https://pub.dev/packages/namefully
///
/// @license MIT

import 'model.dart';
import './models/enums.dart';
import './models/summary.dart';

/// [Namefully] does not magically guess which part of the name is what. It relies
/// actually on how the developer indicates the roles of the name parts so that
/// it, internally, can perform certain operations and saves the developer some
/// calculations/processings. Nevertheless, Namefully can be constructed using
/// distinct raw data shapes. This is intended to give some flexibility to the
/// developer so that he or she is not bound to a particular data format. Please,
/// do follow closely the APIs to know how to properly use it in order to avoid
/// some errors (mainly validation's).
///
/// [Namefully] also works like a trapdoor. Once a raw data is provided and
/// validated, a developer can only ACCESS in a vast amount of, yet effective ways
/// the name info. NO EDITING is possible. If the name is mistaken, a new instance
/// of [Namefully] must be created. Remember, this utility's primary objective is
/// to help to **handle** a person name.
///
/// Note that the name standards used for the current version of this library are
/// as follows:
///      [Prefix] Firstname [Middlename] Lastname [Suffix]
/// The opening `[` and closing `]` brackets mean that these parts are optional.
/// In other words, the most basic and typical case is a name that looks like this:
/// `John Smith`, where `John` is the first name and `Smith`, the last name.
/// @see https://departments.weber.edu/qsupport&training/Data_Standards/Name.htm
/// for more info on name standards.
///
/// **IMPORTANT**: Keep in mind that the order of appearance matters and can be
/// altered through configured parameters, which we will be seeing later on. By
/// default, the order of appearance is as shown above and will be used as a basis
/// for future examples and use cases.
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
  /// Holds a copy high quality of name data
  FullName _fullName;

  /// Holds statistical info on the name data
  Summary _summary;

  /// Holds a copy of the preset configuration
  Config _config;

  Namefully(String name, {Config options}) {
    _config = Config(options?.orderedBy ?? NameOrder.firstName,
        options?.separator ?? Separator.space);
    _fullName = StringParser(name)
        .parse(orderedBy: _config.orderedBy, separator: _config.separator);
  }
  Namefully.fromList(List<String> names, {Config options});
  Namefully.fromJson(Map<String, String> nama, {Config options});

  /// Gets the [fullName] ordered as configured
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  ///
  /// [format] is used to alter manually the order of appearance of [fullName].
  /// For example:
  ///   [this.format('l f m')] outputs `lastname firstname middlename`.
  String fullName([NameOrder orderedBy]) {
    return 'namefully';
  }

  /// Gets the [birthName] ordered as configured, no [prefix] or [suffix]
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  String birthName([NameOrder orderedBy]) {
    throw UnimplementedError();
  }

  /// Gets the [firstName] part of the [fullName].
  /// The [includeAll] param determines whether to include other pieces of the
  /// [FirstName].
  String firstName({bool includeAll = true}) {
    return _fullName.firstName.toString(includeAll: includeAll);
  }

  /// Gets the [lastName] part of the [fullName].
  /// the last name [format] overrides the how-to formatting of a surname
  /// output, considering its subparts.
  String lastName({LastNameFormat format}) {
    return _fullName.lastName.toString(format: format);
  }

  /// Gets the [middleName] part of the [fullName].
  List<String> middleName() {
    return _fullName.middleName;
  }

  /// Gets the [prefix] part of the [fullName].
  String prefix() {
    throw UnimplementedError();
  }

  /// Gets the [suffix] part of the [fullName].
  String suffix() {
    throw UnimplementedError();
  }

  /// Gets the [initials] of the [fullName].
  /// The name order [orderedBy] forces to order by [firstName] or [lastName]
  /// by overriding the preset configuration.
  /// [withMid] determines whether to include the initials of [middleName]
  ///
  /// @example
  /// Given the names:
  /// - `John Smith` => ['J', 'S']
  /// - `John Ben Smith` => ['J', 'S']
  /// when `withMid` is set to true:
  /// - `John Ben Smith` => ['J', 'B', 'S']
  ///
  /// **NOTE**:
  /// Ordered by last name obeys the following format:
  ///  `lastname firstname [middlename]`
  /// which means that if no middle name was set, setting [withMid] to true
  /// will output nothing and warn the end user about it.
  List<String> initials({NameOrder orderedBy, bool withMid = false}) {
    throw UnimplementedError();
  }

  /// Gives some descriptive statistics that summarize the central tendency,
  /// dispersion and shape of the characters' distribution.
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
    switch (what.index) {
      case 0:
        return _fullName.firstName
            .stats(includeAll: true, restrictions: restrictions);
      case 1:
        return null; // todo: middlename's summary.
      case 2:
        return _fullName.lastName
            .stats(format: _config.lastNameFormat, restrictions: restrictions);
      default:
        return _summary;
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

  /// Compresses a name by using different forms of variants.
  ///
  /// [limit]: sets a threshold as a limited number of characters supported.
  /// [by]: `'firstname'|'lastname'|'middlename'|'firstmid'|'midlast'`
  /// a variant to use when compressing the long name. The last two variants
  /// represent respectively the combination of `firstname + middlename` and
  /// `middlename + lastname`.
  /// [warning] should warn when the set limit is violated
  ///
  /// @example
  /// The compressing operation is only executed iff there is valid entry and it
  /// surpasses the limit set. In the examples below, let us assume that the
  /// name goes beyond the limit value.
  ///
  /// Compressing a long name refers to reducing the name to the following forms:
  /// 1. by firstname: 'John Winston Ono Lennon' => 'J. Winston Ono Lennon'
  /// 2. by middlename: 'John Winston Ono Lennon' => 'John W. O. Lennon'
  /// 3. by lastname: 'John Winston Ono Lennon' => 'John Winston Ono L.'
  /// 4. by firstmid: 'John Winston Ono Lennon' => 'J. W. O. Lennon'
  /// 5. by midlast: 'John Winston Ono Lennon' => 'John W. O. L.'
  ///
  /// By default, it compresses by 'middlename' variant: 'John W. O. Lennon'.
  String compact({int limit = 20, String by = 'mn', bool warning = true}) {
    throw UnimplementedError();
  }

  /// Zips or compacts a name using different forms of variants.
  String zip({String by = 'ml'}) {
    throw UnimplementedError();
  }

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
  String format({String how = 'official'}) {
    throw UnimplementedError();
  }

  /// Gets the [count] of characters of the [birthName], excluding punctuations.
  int size() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName] to UPPERCASE.
  String upper() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to lowercase.
  String lower() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to camelCase.
  String camel() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to PascalCase.
  String pascal() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to snake_case.
  String snake() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName] to hyphen-case (or kebab-case).
  String hyphen() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to dot.case.
  String dot() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName]  to ToGgLe CaSe.
  String toggle() {
    throw UnimplementedError();
  }

  /// Transforms a [birthName] to a specific title [case].
  String to() {
    throw UnimplementedError();
  }

  /// Splits a [birthName] using a [separator].
  List<String> split() {
    throw UnimplementedError();
  }

  /// Joins the name parts of a [birthName] using a [separator].
  String join() {
    throw UnimplementedError();
  }

  /// Returns a password-like representation of a name.
  String passwd({NameType what}) {
    throw UnimplementedError();
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
  bool has() {
    throw UnimplementedError();
  }

  /// Gets an exact copy of the core instance.
  Namefully clone() {
    throw UnimplementedError();
  }

  /// Gets a Map(json-like) representation of the [fullName].
  Map<String, String> toJson() {
    throw UnimplementedError();
  }

  /// Gets an array-like representation of the [fullName].
  List<String> toList() {
    throw UnimplementedError();
  }
}
