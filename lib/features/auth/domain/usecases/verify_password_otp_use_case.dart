import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_response_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyPasswordOtpUseCase {
  final AuthRepository repository;

  VerifyPasswordOtpUseCase(this.repository);

  Future<Either<Failure, VerifyPasswordOtpResponseEntity>> execute(
    VerifyPasswordOtpRequestEntity request,
  ) =>
      repository.verifyPasswordOtp(request: request);
}
