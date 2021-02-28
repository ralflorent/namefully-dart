import '../constants.dart';
import '../util.dart';
import 'namon_validator.dart';
import 'validation_error.dart';
import 'validator.dart';
import 'validators.dart';

class ListStringValidator implements Validator<List<String>> {
  final NameIndex _index;
  ListStringValidator([this._index = const NameIndex(-1, 0, -1, 1, -1)]);

  @override
  void validate(List<String> values) {
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
