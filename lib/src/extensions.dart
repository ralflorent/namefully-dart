/// Extensions

import 'dart:math';

extension StringConcatenation on String {
  String concat(String str) {
    return this + str;
  }
}

extension CharSet<T> on Set<T> {
  T random() {
    return List.from(this).elementAt(Random().nextInt(length)) as T;
  }
}
