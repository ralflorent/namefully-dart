import '../constants.dart';
import '../models/name.dart';
import 'validation_error.dart';
import 'validator.dart';

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
