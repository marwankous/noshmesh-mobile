import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> execute(
    ResetPasswordRequestEntity resetPasswordRequest,
  ) {
    return repository.resetPassword(resetPasswordRequest: resetPasswordRequest);
  }
}
