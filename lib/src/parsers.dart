import 'config.dart';
import 'enums.dart';
import 'exceptions.dart';
import 'full_name.dart';
import 'names.dart';
import 'utils.dart';
import 'validators.dart';

/// A parser signature that helps to organize the names accordingly.
abstract class Parser<T> {
  /// The raw data to be parsed.
  late T raw;

  /// The configurations to consider while parsing.
  Config? config;

  /// Parses the raw data into a [FullName].
  FullName parse({Config? options});
}

class StringParser implements Parser<String> {
  @override
  String raw;

  @override
  Config? config;

  StringParser(this.raw);

  @override
  FullName parse({Config? options}) {
    config = Config.merge(options);
    final names = raw.split(config!.separator.token);
    return ListStringParser(names).parse(options: options);
  }
}

class ListStringParser implements Parser<List<String>> {
  @override
  List<String> raw;

  @override
  Config? config;

  @override
  ListStringParser(this.raw);

  @override
  FullName parse({Config? options}) {
    /// Given this setting;
    config = Config.merge(options);

    /// Try to validate first (if enabled);
    final raw = this.raw.map((n) => n.trim()).toList();
    final nameIndex = organizeNameIndex(config!.orderedBy, raw.length);
    if (!config!.bypass) ListStringValidator(nameIndex).validate(raw);

    /// Then distribute all the elements accordingly to set [FullName].
    return _distribute(raw, nameIndex);
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
        fullName.middleName.add(Name(raw[index.middleName], Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 4:
        fullName.prefix = Name(raw.elementAt(index.prefix), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName.add(Name(raw[index.middleName], Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 5:
        fullName.prefix = Name(raw.elementAt(index.prefix), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName.add(Name(raw[index.middleName], Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        fullName.suffix = Name(raw.elementAt(index.suffix), Namon.suffix);
        break;
    }
    return fullName;
  }
}

class JsonNameParser implements Parser<Map<String, String>> {
  @override
  Map<String, String> raw;

  @override
  Config? config;

  JsonNameParser(this.raw);

  @override
  FullName parse({Config? options}) {
    /// Given this setting;
    config = Config.merge(options);

    /// Try to validate first;
    if (!config!.bypass) NamaValidator().validate(_asNama());

    /// Then create a [FullName] from json.
    return FullName.fromJson(raw, config: config);
  }

  Map<Namon, String> _asNama() {
    return raw.map<Namon, String>((key, value) {
      Namon? namon = Namon.cast(key);
      if (namon == null) {
        throw InputException(
          source: raw.values.join(' '),
          message: 'unsupported key "$key"',
        );
      }
      return MapEntry(namon, value);
    });
  }
}

class ListNameParser implements Parser<List<Name>> {
  @override
  List<Name> raw;

  @override
  Config? config;

  ListNameParser(this.raw);

  @override
  FullName parse({Config? options}) {
    /// Given this setting;
    config = Config.merge(options);

    /// Try to validate first;
    if (!config!.bypass) ListNameValidator().validate(raw);
    final fullName = FullName(config: config);

    /// Then distribute all the elements accordingly to set [FullName].
    for (final name in raw) {
      if (name.type == Namon.prefix) {
        fullName.prefix = name;
      } else if (name.type == Namon.firstName) {
        fullName.firstName = name is FirstName ? name : FirstName(name.namon);
      } else if (name.type == Namon.middleName) {
        fullName.middleName.add(name);
      } else if (name.type == Namon.lastName) {
        fullName.lastName = name is LastName
            ? LastName(name.namon, name.mother, config!.lastNameFormat)
            : LastName(name.namon, null, config!.lastNameFormat);
      } else if (name.type == Namon.suffix) {
        fullName.suffix = name;
      }
    }
    return fullName;
  }
}
