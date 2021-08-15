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
    config = Config.mergeWith(options);
    final names = raw.split(SeparatorChar.extract(config!.separator));
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
    config = Config.mergeWith(options);

    /// Try to validate first (if enabled);
    final raw = this.raw.map((n) => n.trim()).toList();
    final index = organizeNameIndex(config!.orderedBy, raw.length);
    if (!config!.bypass) ListStringValidator(index).validate(raw);

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

class JsonNameParser implements Parser<Map<String, String>> {
  @override
  Map<String, String> raw;

  @override
  Config? config;

  final Map<Namon, String> _nama = {};

  JsonNameParser(this.raw) {
    _asNama();
  }

  @override
  FullName parse({Config? options}) {
    /// Given this setting;
    config = Config.mergeWith(options);

    /// Try to validate first;
    if (!config!.bypass) NamaValidator().validate(_nama);

    /// Then create a [FullName] from json.
    return FullName.fromJson(raw, config: config);
  }

  void _asNama() {
    for (var entry in raw.entries) {
      var namon = NamonKey.castTo(entry.key);
      if (namon == null) {
        throw InputException(source: 'null', message: 'unacceptable key');
      }
      if (_nama.containsKey(namon)) {
        throw InputException(
          source: namon,
          message: 'duplicate keys "${entry.key}"',
        );
      } else {
        _nama[namon] = entry.value;
      }
    }
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
    config = Config.mergeWith(options);

    /// Try to validate first;
    if (!config!.bypass) ListNameValidator().validate(raw);
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
              LastName(name.father, name.mother, config!.lastNameFormat);
        } else {
          fullName.lastName =
              LastName(name.namon, null, config!.lastNameFormat);
        }
      } else if (name.type == Namon.suffix) {
        fullName.suffix = name;
      }
    }
    return fullName;
  }
}
