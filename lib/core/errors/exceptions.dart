// Server Exceptions
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  ServerException({this.message, this.statusCode});
}

// Cache Exceptions
class CacheException implements Exception {
  final String? message;

  CacheException({this.message});
}

// Network Exceptions
class NetworkException implements Exception {
  final String? message;

  NetworkException({this.message});
}

// Authentication Exceptions
class AuthException implements Exception {
  final String message;
  final AuthErrorType type;

  AuthException({required this.message, required this.type});
}

enum AuthErrorType {
  invalidCredentials,
  userNotFound,
  emailAlreadyInUse,
  weakPassword,
  userDisabled,
  unauthorized,
  sessionExpired,
  other,
}

// Data Exceptions
class DataException implements Exception {
  final String message;

  DataException({required this.message});
}

// Business Logic Exceptions
class InsufficientStockException implements Exception {
  final String materialId;
  final String materialName;
  final double requestedQuantity;
  final double availableQuantity;

  InsufficientStockException({
    required this.materialId,
    required this.materialName,
    required this.requestedQuantity,
    required this.availableQuantity,
  });

  @override
  String toString() {
    return 'Insufficient stock for $materialName. Requested: $requestedQuantity, Available: $availableQuantity';
  }
}

// Feature Specific Exceptions
class QRCodeGenerationException implements Exception {
  final String message;

  QRCodeGenerationException({required this.message});
}

class ReportGenerationException implements Exception {
  final String message;

  ReportGenerationException({required this.message});
} 