class PasswordException extends FormatException {
  const PasswordException({required this.error}) : super(error);
  final String error;
}
