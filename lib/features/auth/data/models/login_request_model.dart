import 'package:noshmesh/features/auth/domain/entities/login_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequestModel extends Equatable {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  // Factory constructor to convert LoginRequestEntity to LoginRequestModel
  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(email: entity.email, password: entity.password);
  }
}
