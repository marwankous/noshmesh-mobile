import 'package:noshmesh/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ForgotPasswordRequestModel extends Equatable {
  final String email;

  const ForgotPasswordRequestModel({required this.email});

  @override
  List<Object?> get props => [email];

  factory ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestModelToJson(this);

  // Factory constructor to convert ForgotPasswordRequestEntity to ForgotPasswordRequestModel
  factory ForgotPasswordRequestModel.fromEntity(
    ForgotPasswordRequestEntity entity,
  ) {
    return ForgotPasswordRequestModel(email: entity.email);
  }
}
