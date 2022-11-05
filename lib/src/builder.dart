import 'dart:collection';

import 'config.dart';
import 'core.dart';
import 'name.dart';
import 'validator.dart';

/// An on-the-fly name builder.
///
/// The builder uses a lazy-building method while capturing all necessary [Name]s
/// to finally construct a complete [Namefully] instance.
///
/// ```dart
/// var builder = NameBuilder.of([Name.first('Thomas'), Name.last('Edison')]);
/// builder.add(Name.middle('Alva'));
/// print(builder.build()); // 'Thomas Alva Edison'
/// ```
///
/// Other operations such as adding, removing, clearing content are also allowed
/// at any point during the build.
class NameBuilder extends _Builder<Name, Namefully> {
  NameBuilder._(Iterable<Name> names) {
    addAll(names);
  }

  /// Creates a base builder from one [Name] to construct [Namefully] later.
  NameBuilder([Name? name]) : this._([if (name != null) name]);

  /// Creates a base builder from many [Name]s to construct [Namefully] later.
  NameBuilder.of(Iterable<Name>? initialNames) : this._(initialNames ?? []);

  /// Builds an instance of [Namefully] from the previously collected names.
  ///
  /// Regardless of how the names are added, both first and last names must exist
  /// to complete a fine build. Otherwise, it throws an [NameException].
  @override
  Namefully build([Config? config]) {
    final names = _queue.toList();
    ListNameValidator().validate(names);
    return Namefully.of(names, config: config);
  }
}

/// A generic builder.
abstract class _Builder<T, I> {
  final Queue<T> _queue = Queue<T>();

  /// Removes and returns the first element of this queue.
  ///
  /// The queue must not be empty when this method is called.
  T? removeFirst() => _queue.isNotEmpty ? _queue.removeFirst() : null;

  /// Removes and returns the last element of the queue.
  ///
  /// The queue must not be empty when this method is called.
  T? removeLast() => _queue.isNotEmpty ? _queue.removeLast() : null;

  /// Adds [value] at the beginning of the queue.
  void addFirst(T value) => _queue.addFirst(value);

  /// Adds [value] at the end of the queue.
  void addLast(T value) => _queue.addLast(value);

  /// Adds [value] at the end of the queue.
  void add(T value) => _queue.add(value);

  /// Removes a single instance of [value] from the queue.
  ///
  /// Returns `true` if a value was removed, or `false` if the queue
  /// contained no element equal to [value].
  bool remove(T value) => _queue.remove(value);

  /// Adds all elements of [iterable] at the end of the queue. The
  /// length of the queue is extended by the length of [iterable].
  void addAll(Iterable<T> iterable) => _queue.addAll(iterable);

  /// Removes all elements matched by [test] from the queue.
  ///
  /// The `test` function must not throw or modify the queue.
  void removeWhere(bool Function(T value) test) => _queue.removeWhere(test);

  /// Removes all elements not matched by [test] from the queue.
  ///
  /// The `test` function must not throw or modify the queue.
  void retainWhere(bool Function(T value) test) => _queue.retainWhere(test);

  /// Removes all elements in the queue. The size of the queue becomes zero.
  void clear() => _queue.clear();

  /// Builds the desired [I]nstance.
  I build();
}