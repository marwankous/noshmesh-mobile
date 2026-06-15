import 'package:noshmesh/features/auth/domain/entities/tokens_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokens_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TokensModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const TokensModel({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];

  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelToJson(this);

  // Factory constructor to convert TokensEntity to TokensModel
  factory TokensModel.fromEntity(TokensEntity entity) {
    return TokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
    );
  }
}

// Extension to convert TokensModel to TokensEntity
extension TokensModelX on TokensModel {
  TokensEntity toEntity() {
    return TokensEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}
