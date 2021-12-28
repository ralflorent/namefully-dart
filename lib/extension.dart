import 'package:namefully/namefully.dart';

export 'src/config.dart';
export 'src/types.dart';
export 'src/exception.dart';

/// A quick start with `namefully` using a simple string.
///
/// This extension version is a quick way to have namefully up and running.
/// Traditionally speaking, a full name is composed of a first (maybe a middle)
/// and last name within a text format. With this extension, one can easily
/// start using the basics of `namefully` in a blink of an eye. In other words,
/// this extension serves a usability purpose only.
///
/// Keep in mind that this extension is not a replacement for the original
/// version of [Namefully], but a quick way to get started with the library.
/// A custom configuration may still be set to suit extra needs, and one may
/// access a full instance of [Namefully] to explore more options.
///
/// **Note:** This extension is not meant to be used for regular string values,
/// but ONLY for those that are considered people's names. Otherwise, the risk
/// of having [NameException]s is very high.
extension NamefullyString on String {
  /// Sets the configuration for the `namefully` library.
  set config(Config config) => _config = config;

  /// Returns a version of the string transformed into [Namefully].
  ///
  /// A customized [Config]uration may be set using [config] setter.
  Namefully get namefully => Namefully(this, config: _config);

  /// The number of characters of the [birth] name without spaces.
  int get count => namefully.count;

  /// The prefix part.
  String? get prefix => namefully.prefix;

  /// The first name.
  String get first => namefully.first;

  /// The first middle name if any.
  String? get middle => namefully.middle;

  /// Returns true if any middle name's been set.
  bool get hasMiddle => namefully.hasMiddle;

  /// The last name.
  String get last => namefully.last;

  /// The suffix part.
  String? get suffix => namefully.suffix;

  /// The birth name.
  String get birth => namefully.birth;

  /// The shortest version of a person name.
  String get short => namefully.short;

  /// The longest version of a person name.
  String get long => namefully.long;

  /// The first name combined with the last name's initial.
  String get public => namefully.public;

  ///Gets the full name's initials.
  List<String> get initials => namefully.initials(withMid: true);

  /// Formats the full name as desired.
  String format(String pattern) => namefully.format(pattern);

  /// Compacts a name using different forms of variants.
  String zip({Flat by = Flat.midLast, bool withPeriod = true}) {
    return namefully.zip(by: by, withPeriod: withPeriod);
  }
}

/// An extended version of [Summary] on String.
extension SummaryString on String {
  /// Returns the full name's statistical summary.
  Summary get summary => Summary(this);
}

// The configuration used by the extension.
Config? _config;
