import 'config.dart';
import 'types.dart';
import 'exception.dart';
import 'full_name.dart';
import 'name.dart';
import 'utils.dart';
import 'validator.dart';

/// A parser signature that helps to organize the names accordingly.
abstract class Parser<T> {
  /// Enables const constructors.
  const Parser(this.raw);

  /// The raw data to be parsed.
  final T raw;

  /// Parses the raw data into a [FullName] while considering some [options].
  FullName parse({Config? options});

  static Parser build(String text) {
    var parts = text.trim().split(Separator.space.token);
    var length = parts.length;
    if (parts.isEmpty || length == 1) {
      throw NameException.input(
        source: text,
        message: 'cannot build from invalid input',
      );
    } else if (length == 2 || length == 3) {
      return StringParser(text);
    } else {
      return ListStringParser([
        parts.first,
        parts.getRange(1, length - 1).join(' '),
        parts.last,
      ]);
    }
  }
}

class StringParser implements Parser<String> {
  const StringParser(this.raw);

  @override
  final String raw;

  @override
  FullName parse({Config? options}) {
    final config = Config.merge(options);
    final names = raw.split(config.separator.token);
    return ListStringParser(names).parse(options: options);
  }
}

class ListStringParser implements Parser<List<String>> {
  const ListStringParser(this.raw);

  @override
  final List<String> raw;

  @override
  FullName parse({Config? options}) {
    /// Given this setting;
    final config = Config.merge(options);

    /// Try to validate first (if enabled);
    final raw = this.raw.map((n) => n.trim()).toList();
    final nameIndex = NameIndex.when(config.orderedBy, raw.length);
    final validator = ListStringValidator(nameIndex);

    if (config.bypass) {
      validator.validateIndex(raw);
    } else {
      validator.validate(raw);
    }

    /// Then distribute all the elements accordingly to set [FullName].
    return _distribute(raw, config, nameIndex);
  }

  FullName _distribute(List<String> raw, Config config, NameIndex index) {
    final fullName = FullName(config: config);
    switch (raw.length) {
      case 2:
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 3:
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName.add(Name.middle(raw[index.middleName]));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 4:
        fullName.prefix = Name.prefix(raw.elementAt(index.prefix));
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName.add(Name.middle(raw[index.middleName]));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        break;
      case 5:
        fullName.prefix = Name.prefix(raw.elementAt(index.prefix));
        fullName.firstName = FirstName(raw.elementAt(index.firstName));
        fullName.middleName.add(Name.middle(raw[index.middleName]));
        fullName.lastName = LastName(raw.elementAt(index.lastName));
        fullName.suffix = Name.suffix(raw.elementAt(index.suffix));
        break;
    }
    return fullName;
  }
}

class JsonNameParser implements Parser<Map<String, String>> {
  const JsonNameParser(this.raw);

  @override
  final Map<String, String> raw;

  @override
  FullName parse({Config? options}) {
    // Given this setting;
    final config = Config.merge(options);

    // Try to validate first;
    NamaValidator().validate(_asNama());

    // Then create a [FullName] from json.
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
  const ListNameParser(this.raw);

  @override
  final List<Name> raw;

  @override
  FullName parse({Config? options}) {
    // Given this setting;
    final config = Config.merge(options);

    // Try to validate first;
    ListNameValidator().validate(raw);
    final fullName = FullName(config: config);

    // Then distribute all the elements accordingly to set [FullName].
    for (final name in raw) {
      if (name.type == Namon.prefix) {
        fullName.prefix = name;
      } else if (name.type == Namon.firstName) {
        fullName.firstName = name is FirstName ? name : FirstName(name.value);
      } else if (name.type == Namon.middleName) {
        fullName.middleName.add(name);
      } else if (name.type == Namon.lastName) {
        fullName.lastName = name is LastName
            ? LastName(name.value, name.mother, config.surname)
            : LastName(name.value, null, config.surname);
      } else if (name.type == Namon.suffix) {
        fullName.suffix = name;
      }
    }
    return fullName;
  }
}
