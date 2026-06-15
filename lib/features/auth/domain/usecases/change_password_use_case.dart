import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> execute(
    ChangePasswordRequestEntity changePasswordRequest,
  ) {
    return repository.changePassword(
      changePasswordRequest: changePasswordRequest,
    );
  }
}
