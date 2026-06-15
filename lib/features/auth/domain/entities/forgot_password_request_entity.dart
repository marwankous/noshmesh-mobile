import 'package:equatable/equatable.dart';

class ForgotPasswordRequestEntity extends Equatable {
  final String email;

  const ForgotPasswordRequestEntity({required this.email});

  @override
  List<Object?> get props => [email];
}
