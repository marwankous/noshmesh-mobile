import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> execute(
    ForgotPasswordRequestEntity forgotPasswordRequest,
  ) {
    return repository.forgotPassword(
      forgotPasswordRequest: forgotPasswordRequest,
    );
  }
}
