import 'dart:async';

import 'namefully.dart';

/// An on-the-fly name builder.
///
/// This builder knows how to take a name from distinct raw forms and build it
/// through a state management mechanism. That is, as the name changes, its
/// states are persisted and notified to any subscriber listening to those
/// changes, thanks to a [StreamController] that broadcasts them.
///
/// The builder starts by creating an initial state of the created name. If a
/// change event occurs to this name, this change is hence viewed as the current
/// name state to consider, and the previous one becomes history. As this works
/// like a state store, this gives a rollback flexibility in case an undesired
/// change is made.
///
/// Once the builder finishes building up the name, the changes are committed
/// and the store is freed as well as the [StreamController] for performance
/// purposes. That means, the builder may no longer change the final name state
/// and should live up to that last change.
///
/// In the following example, a subscriber prints out the different states of
/// the name: `Jane Ann Doe`.
///
/// ```dart
/// var builder = NameBuilder('Jane Ann Doe', config: Config('NameBuilder'))
///   ..stream.listen((d) => print('stream name: $d'))
///   ..shorten()     // stream name: 'Jane Doe'
///   ..upper()       // stream name: 'JANE DOE'
///   ..byLastName()  // stream name: 'DOE JANE'
///   ..lower();      // stream name: 'doe jane'
/// print(builder.build()); // 'doe jane'
/// ```
///
/// **NOTE**: Most of the operations supported in the name builder can be performed
/// with [Namefully.format]. This builder is an expensive operation and should
/// be used in specific use cases, or when judged extremely necessary. Otherwise,
/// keep it sane and simple using the traditional `Namefully` class.
class NameBuilder {
  /// The context in which the name is being built up.
  Namefully _context;

  /// Whether this builder can continue building additional name states.
  bool _done = true;

  /// The state of the changing name.
  final _NamefullyState _state;

  /// The controller providing the on-the-fly updates of the changing name.
  final StreamController<Namefully> _streamer = StreamController<Namefully>();

  /// The name changes made available for listeners.
  Stream<Namefully> get stream => _streamer.stream.asBroadcastStream();

  /// The name for the current context.
  Namefully get name => _context;

  /// Whether the builder is still open for more nesting operations.
  bool get isOpen => _done;

  /// Whether the builder can perform more nesting operations.
  bool get isClosed => !isOpen;

  /// Creates the initial state of the given name.
  NameBuilder._(this._context) : _state = _NamefullyState(_context) {
    _streamer.sink.add(_context);
  }

  /// Creates a name with distinguishable parts from a raw string content.
  ///
  /// An optional [Config]uration may be provided with specifics on how to treat
  /// a full name during its course. By default, all name parts are validated
  /// against some basic validation rules to avoid common runtime exceptions.
  NameBuilder(String names, {Config? config})
      : this._(Namefully(names, config: config));

  /// Creates a name on the fly.
  NameBuilder.only({
    required String firstName,
    List<String>? middleName,
    required String lastName,
    Config? config,
  }) : this._(Namefully.from(FullName.raw(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          config: config,
        )));

  /// Creates a name from a list of distinguishable parts.
  NameBuilder.fromList(List<String> names, {Config? config})
      : this._(Namefully.fromList(names, config: config));

  /// Creates a name from a list of [Name]s.
  ///
  /// [Name] is provided by this utility, representing a namon with some extra
  /// capabilities, compared to a simple string name. This class helps to define
  /// the role of a name part (e.g, prefix) beforehand, which, as a consequence,
  /// gives more flexibility at the time of creating an instance of Namefully.
  NameBuilder.of(List<Name> names, {Config? config})
      : this._(Namefully.of(names, config: config));

  /// Creates a name from a [FullName].
  NameBuilder.from(FullName names, {Config? config})
      : this._(Namefully.from(names));

  /// Creates a name from a json-like distinguishable name parts.
  NameBuilder.fromJson(Map<String, String> names, {Config? config})
      : this._(Namefully.fromJson(names, config: config));

  /// Creates a name from a customized [Parser].
  NameBuilder.fromParser(Parser names, {Config? config})
      : this._(Namefully.fromParser(names, config: config));

  @override
  String toString() {
    return "NameBuilder's current context[" +
        (isClosed ? 'closed' : 'open') +
        ']: $_context';
  }

