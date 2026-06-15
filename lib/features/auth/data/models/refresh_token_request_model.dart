import 'package:noshmesh/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshTokenRequestModel extends Equatable {
  final String refreshToken;

  const RefreshTokenRequestModel({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];

  factory RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestModelToJson(this);

  // Factory constructor to convert RefreshTokenRequestEntity to RefreshTokenRequestModel
  factory RefreshTokenRequestModel.fromEntity(
    RefreshTokenRequestEntity entity,
  ) {
    return RefreshTokenRequestModel(refreshToken: entity.refreshToken);
  }
}
