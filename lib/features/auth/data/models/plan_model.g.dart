// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  maxMonthlyTokens: (json['max_monthly_tokens'] as num).toInt(),
  maxFeedSubscriptions: (json['max_feed_subscriptions'] as num).toInt(),
  maxArticlesPerMerge: (json['max_articles_per_merge'] as num).toInt(),
  maxExternalEndpoints: (json['max_external_endpoints'] as num).toInt(),
  priceMonthly: json['price_monthly'] as String?,
  priceYearly: json['price_yearly'] as String?,
  revenuecatEntitlementId: json['revenuecat_entitlement_id'] as String?,
);

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'max_monthly_tokens': instance.maxMonthlyTokens,
  'max_feed_subscriptions': instance.maxFeedSubscriptions,
  'max_articles_per_merge': instance.maxArticlesPerMerge,
  'max_external_endpoints': instance.maxExternalEndpoints,
  'price_monthly': instance.priceMonthly,
  'price_yearly': instance.priceYearly,
  'revenuecat_entitlement_id': instance.revenuecatEntitlementId,
};
