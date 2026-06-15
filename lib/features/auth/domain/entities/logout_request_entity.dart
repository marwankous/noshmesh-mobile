import 'package:equatable/equatable.dart';

class LogoutRequestEntity extends Equatable {
  final String refreshToken;

  const LogoutRequestEntity({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
