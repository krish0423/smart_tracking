import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String role;
  
  @HiveField(4)
  final String? photoUrl;
  
  @HiveField(5)
  final String department;
  
  @HiveField(6)
  final List<String> permissions;
  
  @HiveField(7)
  final DateTime createdAt;
  
  @HiveField(8)
  final DateTime? lastLogin;
  
  @HiveField(9)
  final bool isActive;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
    required this.department,
    required this.permissions,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });
  
  // Factory constructor to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      photoUrl: json['photoUrl'] as String?,
      department: json['department'] as String,
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: (json['createdAt'] != null)
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastLogin: (json['lastLogin'] != null)
          ? (json['lastLogin'] as Timestamp).toDate()
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
  
  // Convert UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'department': department,
      'permissions': permissions,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'isActive': isActive,
    };
  }
  
  // Create a copy of UserModel with some fields replaced
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? photoUrl,
    String? department,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      department: department ?? this.department,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    photoUrl,
    department,
    permissions,
    createdAt,
    lastLogin,
    isActive,
  ];
}

// Mock Timestamp class for compatibility with Firestore
class Timestamp {
  final int seconds;
  final int nanoseconds;
  
  Timestamp(this.seconds, this.nanoseconds);
  
  factory Timestamp.fromDate(DateTime date) {
    final int seconds = (date.millisecondsSinceEpoch / 1000).floor();
    final int nanoseconds = ((date.millisecondsSinceEpoch % 1000) * 1000000).floor();
    return Timestamp(seconds, nanoseconds);
  }
  
  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
} 