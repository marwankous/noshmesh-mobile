import 'package:noshmesh/features/auth/domain/entities/plan_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'plan_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PlanModel extends Equatable {
  final int id;
  final String name;
  final int maxMonthlyTokens;
  final int maxFeedSubscriptions;
  final int maxArticlesPerMerge;
  final int maxExternalEndpoints;
  final String? priceMonthly;
  final String? priceYearly;
  final String? revenuecatEntitlementId;

  const PlanModel({
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

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);

  factory PlanModel.fromEntity(PlanEntity entity) {
    return PlanModel(
      id: entity.id,
      name: entity.name,
      maxMonthlyTokens: entity.maxMonthlyTokens,
      maxFeedSubscriptions: entity.maxFeedSubscriptions,
      maxArticlesPerMerge: entity.maxArticlesPerMerge,
      maxExternalEndpoints: entity.maxExternalEndpoints,
      priceMonthly: entity.priceMonthly,
      priceYearly: entity.priceYearly,
      revenuecatEntitlementId: entity.revenuecatEntitlementId,
    );
  }
}

extension PlanModelX on PlanModel {
  PlanEntity toEntity() {
    return PlanEntity(
      id: id,
      name: name,
      maxMonthlyTokens: maxMonthlyTokens,
      maxFeedSubscriptions: maxFeedSubscriptions,
      maxArticlesPerMerge: maxArticlesPerMerge,
      maxExternalEndpoints: maxExternalEndpoints,
      priceMonthly: priceMonthly,
      priceYearly: priceYearly,
      revenuecatEntitlementId: revenuecatEntitlementId,
    );
  }
}
