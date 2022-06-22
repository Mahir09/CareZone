class CustomExceptions implements Exception {
  final String message;

  CustomExceptions(this.message);

  @override
  String toString() {
    return message;
  }
}
