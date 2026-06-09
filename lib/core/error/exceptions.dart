// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}