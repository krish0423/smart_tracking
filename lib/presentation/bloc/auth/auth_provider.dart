import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_tracking_app/core/constants/app_constants.dart';
import 'package:smart_tracking_app/core/errors/failures.dart';
import 'package:smart_tracking_app/data/models/user_model.dart';
import 'package:smart_tracking_app/domain/interfaces/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:smart_tracking_app/domain/entities/user.dart' as app_entity;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AuthStatus _status = AuthStatus.unknown;
  app_entity.User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  StreamSubscription? _authSubscription;
  
  // Getters
  AuthStatus get status => _status;
  app_entity.User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isAdmin => _user?.role == app_entity.UserRole.admin;
  bool get isOperator => _user?.role == app_entity.UserRole.operator;
  
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
    
    try {
      // For demo accounts, allow hardcoded credentials
      if (_isDemoAccount(email, password)) {
        await _handleDemoLogin(email);
        return true;
      }

      // Normal Firebase authentication
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _fetchUserData(userCredential.user!.uid);
        return true;
      } else {
        _setError('Failed to login. Please try again.');
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      _handleAuthError(e);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
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
    
    try {
      await _firebaseAuth.signOut();
      _user = null;
      return true;
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
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
  
  // Fetch user data from Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        final data = doc.data()!;
        _user = app_entity.User(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          role: _parseRole(data['role']),
          photoUrl: data['photoUrl'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          lastLogin: DateTime.now(),
          isActive: data['isActive'] ?? true,
        );
        
        // Update last login time
        await _firestore.collection('users').doc(uid).update({
          'lastLogin': Timestamp.now(),
        });
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      _setError('Failed to fetch user data');
      _user = null;
    }
    
    notifyListeners();
  }
  
  // Parse role from string to enum
  app_entity.UserRole _parseRole(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case 'admin':
        return app_entity.UserRole.admin;
      case 'operator':
        return app_entity.UserRole.operator;
      default:
        return app_entity.UserRole.operator; // Default to operator
    }
  }
  
  // Demo account handling for testing purposes
  bool _isDemoAccount(String email, String password) {
    return (email == 'admin@smartfab.com' && password == 'admin123') || 
           (email == 'operator@smartfab.com' && password == 'operator123');
  }
  
  Future<void> _handleDemoLogin(String email) async {
    if (email == 'admin@smartfab.com') {
      _user = app_entity.User(
        id: 'admin-demo-id',
        name: 'Admin Demo',
        email: email,
        role: app_entity.UserRole.admin,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastLogin: DateTime.now(),
      );
    } else if (email == 'operator@smartfab.com') {
      _user = app_entity.User(
        id: 'operator-demo-id',
        name: 'Operator Demo',
        email: email,
        role: app_entity.UserRole.operator,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastLogin: DateTime.now(),
      );
    }
    notifyListeners();
  }
  
  // Error handling
  void _handleAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        _setError('Invalid email or password');
        break;
      case 'user-disabled':
        _setError('This account has been disabled');
        break;
      case 'too-many-requests':
        _setError('Too many login attempts. Please try again later');
        break;
      default:
        _setError('Authentication failed: ${e.message}');
    }
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