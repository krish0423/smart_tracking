import 'package:dartz/dartz.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/domain/entities/user.dart';

abstract class AuthRepository {
  /// Get the current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email, 
    String password,
  );

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Register a new user with email and password
  Future<Either<Failure, User>> registerWithEmailAndPassword(
    String name,
    String email, 
    String password,
    UserRole role,
  );

  /// Update user profile
  Future<Either<Failure, User>> updateUserProfile(
    String userId,
    {
      String? name,
      String? email,
      String? photoUrl,
    }
  );

  /// Update user password
  Future<Either<Failure, void>> updatePassword(
    String currentPassword,
    String newPassword,
  );

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  
  /// Check if user is signed in
  Future<bool> isSignedIn();
  
  /// Get auth state changes stream
  Stream<User?> get authStateChanges;
} 