import '../config.dart';
import '../models/enums.dart';
import '../models/first_name.dart';
import '../models/full_name.dart';
import '../models/last_name.dart';
import '../models/name.dart';
import '../util.dart';
import '../validators/list_string_validator.dart';
import 'parser.dart';

class ListStringParser implements Parser<List<String>> {
  @override
  List<String> raw;

  @override
  Config config;

  @override
  ListStringParser(this.raw);

  @override
  FullName parse({Config options}) {
    /// Given this setting;
    config = Config.mergeWith(options);

    /// Try to validate first (if enabled);
    final raw = this.raw.map((n) => n.trim()).toList();
    final index = organizeNameIndex(config.orderedBy, raw.length);
    if (!config.bypass) ListStringValidator(index).validate(raw);

    /// Then distribute all the elements accordingly to set [FullName].
    return _distribute(raw, index);
  }

  FullName _distribute(List<String> raw, NameIndex index) {
    final fullName = FullName(config: config);
    switch (raw.length) {
      case 2:
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 3:
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName
            .add(Name(raw.elementAt(index.middleName), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 4:
        fullName.prefix = Name(raw.elementAt(index.prefix), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName
            .add(Name(raw.elementAt(index.middleName), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 5:
        fullName.prefix = Name(raw.elementAt(index.prefix), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName
            .add(Name(raw.elementAt(index.middleName), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        fullName.suffix = Name(raw.elementAt(index.suffix), Namon.suffix);
        break;
    }
    return fullName;
  }
}
