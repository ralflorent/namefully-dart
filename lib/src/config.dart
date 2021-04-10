import 'enums.dart';

/// A single [Config]uration to use across the other components.
///
/// A singleton pattern is used to keep one configuration across the [Namefully]
/// setup. This is useful to avoid confusion when building other components such
/// as [FirstName], [LastName], or [Name] of distinct types (or [Namon]) that
/// may be of particular shapes.
///
/// For example, a person's [FullName] may appear by:
/// - [NameOrder.firstName]: `Jon Snow` or
/// - [NameOrder.lastName]: `Snow Jon`.
///
/// [Config] makes it easy to set up a specific configuration for [Namefully]
/// and reuse it through other instances or components along the way. If a new
/// [Config] is needed, a named configuration may be created. It is actually
/// advised to use named [Config(name)] instead as it may help mitigate issues
/// and avoid confusion and ambiguity in the future. Plus, a named configuration
/// explains its purpose.
///
/// ```dart
/// var defaultConfig = Config();
/// var otherConfig = Config('other'); // still has the default props
/// var inlineConfig = Config.inline(name: 'other', bypass: true);
/// ```
///
/// Additionally, [mergeWith] combines an existing configuration with a new one,
/// prioritizing the new one's values.
class Config {
  /// The order of appearance of a full name.
  NameOrder orderedBy;

  /// The token used to indicate how to split string values.
  Separator separator;

  /// The abbreviation type to indicate whether or not to add period to a prefix
  /// using the American or British way.
  AbbrTitle titling;

  /// The option indicating if an [ending] suffix is used in a formal way.
  bool ending;

  /// A [bypass] of the validation rules with this option. This option is ideal
  /// to avoid checking their validity.
  bool bypass;

  /// An option indicating how to format a surname:
  /// - `father` name only
  /// - `mother` name only
  /// - `hyphenated`, joining both father and mother names with a hyphen
  /// - `all`, joining both father and mother names with a space.
  ///
  /// Note that this option can be set when creating a [LastName]. As this can
  /// become ambiguous at the time of handling it, the value set in [this] is
  /// prioritized and viewed as the source of truth for future considerations.
  LastNameFormat lastNameFormat;

  /// The name of the cached [Config].
  final String name;

  /// Cache for multiple instances.
  static final Map<String, Config> _cache = {};

  /// Returns a single [Config] with default values.
  factory Config([String name = 'default']) {
    if (_cache.containsKey(name)) {
      return _cache[name]!;
    } else {
      _cache[name] = Config._default(name);
      return _cache[name]!;
    }
  }

  /// Self instantiation with default props.
  Config._default(this.name)
      : orderedBy = NameOrder.firstName,
        separator = Separator.space,
        titling = AbbrTitle.uk,
        ending = false,
        bypass = false,
        lastNameFormat = LastNameFormat.father;

  /// Returns a unified version of default values of this [Config] and the
  /// optional values to consider.
  ///
  /// This allows an override of some properties.
  factory Config.inline({
    String name = 'default',
    NameOrder? orderedBy,
    Separator? separator,
    AbbrTitle? titling,
    bool? ending,
    bool? bypass,
    LastNameFormat? lastNameFormat,
  }) {
    return Config(name)
      ..orderedBy = orderedBy ?? NameOrder.firstName
      ..separator = separator ?? Separator.space
      ..titling = titling ?? AbbrTitle.uk
      ..ending = ending ?? false
      ..bypass = bypass ?? false
      ..lastNameFormat = lastNameFormat ?? LastNameFormat.father;
  }

  /// Returns a unified version of existing values of [Config] and the [other]
  /// provided values.
  factory Config.mergeWith(Config? other) {
    if (other == null) return Config();
    return Config.inline(
      name: other.name,
      orderedBy: other.orderedBy,
      separator: other.separator,
      titling: other.titling,
      ending: other.ending,
      bypass: other.bypass,
      lastNameFormat: other.lastNameFormat,
    );
  }

  /// Returns a copy of this configuration merged with the provided values.
  ///
  /// The word `_copy` is added to the existing config's name to create the new
  /// config's name if the name already exists for previous configurations. This
  /// is useful to maintain the uniqueness of each configuration. For example,
  /// if the new copy is made from the default configuration, this new copy will
  /// be named `default_copy`.
  Config copyWith({
    String? name,
    NameOrder? orderedBy,
    Separator? separator,
    AbbrTitle? titling,
    bool? ending,
    bool? bypass,
    LastNameFormat? lastNameFormat,
  }) {
    return Config(_getNewName(name ?? this.name + '_copy'))
      ..orderedBy = orderedBy ?? this.orderedBy
      ..separator = separator ?? this.separator
      ..titling = titling ?? this.titling
      ..ending = ending ?? this.ending
      ..bypass = bypass ?? this.bypass
      ..lastNameFormat = lastNameFormat ?? this.lastNameFormat;
    ;
  }

  /// Returns a unique new name.
  String _getNewName(String name) {
    return name == this.name || _cache.containsKey(name)
        ? _getNewName(name + '_copy')
        : name;
  }
}
