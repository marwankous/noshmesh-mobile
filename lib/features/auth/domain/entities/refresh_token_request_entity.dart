import 'package:equatable/equatable.dart';

class RefreshTokenRequestEntity extends Equatable {
  final String refreshToken;

  const RefreshTokenRequestEntity({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
