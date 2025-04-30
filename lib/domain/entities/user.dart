import 'package:equatable/equatable.dart';

enum UserRole {
  admin,
  operator,
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    required this.createdAt,
    required this.lastLogin,
    this.isActive = true,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isOperator => role == UserRole.operator;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        photoUrl,
        createdAt,
        lastLogin,
        isActive,
      ];
} 