import 'package:namefully/name_builder.dart';
import 'package:namefully/namefully.dart';

void main() {
  // Gives a simple name some super power.
  final builder = NameBuilder('Jane Ann Doe', config: Config('NameBuilder'))

    // Broadcasts the changes while building a name.
    ..stream.listen((d) => print('stream name: $d'))

    // Makes it now short.
    ..shorten() // stream name: 'Jane Doe'

    // Makes it now uppercase.
    ..upper() // stream name: 'JANE DOE'

    // Reorders it now by last name.
    ..byLastName() // stream name: 'DOE JANE'

    // Makes it now lowercase.
    ..lower(); // stream name: 'doe jane'

  // Completes the final build and closes the current name context.
  final name = builder.build();

  // Gets the count of characters, excluding space.
  print(name.count); // 7

  // Gets the count of characters, including space.
  print(name.length); // 8

  // Gets the first name.
  print(name.first); // jane

  // Gets the first middle name.
  print(name.middle); // doe

  // Gets the last name.
  print(name.last); // null

  // Gets all the initials.
  print(name.initials(withMid: true)); // ['d', 'j']

  // Formats as desired.
  print(name.format(r'f $l.')); // jane d.

  try {
    // Builder's context is already closed, therefore will throw an exception.
    builder.byFirstName();
  } on NameException catch (exception) {
    print(exception); // should catch a `NotAllowedException`.
  } finally {
    print(builder); // the name context stays the same.
  }
}
