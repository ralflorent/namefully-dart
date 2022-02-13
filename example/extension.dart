import 'package:namefully/extension.dart';

void main() {
  // Gives a simple name some super power.
  String name = 'Jane Doe';

  // Gets the count of characters, including space.
  print(name.length); // 8

  // Gets the first name.
  print(name.first); // Jane

  // Gets the first middle name.
  print(name.middle); // null

  // Gets the last name.
  print(name.last); // Doe

  // Gets all the initials.
  print(name.initials); // ['J', 'D']

  // Formats it as desired.
  print(name.format(r'f $l')); // Jane D

  // Makes it flat.
  print(name.zip()); // Jane D.
}
