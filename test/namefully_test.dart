import 'package:namefully/namefully.dart';
import 'package:test/test.dart';

void main() {
  group('Test Suite', () {
    Namefully namefully;

    setUp(() {
      namefully = Namefully('');
    });

    test('First Test', () {
      expect(namefully.fullName(), 'namefully');
    });
  });
}
