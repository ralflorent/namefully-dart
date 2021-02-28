import '../models/last_name.dart';
import 'validation_error.dart';
import 'validation_rule.dart';
import 'validator.dart';
import 'validators.dart';

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
        Validators.lastName.validate(value.mother);
      }
    } else {
      throw ArgumentError('expecting String | LastName');
    }
  }
}
