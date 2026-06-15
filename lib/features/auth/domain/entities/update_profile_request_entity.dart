import 'package:equatable/equatable.dart';

class UpdateProfileRequestEntity extends Equatable {
  final String? name;
  final String? email;

  const UpdateProfileRequestEntity({this.name, this.email});

  @override
  List<Object?> get props => [name, email];
}
