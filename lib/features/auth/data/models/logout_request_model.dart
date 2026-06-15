import 'package:noshmesh/features/auth/domain/entities/logout_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logout_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LogoutRequestModel extends Equatable {
  final String refreshToken;

  const LogoutRequestModel({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];

  factory LogoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestModelToJson(this);

  // Factory constructor to convert LogoutRequestEntity to LogoutRequestModel
  factory LogoutRequestModel.fromEntity(LogoutRequestEntity entity) {
    return LogoutRequestModel(refreshToken: entity.refreshToken);
  }
}
