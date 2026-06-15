import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/resend_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<Either<Failure, void>> execute(ResendOtpRequestEntity request) =>
      repository.resendOtp(request: request);
}
