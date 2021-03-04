/// Validators

import 'constants.dart';
import 'enums.dart';
import 'full_name.dart';
import 'models.dart';
import 'utils.dart';

class ValidationError extends Error {
  /// Name of the invalid [name] type, if available.
  final String? name;

  /// Message describing the problem.
  final String? message;

  /// Creates error indicating with a [message] describing the problem.
  ///
  /// For example:
  ///     "Validation failed (firstName)."
  ValidationError([this.message]) : name = null;

  /// Creates error containing the invalid [name] type and a [message] that
  /// briefly describes the problem, if provided. For example:
  ///     "Validation failed (firstName): Must be provided"
  ///     "Validation failed (firstName)"
  ValidationError.name(this.name, [this.message]);

  @override
  String toString() {
    var nameString = name == null ? '' : ' ($name)';
    var messageString = message == null ? '' : ': $message';
    return 'Validation failed$nameString$messageString';
  }
}

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

abstract class Validator<T> {
  void validate(T value);
}

/// Namon validator to help to parse single pieces of string.
class NamonValidator implements Validator<String> {
  static final _validator = NamonValidator._internal();
  factory NamonValidator() => _validator;
  NamonValidator._internal();

  /// Validates the name content [value].
  @override
  void validate(String value) {
    if (!ValidationRule.namon.hasMatch(value)) {
      throw ValidationError.name('namon', 'invalid content: "$value"');
    }
  }
}

class FirstNameValidator implements Validator<dynamic> {
  /// Validates the name content [value].
  @override
  void validate(dynamic /** String | FirstName */ value) {
    if (value == null) {
      throw ValidationError.name('firstName', 'field required');
    }
    if (value is String) {
      if (!ValidationRule.firstName.hasMatch(value)) {
        throw ValidationError.name('firstName', 'invalid content: "$value"');
      }
    } else if (value is FirstName) {
      Validators.firstName.validate(value.namon);
      if (value.more != null && value.more.isNotEmpty) {
        value.more.forEach(Validators.firstName.validate);
      }
    } else {
      throw ArgumentError('expecting String | FirstName');
    }
  }
}

class MiddleNameValidator implements Validator<dynamic> {
  /// Validates the name content [value].
  @override
  void validate(dynamic /** String | List<String> | List<Name> */ value) {
    var namonValidator = NamonValidator();
    if (value is String) {
      if (!ValidationRule.middleName.hasMatch(value)) {
        throw ValidationError.name('middleName', 'invalid content: "$value"');
      }
    } else if (value is List<String>) {
      try {
        value.forEach(namonValidator.validate);
      } on ValidationError {
        throw ValidationError.name('middleName', 'invalid content');
      }
    } else if (value is List<Name>) {
      try {
        value.forEach((n) {
          namonValidator.validate(n.namon);
          if (n.type != Namon.middleName) throw ValidationError();
        });
      } on ValidationError {
        throw ValidationError.name('middleName', 'invalid content');
      }
    } else {
      throw ArgumentError('expecting String | List<String> | List<Name>');
    }
  }
}

class LastNameValidator implements Validator<dynamic> {
  /// Validates the name content [value].
  @override
  void validate(dynamic /** String | LastName */ value) {
    if (value == null) {
      throw ValidationError.name('lastName', 'field required');
    }
    if (value is String) {
      if (!ValidationRule.lastName.hasMatch(value)) {
        throw ValidationError.name('lastName', 'invalid content: "$value"');
      }
    } else if (value is LastName) {
      Validators.lastName.validate(value.father);
      if (value.mother?.isNotEmpty == true) {
        Validators.firstName.validate(value.mother);
      }
    } else {
      throw ArgumentError('expecting String | LastName');
    }
  }
}

class NameValidator implements Validator<Name> {
  /// Validates the [name] content.
  @override
  void validate(Name name) {
    if (!ValidationRule.namon.hasMatch(name.namon)) {
      throw ValidationError.name(
          name.type.toString(), 'invalid content: "${name.namon}"');
    }
  }
}

