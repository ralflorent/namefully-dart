import 'validation_error.dart';
import 'validation_rule.dart';
import 'validator.dart';

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
