import 'package:noshmesh/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangePasswordRequestModel extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);

  // Factory constructor to convert ChangePasswordRequestEntity to ChangePasswordRequestModel
  factory ChangePasswordRequestModel.fromEntity(
    ChangePasswordRequestEntity entity,
  ) {
    return ChangePasswordRequestModel(
      currentPassword: entity.currentPassword,
      newPassword: entity.newPassword,
    );
  }
}
