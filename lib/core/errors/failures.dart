import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

/// Server-related failures
class ServerFailure extends Failure {}

/// Network-related failures
class InternetConnectionFailure extends Failure {}

/// Cache-related failures
class CacheFailure extends Failure {}

/// Authentication-related failures
class AuthenticationFailure extends Failure {}
class PermissionDeniedFailure extends Failure {}
class UserNotFoundFailure extends Failure {}
class InvalidCredentialsFailure extends Failure {}

/// Input validation failures
class DataValidationFailure extends Failure {
  final String message;

  DataValidationFailure({required this.message});

  @override
  List<Object> get props => [message];
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
class ReportGenerationFailure extends Failure {
  const ReportFailure({
    String message = 'Report generation failed.',
    int code = 500,
  }) : super(message: message, code: code);
}

/// Business logic failures
class InsufficientStockFailure extends Failure {}
class ProductionFailure extends Failure {}

/// Generic failures
class UnexpectedFailure extends Failure {} 