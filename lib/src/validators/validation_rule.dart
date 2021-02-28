/// Set of [ValidationRule]s (or [RegEx]).
///
/// This is intented to match specific alphabets only as a person name does not
/// contain special characters. `\w` does not cover non-Latin characters. So,
/// it is extended using unicode chars to cover more cases (e.g., Icelandic).
/// It matches as follows:
/// - `[a-z]`: Latin alphabet from a (index 97) to z (index 122)
/// - `[A-Z]`: Latin alphabet from A (index 65) to Z (index 90)
/// - `[\u00C0-\u00D6]`: Latin/German from À (index 192) to Ö (index 214)
/// - `[\u00D8-\u00f6]`: German/Icelandic from Ø (index 216) to ö (index 246)
/// - `[\u00f8-\u00ff]`: German/Icelandic from ø (index 248) to ÿ (index 255)
/// - `[\u0400-\u04FF]`: Cyrillic alphabet from Ѐ (index 1024) to ӿ (index 1279)
/// - `[Ά-ωΑ-ώ]`: Greek alphabet from Ά (index 902) to ω (index 969)
class ValidationRule {
  static final base = RegExp(
      r'[a-zA-Z\u00C0-\u00D6\u00D8-\u00f6\u00f8-\u00ff\u0400-\u04FFΆ-ωΑ-ώ]');

  /// Matches one name part (namon) that is of nature:
  /// - Latin (English, Spanish, French, etc.)
  /// - European (Greek, Cyrillic, Icelandic, German)
  /// - hyphenated
  /// - with apostrophe
  /// - with space
  static final namon = RegExp(
      "^${ValidationRule.base.pattern}+(([' -]${ValidationRule.base.pattern})?"
      '${ValidationRule.base.pattern}*)*\$');

  /// Matches one name part (namon) that is of nature:
  /// - Latin (English, Spanish, French, etc.)
  /// - European (Greek, Cyrillic, Icelandic, German)
  /// - hyphenated
  /// - with apostrophe
  /// - with space
  static final firstName = ValidationRule.namon;

  /// Matches 1+ names part (namon) that are of nature:
  /// - Latin (English, Spanish, French, etc.)
  /// - European (Greek, Cyrillic, Icelandic, German)
  /// - hyphenated
  /// - with apostrophe
  /// - with space
  static final middleName = RegExp("^${ValidationRule.base.pattern}+(([' -]"
      '${ValidationRule.base.pattern})?${ValidationRule.base.pattern}*)*\$');

  /// Matches one name part (namon) that is of nature:
  /// - Latin (English, Spanish, French, etc.)
  /// - European (Greek, Cyrillic, Icelandic, German)
  /// - hyphenated
  /// - with apostrophe
  /// - with space
  static final lastName = ValidationRule.namon;
}
