import '../constants.dart';
import '../models/enums.dart';
import 'namon_validator.dart';
import 'validation_error.dart';
import 'validator.dart';
import 'validators.dart';

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
      NamonValidator().validate(nama[Namon.prefix]);
    }
    if (nama.containsKey(Namon.suffix)) {
      NamonValidator().validate(nama[Namon.suffix]);
    }
  }
}
