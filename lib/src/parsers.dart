/// Parsers
import 'models/model.dart';
import 'util.dart';

abstract class Parser<T> {
  /// raw data to be parsed
  T raw;

  /// Parses the raw data into a full name
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat});
}

class StringParser implements Parser<String> {
  @override
  String raw;

  StringParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final names = raw.split(SeparatorToken.extract(separator));
    return ListStringParser(names).parse(orderedBy: orderedBy, bypass: bypass);
  }
}

class ListStringParser implements Parser<List<String>> {
  @override
  List<String> raw;

  ListStringParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final raw = this.raw.map((n) => n.trim()).toList();
    return _distribute(raw);
  }

  FullName _distribute(List<String> raw) {
    final fullName = FullName();
    switch (raw.length) {
      case 2:
        fullName.firstName = FirstName(raw.elementAt(0));
        fullName.lastName = LastName(raw.elementAt(1));
        break;
      case 3:
        fullName.firstName = FirstName(raw.elementAt(0));
        fullName.middleName.add(Name(raw.elementAt(1), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(2));
        break;
      case 4:
        fullName.prefix = Name(raw.elementAt(0), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(1));
        fullName.middleName.add(Name(raw.elementAt(2), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(3));
        break;
      case 5:
        fullName.prefix = Name(raw.elementAt(0), Namon.prefix);
        fullName.firstName = FirstName(raw.elementAt(1));
        fullName.middleName.add(Name(raw.elementAt(2), Namon.middleName));
        fullName.lastName = LastName(raw.elementAt(3));
        fullName.suffix = Name(raw.elementAt(4), Namon.suffix);
        break;
    }
    return fullName;
  }
}

class MapParser implements Parser<Map<String, String>> {
  @override
  Map<String, String> raw;

  MapParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final fullName = FullName.fromMap(raw);
    return fullName;
  }
}

class ListNameParser implements Parser<List<Name>> {
  @override
  List<Name> raw;

  ListNameParser(this.raw);

  @override
  FullName parse(
      {NameOrder orderedBy,
      Separator separator,
      bool bypass,
      LastNameFormat lastNameFormat}) {
    final fullName = FullName();
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
          fullName.lastName = LastName(name.father, name.mother);
        } else {
          fullName.lastName = LastName(name.namon);
        }
      } else if (name.type == Namon.suffix) {
        fullName.suffix = name;
      }
    }
    return fullName;
  }
}
