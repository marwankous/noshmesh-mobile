import 'package:noshmesh/features/auth/data/models/plan_model.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final int id;
  final int planId;
  @JsonKey(name: 'UUID')
  final String uuid;
  final String name;
  final String email;
  final String status;
  final String subscriptionStatus;
  final DateTime? subscriptionExpirationDate;
  final String? appUserId;
  final int monthlyTokensUsed;
  final DateTime tokenResetDate;
  final PlanModel plan;
  final DateTime? verifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Factory constructor to convert UserEntity to UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      planId: entity.planId,
      uuid: entity.uuid,
      name: entity.name,
      email: entity.email,
      status: entity.status,
      subscriptionStatus: entity.subscriptionStatus,
      subscriptionExpirationDate: entity.subscriptionExpirationDate,
      appUserId: entity.appUserId,
      monthlyTokensUsed: entity.monthlyTokensUsed,
      tokenResetDate: entity.tokenResetDate,
      plan: PlanModel.fromEntity(entity.plan),
      verifiedAt: entity.verifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

// Extension to convert UserModel to UserEntity
extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      planId: planId,
      uuid: uuid,
      name: name,
      email: email,
      status: status,
      subscriptionStatus: subscriptionStatus,
      subscriptionExpirationDate: subscriptionExpirationDate,
      appUserId: appUserId,
      monthlyTokensUsed: monthlyTokensUsed,
      tokenResetDate: tokenResetDate,
      plan: plan.toEntity(),
      verifiedAt: verifiedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
