import '../models/first_name.dart';
import 'validation_error.dart';
import 'validation_rule.dart';
import 'validator.dart';
import 'validators.dart';

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
