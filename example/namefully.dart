import 'package:namefully/namefully.dart';

void main() {
  var name = Namefully.fromMap({'firstName': 'John', 'lastName': 'Snow'});
  print(name.firstName());
}
