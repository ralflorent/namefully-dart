import 'package:namefully/namefully.dart';

void main() {
  var name = Namefully('Mr,John,Novak,Snow',
      config: Config.inline(separator: Separator.comma, titling: AbbrTitle.us));
  print(name.fullName());
  print(name.birthName(NameOrder.lastName));
  print(name.initials(withMid: true));
  print(name.format('f L'));
}
