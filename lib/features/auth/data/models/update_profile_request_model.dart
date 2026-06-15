import 'package:noshmesh/features/auth/domain/entities/update_profile_request_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateProfileRequestModel extends Equatable {
  final String? name;
  final String? email;

  const UpdateProfileRequestModel({this.name, this.email});

  @override
  List<Object?> get props => [name, email];

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestModelToJson(this);

  // Factory constructor to convert UpdateProfileRequestEntity to UpdateProfileRequestModel
  factory UpdateProfileRequestModel.fromEntity(
    UpdateProfileRequestEntity entity,
  ) {
    return UpdateProfileRequestModel(name: entity.name, email: entity.email);
  }
}
