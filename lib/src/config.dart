/// Config

import 'models/enums.dart';
import 'parsers.dart';

/// The single [Config]uration to use across the library.
///
/// A singleton pattern is used to keep one configuration across the [Namefully]
/// setup. This is useful to avoid confusion when building other components such
/// as [FirstName], [LastName], or [Name] of distinct types (or [Namon]) that
/// may be of particular shapes.
///
/// For example, a person's [FullName] may appear by:
/// [NameOrder.firstName]: `Jon Snow` or
/// [NameOrder.lastName]: `Snow Jon`.
class Config {
  /// The order of appearance of a full name: by [NameOrder.firstName] or
  /// [NameOrder.lastName].
  NameOrder orderedBy;

  /// For literal `String` input, this is the parameter used to indicate the
  /// token to utilize to split the string names.
  Separator separator;

  /// Whether or not to add period to a prefix using the American or British way.
  AbbrTitle titling;

  /// Indicates if the ending suffix should be separated with a comma or space.
  bool ending;

  /// Bypass the validation rules with this option. Since I only provide a
  /// handful of suffixes or prefixes in English, this parameter is ideal to
  /// avoid checking their validity.
  bool bypass;

  /// Custom parser, a user-defined parser indicating how the name set is
  /// organized. [Namefully] cannot guess it.
  Parser<dynamic> parser;

  /// how to format a surname:
  /// - 'father' (father name only)
  /// - 'mother' (mother name only)
  /// - 'hyphenated' (joining both father and mother names with a hyphen)
  /// - 'all' (joining both father and mother names with a space).
  ///
  /// This parameter can be set either by an instance of a last name or during
  /// the creation of a namefully instance. To avoid ambiguity, we prioritize as
  /// source of truth the value set as optional parameter when instantiating
  /// namefully.
  LastNameFormat lastNameFormat;

  /// Cache of an instance of this class (self instantiation with default props).
  static final Config _config = Config._internal();

  /// Returns a single [Config] with default values.
  factory Config() => _config;

  Config._internal()
      : orderedBy = NameOrder.firstName,
        separator = Separator.space,
        titling = AbbrTitle.uk,
        ending = false,
        bypass = false,
        parser = null,
        lastNameFormat = LastNameFormat.father;

  /// Returns a unified version of default values of this [Config] and the
  /// optional values to consider.
  ///
  /// This allows an override of some properties
  factory Config.inline(
      {NameOrder orderedBy,
      Separator separator,
      AbbrTitle titling,
      bool ending,
      bool bypass,
      Parser<dynamic> parser,
      LastNameFormat lastNameFormat}) {
    _config.orderedBy = orderedBy ?? NameOrder.firstName;
    _config.separator = separator ?? Separator.space;
    _config.titling = titling ?? AbbrTitle.uk;
    _config.ending = ending ?? false;
    _config.bypass = bypass ?? false;
    _config.parser = parser;
    _config.lastNameFormat = lastNameFormat ?? LastNameFormat.father;
    return _config;
  }

  /// Returns a unified version of prexisting values of [Config] and the [other]
  /// provided values.
  factory Config.mergeWith(Config other) {
    if (other == null) return _config;
    return Config.inline(
        orderedBy: other.orderedBy,
        separator: other.separator,
        titling: other.titling,
        ending: other.ending,
        bypass: other.bypass,
        parser: other.parser,
        lastNameFormat: other.lastNameFormat);
  }
}
