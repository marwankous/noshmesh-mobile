import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/tokens_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, TokensEntity>> execute(
    RefreshTokenRequestEntity refreshTokenRequest,
  ) {
    return repository.refreshToken(refreshTokenRequest: refreshTokenRequest);
  }
}
