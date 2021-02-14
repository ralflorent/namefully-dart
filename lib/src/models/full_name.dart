import 'package:meta/meta.dart';

import 'enums.dart';
import 'first_name.dart';
import 'name.dart';
import 'last_name.dart';

abstract class Nama {
  Name prefix, suffix;
  FirstName firstName;
  LastName lastName;
  List<Name> middleName;
}

class FullName implements Nama {
  @override
  Name prefix, suffix;
  @override
  FirstName firstName;
  @override
  LastName lastName;
  @override
  List<Name> middleName;
  FullName();
  FullName.inline(
      {this.prefix,
      @required this.firstName,
      this.middleName = const [],
      @required this.lastName,
      this.suffix});
  FullName.fromMap(Map<String, String> map)
      : prefix =
            map['prefix'] != null ? Name(map['prefix'], Namon.prefix) : null,
        firstName = FirstName(map['firstName']),
        middleName = map['middleName'] != null
            ? map['middleName']
                .split(' ')
                .map((n) => Name(n, Namon.middleName))
                .toList()
            : [],
        lastName = LastName(map['lastName']),
        suffix =
            map['suffix'] != null ? Name(map['suffix'], Namon.suffix) : null;
}
