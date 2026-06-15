import 'package:noshmesh/features/auth/domain/entities/login_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/tokens_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, TokensEntity>> execute(
    LoginRequestEntity loginRequest,
  ) {
    return repository.login(loginRequest: loginRequest);
  }
}
