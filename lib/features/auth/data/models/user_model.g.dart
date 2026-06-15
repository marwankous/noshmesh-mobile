// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  planId: (json['plan_id'] as num).toInt(),
  uuid: json['UUID'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  status: json['status'] as String,
  subscriptionStatus: json['subscription_status'] as String,
  subscriptionExpirationDate: json['subscription_expiration_date'] == null
      ? null
      : DateTime.parse(json['subscription_expiration_date'] as String),
  appUserId: json['app_user_id'] as String?,
  monthlyTokensUsed: (json['monthly_tokens_used'] as num).toInt(),
  tokenResetDate: DateTime.parse(json['token_reset_date'] as String),
  plan: PlanModel.fromJson(json['plan'] as Map<String, dynamic>),
  verifiedAt: json['verified_at'] == null
      ? null
      : DateTime.parse(json['verified_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'plan_id': instance.planId,
  'UUID': instance.uuid,
  'name': instance.name,
  'email': instance.email,
  'status': instance.status,
  'subscription_status': instance.subscriptionStatus,
  'subscription_expiration_date': instance.subscriptionExpirationDate
      ?.toIso8601String(),
  'app_user_id': instance.appUserId,
  'monthly_tokens_used': instance.monthlyTokensUsed,
  'token_reset_date': instance.tokenResetDate.toIso8601String(),
  'plan': instance.plan,
  'verified_at': instance.verifiedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
