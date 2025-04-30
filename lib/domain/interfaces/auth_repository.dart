import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  /// Get the current authenticated user
  Stream<UserModel?> get currentUser;
  
  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated();
  
  /// Sign in with email and password
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(String email, String password);
  
  /// Register a new user
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword(String email, String password, String name, String role);
  
  /// Sign out the current user
  Future<Either<Failure, void>> signOut();
  
  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  
  /// Update user profile
  Future<Either<Failure, UserModel>> updateUserProfile(UserModel user);
  
  /// Update user password
  Future<Either<Failure, void>> updatePassword(String currentPassword, String newPassword);
  
  /// Delete user account
  Future<Either<Failure, void>> deleteAccount(String password);
} 