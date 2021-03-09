import 'package:namefully/namefully.dart';

void main() {
  var name = Namefully('Jon Stark Snow');
  print(name.format('L, f m')); // SNOW, Jon Stark
  print(name.shorten()); // Jon Snow
  print(name.zip()); // Jon S. S.
}
