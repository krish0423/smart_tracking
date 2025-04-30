import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UsersRepository {
  /// Get all users
  Future<Either<Failure, List<UserModel>>> getAllUsers();
  
  /// Get active users
  Future<Either<Failure, List<UserModel>>> getActiveUsers();
  
  /// Get users by role
  Future<Either<Failure, List<UserModel>>> getUsersByRole(String role);
  
  /// Get user by ID
  Future<Either<Failure, UserModel>> getUserById(String id);
  
  /// Add new user
  Future<Either<Failure, UserModel>> addUser(UserModel user, String password);
  
  /// Update user
  Future<Either<Failure, UserModel>> updateUser(UserModel user);
  
  /// Delete user
  Future<Either<Failure, void>> deleteUser(String id);
  
  /// Deactivate user
  Future<Either<Failure, UserModel>> deactivateUser(String id);
  
  /// Activate user
  Future<Either<Failure, UserModel>> activateUser(String id);
  
  /// Reset user password
  Future<Either<Failure, void>> resetUserPassword(String id);
  
  /// Change user role
  Future<Either<Failure, UserModel>> changeUserRole(String id, String newRole);
  
  /// Get user performance metrics
  Future<Either<Failure, UserPerformanceMetrics>> getUserPerformanceMetrics(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
}

/// User performance metrics model
class UserPerformanceMetrics {
  final String userId;
  final String userName;
  final int totalScans;
  final int totalConsumptionLogs;
  final double totalMaterialsConsumed;
  final double totalCost;
  final Map<String, double> materialConsumptionBreakdown;
  final Map<String, int> activityByDay;

  UserPerformanceMetrics({
    required this.userId,
    required this.userName,
    required this.totalScans,
    required this.totalConsumptionLogs,
    required this.totalMaterialsConsumed,
    required this.totalCost,
    required this.materialConsumptionBreakdown,
    required this.activityByDay,
  });
} 