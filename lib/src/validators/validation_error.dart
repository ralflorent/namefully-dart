class ValidationError extends Error {
  /// Name of the invalid [name] type, if available.
  final String name;

  /// Message describing the problem.
  final String message;

  /// Creates error indicating with a [message] describing the problem.
  ///
  /// For example:
  ///     "Validation failed (firstName)."
  ValidationError([this.message]) : name = null;

  /// Creates error containing the invalid [name] type and a [message] that
  /// briefly describes the problem, if provided. For example:
  ///     "Validation failed (firstName): must be provided"
  ///     "Validation failed (firstName)"
  ValidationError.name(this.name, [this.message]);

  @override
  String toString() {
    var nameString = name == null ? '' : ' ($name)';
    var messageString = message == null ? '' : ': $message';
    return 'Validation failed$nameString$messageString';
  }
}