class FullNameValidator implements Validator<FullName> {
  @override
  void validate(FullName fullName) {
    if (!(fullName.firstName is FirstName)) {
      throw ValidationError.name('firstName', 'must be of a FirstName type');
    }
    if (!(fullName.lastName is LastName)) {
      throw ValidationError.name('lastName', 'must be of a LastName type');
    }
    if (!(fullName.middleName is List<Name>)) {
      throw ValidationError.name('middleName', 'must be of a List<Name> type');
    }
    if (fullName.prefix != null && !(fullName.prefix is Name)) {
      throw ValidationError.name('prefix', 'must be of a Name type');
    }
    if (fullName.suffix != null && !(fullName.suffix is Name)) {
      throw ValidationError.name('suffix', 'must be of a Name type');
    }
  }
}

class Validators {
  static final namon = NamonValidator();
  static final prefix = NameValidator();
  static final firstName = FirstNameValidator();
  static final middleName = MiddleNameValidator();
  static final lastName = LastNameValidator();
  static final suffix = NameValidator();
}

class NamaValidator implements Validator<Map<Namon, String>> {
  @override
  void validate(Map<Namon, String> nama) {
    if (nama.isEmpty) throw ValidationError('must not be empty');
    if (nama.length < minNumberOfNameParts &&
        nama.length > maxNumberOfNameParts) {
      throw ValidationError(
          'expecting $minNumberOfNameParts-$maxNumberOfNameParts fields');
    }
    if (!nama.containsKey(Namon.firstName)) {
      throw ValidationError('"firstName" is a required key');
    } else {
      Validators.firstName.validate(nama[Namon.firstName]);
    }
    if (!nama.containsKey(Namon.lastName)) {
      throw ValidationError('"lastName" is a required field');
    } else {
      Validators.lastName.validate(nama[Namon.lastName]);
    }
    if (nama.containsKey(Namon.prefix)) {
      NamonValidator().validate(nama[Namon.prefix]!);
    }
    if (nama.containsKey(Namon.suffix)) {
      NamonValidator().validate(nama[Namon.suffix]!);
    }
  }
}

class ListStringValidator implements Validator<List<String>> {
  final NameIndex _index;
  ListStringValidator([this._index = const NameIndex(-1, 0, -1, 1, -1)]);

  @override
  void validate(List<String> values) {
    if (values.isEmpty ||
        values.length < minNumberOfNameParts &&
            values.length > maxNumberOfNameParts) {
      throw ValidationError(
          'expecting a list of $minNumberOfNameParts-$maxNumberOfNameParts '
          'elements');
    }

    switch (values.length) {
      case 2:
        Validators.firstName.validate(values[_index.firstName]);
        Validators.lastName.validate(values[_index.lastName]);
        break;
      case 3:
        Validators.firstName.validate(values[_index.firstName]);
        Validators.middleName.validate(values[_index.middleName]);
        Validators.lastName.validate(values[_index.lastName]);
        break;
      case 4:
        NamonValidator().validate(values[_index.prefix]);
        Validators.firstName.validate(values[_index.firstName]);
        Validators.middleName.validate(values[_index.middleName]);
        Validators.lastName.validate(values[_index.lastName]);
        break;
      case 5:
        NamonValidator().validate(values[_index.prefix]);
        Validators.firstName.validate(values[_index.firstName]);
        Validators.middleName.validate(values[_index.middleName]);
        Validators.lastName.validate(values[_index.lastName]);
        NamonValidator().validate(values[_index.suffix]);
        break;
    }
  }
}

class ListNameValidator implements Validator<List<Name>> {
  @override
  void validate(List<Name> values) {
    if (values == null) {
      throw ArgumentError.notNull();
    }
    if (values.isEmpty ||
        values.length < minNumberOfNameParts &&
            values.length > maxNumberOfNameParts) {
      throw ValidationError(
          'expecting a list of $minNumberOfNameParts-$maxNumberOfNameParts '
          'elements');
    }
  }
}
