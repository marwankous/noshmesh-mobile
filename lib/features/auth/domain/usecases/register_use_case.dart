import 'package:noshmesh/features/auth/domain/entities/register_request_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> execute(RegisterRequestEntity request) {
    return repository.register(registerRequest: request);
  }
}
