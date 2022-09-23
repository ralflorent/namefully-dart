import 'package:namefully/namefully.dart';

void main() {
  // Gives a simple name some super power.
  var name = Namefully('Thomas Alva Edison');

  // Gets the count of characters, including space.
  print(name.length); // 18

  // Gets the first name.
  print(name.first); // Thomas

  // Gets the first middle name.
  print(name.middle); // Alva

  // Gets the last name.
  print(name.last); // Edison

  // Controls what the public sees.
  print(name.public); // Thomas E

  // Gets all the initials.
  print(name.initials(withMid: true)); // ['T', 'A', 'E']

  // Formats it as desired.
  print(name.format('L, f m')); // EDISON, Thomas Alva

  // Makes it short.
  print(name.shorten()); // Thomas Edison

  // Makes it flat.
  print(name.zip()); // Thomas A. E.

  // Makes it uppercase.
  print(name.upper()); // THOMAS ALVA EDISON

  // Transforms it into dot.case.
  print(name.dot()); // thomas.alva.edison

  // Gives you more control.
  var hashtag = name.parts
      .where((part) => !part.isMiddleName) // get rid of middle names
      .fold('#', (prev, curr) => prev.toString() + curr.value);
  print(hashtag); // #ThomasEdison
}
