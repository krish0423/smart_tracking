import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'offline_queue_item_model.g.dart';

/// Types of operations that can be queued
@HiveType(typeId: 7)
enum OfflineOperationType {
  @HiveField(0)
  create,
  
  @HiveField(1)
  update,
  
  @HiveField(2)
  delete,
  
  @HiveField(3)
  scan,
}

/// Types of entities that can be operated on
@HiveType(typeId: 8)
enum OfflineEntityType {
  @HiveField(0)
  material,
  
  @HiveField(1)
  product,
  
  @HiveField(2)
  user,
  
  @HiveField(3)
  consumptionLog,
}

@HiveType(typeId: 9)
class OfflineQueueItemModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final OfflineOperationType operationType;
  
  @HiveField(2)
  final OfflineEntityType entityType;
  
  @HiveField(3)
  final Map<String, dynamic> data;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final int retryCount;
  
  @HiveField(6)
  final bool isPriority;
  
  @HiveField(7)
  final DateTime? lastRetryAt;
  
  @HiveField(8)
  final String? errorMessage;

  const OfflineQueueItemModel({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.isPriority = false,
    this.lastRetryAt,
    this.errorMessage,
  });
  
  // Factory constructor to create an OfflineQueueItemModel from a JSON map
  factory OfflineQueueItemModel.fromJson(Map<String, dynamic> json) {
    return OfflineQueueItemModel(
      id: json['id'] as String,
      operationType: OfflineOperationType.values.firstWhere(
        (e) => e.toString() == json['operationType'],
        orElse: () => OfflineOperationType.create,
      ),
      entityType: OfflineEntityType.values.firstWhere(
        (e) => e.toString() == json['entityType'],
        orElse: () => OfflineEntityType.material,
      ),
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      isPriority: json['isPriority'] as bool? ?? false,
      lastRetryAt: json['lastRetryAt'] != null
          ? DateTime.parse(json['lastRetryAt'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
    );
  }
  
  // Convert OfflineQueueItemModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operationType': operationType.toString(),
      'entityType': entityType.toString(),
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'isPriority': isPriority,
      'lastRetryAt': lastRetryAt?.toIso8601String(),
      'errorMessage': errorMessage,
    };
  }
  
  // Create a copy of OfflineQueueItemModel with some fields replaced
  OfflineQueueItemModel copyWith({
    String? id,
    OfflineOperationType? operationType,
    OfflineEntityType? entityType,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    bool? isPriority,
    DateTime? lastRetryAt,
    String? errorMessage,
  }) {
    return OfflineQueueItemModel(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      isPriority: isPriority ?? this.isPriority,
      lastRetryAt: lastRetryAt ?? this.lastRetryAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  // Increment retry count
  OfflineQueueItemModel incrementRetry([String? error]) {
    return copyWith(
      retryCount: retryCount + 1,
      lastRetryAt: DateTime.now(),
      errorMessage: error,
    );
  }
  
  // Mark as priority
  OfflineQueueItemModel markAsPriority() {
    return copyWith(isPriority: true);
  }
  
  @override
  List<Object?> get props => [
    id,
    operationType,
    entityType,
    data,
    createdAt,
    retryCount,
    isPriority,
    lastRetryAt,
    errorMessage,
  ];
} 