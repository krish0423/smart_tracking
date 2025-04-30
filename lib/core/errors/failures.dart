import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int code;

  const Failure({required this.message, required this.code});

  @override
  List<Object> get props => [message, code];
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    required int code,
  }) : super(message: message, code: code);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Network connection failed. Please check your internet connection.',
    int code = 0,
  }) : super(message: message, code: code);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache operation failed.',
    int code = 0,
  }) : super(message: message, code: code);
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    int code = 401,
  }) : super(message: message, code: code);
  
  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password.',
    code: 401,
  );
  
  factory AuthFailure.userNotFound() => const AuthFailure(
    message: 'User not found.',
    code: 404,
  );
  
  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    message: 'Email is already in use.',
    code: 409,
  );
  
  factory AuthFailure.weakPassword() => const AuthFailure(
    message: 'Password is too weak.',
    code: 400,
  );
  
  factory AuthFailure.userDisabled() => const AuthFailure(
    message: 'This user has been disabled.',
    code: 403,
  );
  
  factory AuthFailure.unauthorized() => const AuthFailure(
    message: 'You are not authorized to perform this action.',
    code: 403,
  );
  
  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: 'Your session has expired. Please sign in again.',
    code: 401,
  );
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    int code = 400,
  }) : super(message: message, code: code);
}

/// Data-related failures
class DataFailure extends Failure {
  const DataFailure({
    required String message,
    int code = 500,
  }) : super(message: message, code: code);
  
  factory DataFailure.notFound() => const DataFailure(
    message: 'The requested data was not found.',
    code: 404,
  );
  
  factory DataFailure.alreadyExists() => const DataFailure(
    message: 'The data already exists.',
    code: 409,
  );
  
  factory DataFailure.invalidOperation() => const DataFailure(
    message: 'Invalid operation on the data.',
    code: 400,
  );
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    String message = 'Permission denied.',
    int code = 403,
  }) : super(message: message, code: code);
}

/// Offline operation failures
class OfflineOperationFailure extends Failure {
  const OfflineOperationFailure({
    String message = 'Operation failed while offline.',
    int code = 0,
  }) : super(message: message, code: code);
}

/// Document scanning failures
class ScanFailure extends Failure {
  const ScanFailure({
    String message = 'Scanning operation failed.',
    int code = 0,
  }) : super(message: message, code: code);
  
  factory ScanFailure.cameraPermissionDenied() => const ScanFailure(
    message: 'Camera permission denied. Please enable camera access in settings.',
    code: 403,
  );
  
  factory ScanFailure.invalidBarcode() => const ScanFailure(
    message: 'Invalid barcode format.',
    code: 400,
  );
  
  factory ScanFailure.invalidQRCode() => const ScanFailure(
    message: 'Invalid QR code format.',
    code: 400,
  );
}

/// Report generation failures
class ReportFailure extends Failure {
  const ReportFailure({
    String message = 'Report generation failed.',
    int code = 500,
  }) : super(message: message, code: code);
} 