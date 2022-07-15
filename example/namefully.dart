import 'package:namefully/namefully.dart';

void main() {
  // Gives a simple name some super power.
  var name = Namefully('Jon Stark Snow');

  // Gets the count of characters, including space.
  print(name.length); // 14

  // Gets the first name.
  print(name.first); // Jon

  // Gets the first middle name.
  print(name.middle); // Stark

  // Gets the last name.
  print(name.last); // Snow

  // Controls what the public sees.
  print(name.public); // Jon S

  // Gets all the initials.
  print(name.initials(withMid: true)); // ['J', 'S', 'S']

  // Formats it as desired.
  print(name.format('L, f m')); // SNOW, Jon Stark

  // Makes it short.
  print(name.shorten()); // Jon Snow

  // Makes it flat.
  print(name.zip()); // Jon S. S.

  // Makes it uppercase.
  print(name.upper()); // JON STARK SNOW

  // Transforms it into dot.case.
  print(name.dot()); // jon.stark.snow

  // Gives you more control.
  var hashtag = name.parts
      .where((part) => !part.isMiddleName) // get rid of middle names
      .fold('#', (prev, curr) => prev.toString() + curr.value);
  print(hashtag); // #JonSnow
}
