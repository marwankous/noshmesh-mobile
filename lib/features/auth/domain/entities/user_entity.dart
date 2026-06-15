import 'package:noshmesh/features/auth/domain/entities/plan_entity.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final int planId;
  final String uuid;
  final String name;
  final String email;
  final String status;
  final String subscriptionStatus;
  final DateTime? subscriptionExpirationDate;
  final String? appUserId;
  final int monthlyTokensUsed;
  final DateTime tokenResetDate;
  final PlanEntity plan;
  final DateTime? verifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.planId,
    required this.uuid,
    required this.name,
    required this.email,
    required this.status,
    required this.subscriptionStatus,
    this.subscriptionExpirationDate,
    this.appUserId,
    required this.monthlyTokensUsed,
    required this.tokenResetDate,
    required this.plan,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    planId,
    uuid,
    name,
    email,
    status,
    subscriptionStatus,
    subscriptionExpirationDate,
    appUserId,
    monthlyTokensUsed,
    tokenResetDate,
    plan,
    verifiedAt,
    createdAt,
    updatedAt,
  ];

  // Factory constructor to create an empty user
  factory UserEntity.empty() {
    return UserEntity(
      id: 0,
      planId: 0,
      uuid: '',
      name: '',
      email: '',
      status: '',
      subscriptionStatus: 'free',
      monthlyTokensUsed: 0,
      tokenResetDate: DateTime.now(),
      plan: PlanEntity.empty(),
    );
  }

  // CopyWith method for creating a new instance with some updated properties
  UserEntity copyWith({
    int? id,
    int? planId,
    String? uuid,
    String? name,
    String? email,
    String? status,
    String? subscriptionStatus,
    DateTime? subscriptionExpirationDate,
    String? appUserId,
    int? monthlyTokensUsed,
    DateTime? tokenResetDate,
    PlanEntity? plan,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpirationDate: subscriptionExpirationDate ?? this.subscriptionExpirationDate,
      appUserId: appUserId ?? this.appUserId,
      monthlyTokensUsed: monthlyTokensUsed ?? this.monthlyTokensUsed,
      tokenResetDate: tokenResetDate ?? this.tokenResetDate,
      plan: plan ?? this.plan,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Method to check if user is empty
  bool get isEmpty => id == 0 && uuid.isEmpty && name.isEmpty && email.isEmpty;
  bool get isNotEmpty => !isEmpty;

  // Check if user has a pro subscription
  bool get isPro => subscriptionStatus.toLowerCase() == 'pro' || plan.name.toLowerCase() == 'pro';
}
