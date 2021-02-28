import 'first_name_validator.dart';
import 'name_validator.dart';
import 'namon_validator.dart';
import 'last_name_validator.dart';
import 'middle_name_validator.dart';

class Validators {
  static final namon = NamonValidator();
  static final prefix = NameValidator();
  static final firstName = FirstNameValidator();
  static final middleName = MiddleNameValidator();
  static final lastName = LastNameValidator();
  static final suffix = NameValidator();
}
