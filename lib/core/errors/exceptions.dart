class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class DataException implements Exception {
  final String message;

  DataException(this.message);
}
