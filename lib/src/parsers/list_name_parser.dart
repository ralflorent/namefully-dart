import '../config.dart';
import '../models/enums.dart';
import '../models/first_name.dart';
import '../models/full_name.dart';
import '../models/last_name.dart';
import '../models/name.dart';
import '../validators/list_name_validator.dart';
import 'parser.dart';

class ListNameParser implements Parser<List<Name>> {
  @override
  List<Name> raw;

  @override
  Config config;

  ListNameParser(this.raw);

  @override
  FullName parse({Config options}) {
    /// Given this setting;
    config = Config.mergeWith(options);

    /// Try to validate first;
    if (!config.bypass) ListNameValidator().validate(raw);
    final fullName = FullName(config: config);

    /// Then distribute all the elements accordingly to set [FullName].
    for (final name in raw) {
      if (name.type == Namon.prefix) {
        fullName.prefix = name;
      } else if (name.type == Namon.firstName) {
        if (name is FirstName) {
          fullName.firstName = FirstName(name.namon, name.more);
        } else {
          fullName.firstName = FirstName(name.namon);
        }
      } else if (name.type == Namon.middleName) {
        fullName.middleName.add(name);
      } else if (name.type == Namon.lastName) {
        if (name is LastName) {
          fullName.lastName =
              LastName(name.father, name.mother, config.lastNameFormat);
        } else {
          fullName.lastName = LastName(name.namon, null, config.lastNameFormat);
        }
      } else if (name.type == Namon.suffix) {
        fullName.suffix = name;
      }
    }
    return fullName;
  }
}
