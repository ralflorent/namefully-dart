/// Config

import './models/enums.dart';
import './parsers.dart';

class Config {
  /// The order of appearance of a full name: by [firstName] or [lastName].
  NameOrder orderedBy;

  /// For literal `String` input, this is the parameter used to indicate the
  /// token to utilize to split the string names.
  final Separator separator;

  /// Whether or not to add period to a prefix using the American or British way.
  final AbbrTitle titling;

  /// Indicates if the ending suffix should be separated with a comma or space.
  final bool ending;

  /// Bypass the validation rules with this option. Since I only provide a
  /// handful of suffixes or prefixes in English, this parameter is ideal to
  /// avoid checking their validity.
  final bool bypass;

  /// Custom parser, a user-defined parser indicating how the name set is
  /// organized. [Namefully] cannot guess it.
  final Parser<dynamic> parser;

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
  final LastNameFormat lastNameFormat;

  Config() : this._default();

  Config._default()
      : orderedBy = NameOrder.firstName,
        separator = Separator.space,
        titling = AbbrTitle.uk,
        ending = false,
        bypass = false,
        parser = null,
        lastNameFormat = LastNameFormat.father;

  Config.from(final Map<String, dynamic> map)
      : orderedBy = map['orderedBy'] as NameOrder,
        separator = map['separator'] as Separator,
        titling = map['titling'] as AbbrTitle,
        ending = map['ending'] as bool,
        bypass = map['bypass'] as bool,
        parser = map['parser'] as Parser<dynamic>,
        lastNameFormat = map['lastNameFormat'] as LastNameFormat;

  Config.inline(
      {NameOrder orderedBy,
      Separator separator,
      AbbrTitle titling,
      bool ending,
      bool bypass,
      Parser<dynamic> parser,
      LastNameFormat lastNameFormat})
      : orderedBy = orderedBy ?? NameOrder.firstName,
        separator = separator ?? Separator.space,
        titling = titling ?? AbbrTitle.uk,
        ending = ending ?? false,
        bypass = bypass ?? false,
        parser = parser,
        lastNameFormat = lastNameFormat ?? LastNameFormat.father;

  Config.mergeWith(Config other)
      : orderedBy = other?.orderedBy ?? NameOrder.firstName,
        separator = other?.separator ?? Separator.space,
        titling = other?.titling ?? AbbrTitle.uk,
        ending = other?.ending ?? false,
        bypass = other?.bypass ?? false,
        parser = other?.parser,
        lastNameFormat = other?.lastNameFormat ?? LastNameFormat.father;
}
