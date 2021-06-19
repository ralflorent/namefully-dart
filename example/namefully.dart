import 'package:namefully/namefully.dart';

void main() {
  // Gives a simple name some super power.
  var name = Namefully('Jon Stark Snow');

  // Gets the count of characters, excluding space.
  print(name.count); // 12

  // Gets the count of characters, including space.
  print(name.length); // 14

  // Gets the first name.
  print(name.first); // Jon

  // Gets the first middle name.
  print(name.middle); // Stark

  // Gets the last name.
  print(name.last); // Snow

  // Gets all the initials.
  print(name.initials(withMid: true)); // ['J', 'S', 'S']

  // Formats as desired.
  print(name.format('L, f m')); // SNOW, Jon Stark
  print(name.format(r'f $l.')); // Jon S.

  // Make it short.
  print(name.shorten()); // Jon Snow

  // Make it flat.
  print(name.zip()); // Jon S. S.

  // Make it uppercase.
  print(name.upper()); // JON STARK SNOW

  // Transforms it to dot.case.
  print(name.dot()); // jon.stark.snow
}
