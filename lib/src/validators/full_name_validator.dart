import '../models/first_name.dart';
import '../models/full_name.dart';
import '../models/last_name.dart';
import '../models/name.dart';
import 'validation_error.dart';
import 'validator.dart';

class FullNameValidator implements Validator<FullName> {
  @override
  void validate(FullName fullName) {
    if (fullName.firstName == null) {
      throw ValidationError.name('firstName', 'field required');
    }
    if (!(fullName.firstName is FirstName)) {
      throw ValidationError.name('firstName', 'must be of a FirstName type');
    }
    if (fullName.lastName == null) {
      throw ValidationError.name('lastName', 'field required');
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
