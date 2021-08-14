import 'names.dart';

/// The [Exception] types supported by [Namefully].
enum NameExceptionType {
  /// Thrown when a name entry/argument is incorrect.
  ///
  /// For example, a name should have a minimum of 2 characters, so an empty
  /// string or a string of one character would cause this kind of exception.
  input,

  /// Thrown when the name components don't match the validation rules if the
  /// [Config.bypass] is not flagged up. This bypass option skips the validation
  /// rules.
  ///
  /// See also:
  ///   * [ValidationException]
  ///   * [Validators]
  validation,

  /// Thrown when a closed name builder tries to perform an operation.
  ///
  /// See also:
  ///   * [NotAllowedException]
  ///   * [NameBuilder]
  notAllowed,

  /// Thrown by any other unknown sources or unexpected situation.
  unknown,
}

/// Base class for all name-related exceptions.
///
/// An [Exception] is intended to convey information to the user about a failure,
/// so that the error can be addressed programmatically.
///
/// A name handling failure is not considered an error that should cause a program
/// failure. Au contraire, it is expected that a programmer using this utility
/// would consider validating a name using its own business rules. That is not
/// this utility's job to guess those rules. So, the predefined [ValidationRule]s
/// obey to some common validation techniques when it comes to sanitizing a
/// person name. For this reason, the [Config.bypass] is set to `true` by
/// default, indicating that those predefined rules should be skipped for the
/// sake of the program.
///
/// A programmer may leverage [Parser]s to indicate business-tailored rules if
/// he or she wants this utility to perform those safety checks behind the
/// scenes.
///
/// A name exception intends to provide useful information about what causes
/// the error and let the user take initiative on what happens next to the given
/// name: reconstructing it or skipping it.
abstract class NameException implements Exception {
  /// Enables const constructors.
  const NameException([this.source, this.message = '']);

  /// Creates a new `InputException` with an optional error [message].
  factory NameException.input({required Object source, String message = ''}) {
    return InputException(source: source, message: message);
  }

  /// Creates an error containing the invalid [nameType] and a [message] that
  /// briefly describes the problem if provided.
  factory NameException.validation({
    required Object source,
    required String nameType,
    String message = '',
  }) {
    return ValidationException(
      source: source,
      nameType: nameType,
      message: message,
    );
  }

  /// Creates a new `NotAllowedException` with an optional error [message].
  factory NameException.notAllowed({
    required Object source,
    String message = '',
  }) {
    return NotAllowedException(source: source, message: message);
  }

  /// Creates a new `UnknownException` with an optional error [message].
  ///
  /// Optionally, a [stackTrace] and an [error] revealing the true nature of
  /// the failure.
  factory NameException.unknown({
    required Object source,
    StackTrace? stackTrace,
    Object? error,
    String message = '',
  }) {
    return UnknownException(
      source: source,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// The message describing the failure.
  final String message;

  /// The actual source input which caused the error.
  final dynamic source;

  /// The name exception type.
  NameExceptionType get type;

  /// The string value from the name source input.
  String get sourceAsString {
    var input = '';

    if (source == null) input = 'null';
    if (source is String) input = source as String;
    if (source is List<String>) input = (source as List<String>).join(' ');
    if (source is Name) input = (source as Name).toString();
    if (source is List<Name>) {
      input = (source as List<Name>).map((n) => n.toString()).join(' ');
    }

    return input;
  }

  @override
  String toString() {
    var report = '$runtimeType ($sourceAsString)';
    if (message.isNotEmpty) report = '$report: $message';
    return report;
  }
}

/// An exception thrown when a name source input is incorrect.
///
/// A [Name] is a name for this utility under certain criteria (i.e., 2+ chars),
/// hence, a wrong input will cause this kind of exception. Another common reason
/// may be a wrong key in a Json name parsing mechanism.
///
/// Keep in mind that this exception is different from a [ValidationException].
class InputException extends NameException {
  /// Creates a new `InputException` with an optional error [message].
  ///
  /// The [source] is by nature a string content, maybe wrapped up in a different
  /// type. This string value may be extracted to form the following output:
  ///   "InputException (stringName)",
  ///   "InputException (stringName): message".
  const InputException({required this.source, this.message = ''});

  @override
  final String message;

  @override
  final Object source;

  @override
  NameExceptionType get type => NameExceptionType.input;
}

/// An exception thrown to indicate that a name fails the validation rules.
class ValidationException extends NameException {
  /// Creates error containing the invalid [nameType] and a [message] that
  /// briefly describes the problem if provided.
  ///
  /// For example, a validation error can be interpreted as:
  ///     "ValidationException (nameType=='stringName')",
  ///     "ValidationException (nameType='stringName'): message"
  const ValidationException({
    required this.source,
    required this.nameType,
    this.message = '',
  });

  @override
  final String message;

  @override
  final Object source;

  /// Name of the invalid `nameType` if available.
  final String nameType;

  @override
  NameExceptionType get type => NameExceptionType.validation;

  @override
  String toString() {
    var report = "ValidationException ($nameType='$sourceAsString')";
    if (message.isNotEmpty) report = '$report: $message';
    return report;
  }
}

/// An exception when a [NameBuilder] tries to perform an operation while its
/// current status is marked as closed.
class NotAllowedException extends NameException {
  /// Creates a new `NotAllowedException` with an optional error [message].
  const NotAllowedException({required this.source, this.message = ''});

  @override
  final String message;

  @override
  final Object source;

  @override
  NameExceptionType get type => NameExceptionType.notAllowed;
}

/// A fallback exception thrown by any unknown sources or unexpected failure
/// that are not [NameException]s.
///
/// In this particular case, a [stackTrace] remains useful as it provides details
/// on the sources and the true nature of the [error].
/// At this point, deciding whether to exit the program or not depends on the
/// programmer.
class UnknownException extends NameException {
  /// Creates a new `UnknownException` with an optional error [message].
  ///
  /// Optionally, a [stackTrace] and an [error] revealing the true nature of
  /// the failure.
  const UnknownException({
    required this.source,
    this.stackTrace,
    this.error,
    this.message = '',
  });

  @override
  final String message;

  @override
  final Object source;

  /// Trace revealing the source of that error.
  final StackTrace? stackTrace;

  /// The possible unknown error.
  final Object? error;

  @override
  NameExceptionType get type => NameExceptionType.unknown;

  @override
  String toString() {
    var report = super.toString();
    if (error != null) report += '\n$error';
    if (stackTrace != null) report += '\n$stackTrace';

    return report;
  }
}
