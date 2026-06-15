import 'package:noshmesh/features/auth/domain/entities/logout_request_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> execute(LogoutRequestEntity logoutRequest) {
    return repository.logout(logoutRequest: logoutRequest);
  }
}
