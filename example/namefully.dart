import 'package:namefully/namefully.dart';

void main() {
  var name =
      Namefully('John,Snow', config: Config.inline(separator: Separator.comma));
  print(name.firstName());
}
