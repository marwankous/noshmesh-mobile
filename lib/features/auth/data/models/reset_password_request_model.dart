import 'package:noshmesh/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResetPasswordRequestModel extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestModelToJson(this);

  // Factory constructor to convert ResetPasswordRequestEntity to ResetPasswordRequestModel
  factory ResetPasswordRequestModel.fromEntity(
    ResetPasswordRequestEntity entity,
  ) {
    return ResetPasswordRequestModel(
      token: entity.token,
      newPassword: entity.newPassword,
    );
  }
}
