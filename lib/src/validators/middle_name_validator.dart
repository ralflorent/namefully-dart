import '../models/enums.dart';
import '../models/name.dart';
import 'namon_validator.dart';
import 'validation_error.dart';
import 'validation_rule.dart';
import 'validator.dart';

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
