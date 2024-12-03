class EmailException extends FormatException {
  final String error;

  EmailException({required this.error}) : super(error);
}