  /// Arranges the name by [NameOrder.firstName].
  void byFirstName() => _order(NameOrder.firstName);

  /// Arranges the name by [NameOrder.lastName].
  void byLastName() => _order(NameOrder.lastName);

  /// Flips definitely the name order from the current config.
  void flip() {
    if (!_done) throw _builderException(_context.toString(), 'flip');
    _context = Namefully(
      _state.last.full,
      config: _state.last.config.copyWith(),
    )..flip();
    _state.add(_context, id: 'flip');
    _streamer.sink.add(_context);
  }

  /// Shortens a full name to a typical name, a combination of first and last
  /// name.
  ///
  /// See [Namefully.shorten] for more info.
  void shorten() {
    if (!_done) throw _builderException(_context.toString(), 'shorten');
    _context = Namefully(_state.last.shorten(), config: _state.last.config);
    _state.add(_context, id: 'shorten');
    _streamer.sink.add(_context);
  }

  /// Transforms a birth name into UPPERCASE.
  void upper() {
    if (!_done) throw _builderException(_context.toString(), 'upper');
    _context = Namefully(_state.last.upper(), config: _state.last.config);
    _state.add(_context, id: 'upper');
    _streamer.sink.add(_context);
  }

  /// Transforms a birth name into lowercase.
  void lower() {
    if (!_done) throw _builderException(_context.toString(), 'lower');
    _context = Namefully(_state.last.lower(), config: _state.last.config);
    _state.add(_context, id: 'lower');
    _streamer.sink.add(_context);
  }

  /// Returns the final state of the changing name.
  Namefully build() {
    if (!_done) throw _builderException(_context.toString(), 'build');
    close();
    return _context;
  }

  /// Closes this builder on demand.
  void close() {
    _done = false;
    _streamer.close();
    _state.dispose();
  }

  /// Rolls back to the previous context.
  void rollback() {
    if (!_done) throw _builderException(_context.toString(), 'rollback');
    _context = _state.rollback();
    _streamer.sink.add(_context);
  }

  /// Arranges the name [by] the specified order: [NameOrder.firstName] or
  /// [NameOrder.lastName].
  void _order(NameOrder by) {
    var ops = by == NameOrder.firstName ? 'byFirstName' : 'byLastName';
    if (!_done) throw _builderException(_context.toString(), ops);
    _context = Namefully(
      _state.last.fullName(by),
      config: _state.last.config.copyWith(orderedBy: by),
    );
    _state.add(_context, id: ops);
    _streamer.sink.add(_context);
  }
}

NameException _builderException(String source, [String ops = '']) {
  return NotAllowedException(
    source: source,
    message: 'name builder has been closed',
    operation: ops,
  );
}

/// An in-memory name state management.
///
/// The [current] and [previous] states of a name built on the fly are saved in
/// memory, and can be easily accessed through historical data as long as the
/// object persists in memory. An [id] is automatically generated, if none has
/// been provided during its creation.
class _NamefullyState implements _State<Namefully> {
  /// The previous name state.
  @override
  final Namefully? previous;

  /// The current name state.
  @override
  final Namefully current;

  /// A generated state id, if not provided.
  final String id;

  /// The historical name states.
  static final Set<_NamefullyState> _history = {};

  /// The very first name state.
  Namefully get last => _history.last.current;

  /// The very last name state.
  Namefully get first => _history.first.current;

  /// Convenient generative constructor.
  _NamefullyState._(this.id, this.current, this.previous);

  /// Creates an in-memory name state management.
  factory _NamefullyState(Namefully initialState, {String? id}) {
    _history.add(_NamefullyState._(
      id ?? 'state_${_history.length}',
      initialState,
      null,
    ));
    return _history.last;
  }

  /// Adds a new name state.
  @override
  void add(Namefully current, {String? id}) {
    _history.add(_NamefullyState._(
      id ?? 'state_${_history.length}',
      current,
      _history.last.current,
    ));
  }

  /// Performs rollback on existing values only until the very first one.
  @override
  Namefully rollback() {
    if (_history.length > 1) {
      _history.remove(_history.last);
      return last;
    }
    return first;
  }

  /// Clears the memory.
  @override
  void dispose() => _history.clear();
}

/// A lightweight state management approach.
abstract class _State<T> {
  T? get previous;

  T get current;

  void add(T state);

  T rollback();

  void dispose();
}
