import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

void main() {
  group('Test Suite', () {
    var name = Namefully('Jon Snow');

    setUp(() {
      name = Namefully('Jon Snow');
    });

    test('First Test', () {
      expect(name.firstName(), 'Jon');
    });
  });
}
