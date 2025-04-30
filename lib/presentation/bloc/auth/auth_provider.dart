import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_tracking_app/core/constants/app_constants.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:smart_tracking_app/domain/interfaces/auth_repository.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;
  StreamSubscription? _authSubscription;
  
  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.role == AppConstants.roleAdmin;
  bool get isOperator => _user?.role == AppConstants.roleOperator;
  
  AuthProvider({required AuthRepository authRepository}) 
      : _authRepository = authRepository {
    _init();
  }
  
  // Initialize auth state
  void _init() {
    _authSubscription = _authRepository.currentUser.listen((user) {
      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        _user = null;
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }
  
  // Update with new auth repository (for provider proxy)
  void update(AuthRepository authRepository) {
    // Nothing to do here as we already have the repository
  }
  
  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.signInWithEmailAndPassword(email, password);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Register new user
  Future<bool> register(String email, String password, String name, String role) async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.registerWithEmailAndPassword(email, password, name, role);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Sign out
  Future<bool> signOut() async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.signOut();
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.sendPasswordResetEmail(email);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        return true;
      },
    );
  }
  
  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.updateUserProfile(updatedUser);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }
  
  // Update password
  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    _setLoading(true);
    _clearError();
    
    final result = await _authRepository.updatePassword(currentPassword, newPassword);
    
    return result.fold(
      (failure) {
        _setError(failure.message);
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        return true;
      },
    );
  }
  
  // Check if user has permission
  bool hasPermission(String permission) {
    return _user?.permissions.contains(permission) ?? false;
  }
  
  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
} 