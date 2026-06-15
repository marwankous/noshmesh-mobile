import 'package:equatable/equatable.dart';

class ResetPasswordRequestEntity extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordRequestEntity({
    required this.token,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [token, newPassword];
}
