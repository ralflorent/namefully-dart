import '../models/name.dart';
import 'validation_error.dart';
import 'validation_rule.dart';
import 'validator.dart';

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
