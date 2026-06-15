import 'package:equatable/equatable.dart';

class PlanEntity extends Equatable {
  final int id;
  final String name;
  final int maxMonthlyTokens;
  final int maxFeedSubscriptions;
  final int maxArticlesPerMerge;
  final int maxExternalEndpoints;
  final String? priceMonthly;
  final String? priceYearly;
  final String? revenuecatEntitlementId;

  const PlanEntity({
    required this.id,
    required this.name,
    required this.maxMonthlyTokens,
    required this.maxFeedSubscriptions,
    required this.maxArticlesPerMerge,
    required this.maxExternalEndpoints,
    this.priceMonthly,
    this.priceYearly,
    this.revenuecatEntitlementId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        maxMonthlyTokens,
        maxFeedSubscriptions,
        maxArticlesPerMerge,
        maxExternalEndpoints,
        priceMonthly,
        priceYearly,
        revenuecatEntitlementId
      ];

  factory PlanEntity.empty() {
    return const PlanEntity(
      id: 0,
      name: '',
      maxMonthlyTokens: 0,
      maxFeedSubscriptions: 0,
      maxArticlesPerMerge: 0,
      maxExternalEndpoints: 0,
    );
  }

  PlanEntity copyWith({
    int? id,
    String? name,
    int? maxMonthlyTokens,
    int? maxFeedSubscriptions,
    int? maxArticlesPerMerge,
    int? maxExternalEndpoints,
    String? priceMonthly,
    String? priceYearly,
    String? revenuecatEntitlementId,
  }) {
    return PlanEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      maxMonthlyTokens: maxMonthlyTokens ?? this.maxMonthlyTokens,
      maxFeedSubscriptions: maxFeedSubscriptions ?? this.maxFeedSubscriptions,
      maxArticlesPerMerge: maxArticlesPerMerge ?? this.maxArticlesPerMerge,
      maxExternalEndpoints: maxExternalEndpoints ?? this.maxExternalEndpoints,
      priceMonthly: priceMonthly ?? this.priceMonthly,
      priceYearly: priceYearly ?? this.priceYearly,
      revenuecatEntitlementId:
          revenuecatEntitlementId ?? this.revenuecatEntitlementId,
    );
  }
}
