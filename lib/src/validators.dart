/// Validators

class ValidationError extends Error {
  /// Name of the invalid [name] type, if available.
  final String name;

  /// Message describing the problem.
  final String message;

  /// Creates error containing the invalid [name] type and a [message] that
  /// briefly describes the problem, if provided. For example:
  ///     "Validation failed (firstName): Must be provided."
  ValidationError([this.name, this.message]);

  /// Creates error indicating which [name] type throws it.
  ///
  /// For example:
  ///     "Validation failed (firstName)."
  ValidationError.name([this.name]) : message = null;

  @override
  String toString() {
    var nameString = name == null ? '' : ' ($name)';
    var messageString = message == null ? '' : ': $message';
    return 'Validation failed$nameString$messageString';
  }
}
