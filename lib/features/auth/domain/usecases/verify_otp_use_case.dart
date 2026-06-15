import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, void>> execute(VerifyOtpRequestEntity request) =>
      repository.verifyOtp(request: request);
}
