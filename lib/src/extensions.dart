/// Extensions

import 'dart:math';

extension StringConcatenation on String {
  String concat(String str) => this + str;
}

extension CharSet<T> on Set<T> {
  T random() => List.from(this).elementAt(Random().nextInt(length)) as T;
}
