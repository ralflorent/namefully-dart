import 'package:namefully/namefully.dart';

void main() {
  var namefully = Namefully('Jon Snow');
  print(namefully.birthName(NameOrder.lastName));
}
