import 'package:noshmesh/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/login_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/register_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/logout_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/tokens_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/update_profile_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/resend_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_response_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> register({
    required RegisterRequestEntity registerRequest,
  });
  Future<Either<Failure, TokensEntity>> login({
    required LoginRequestEntity loginRequest,
  });
  Future<Either<Failure, TokensEntity>> googleLogin();
  Future<Either<Failure, void>> logout({
    required LogoutRequestEntity logoutRequest,
  });
  Future<Either<Failure, void>> forgotPassword({
    required ForgotPasswordRequestEntity forgotPasswordRequest,
  });
  Future<Either<Failure, void>> resetPassword({
    required ResetPasswordRequestEntity resetPasswordRequest,
  });
  Future<Either<Failure, TokensEntity>> refreshToken({
    required RefreshTokenRequestEntity refreshTokenRequest,
  });
  Future<Either<Failure, UserEntity>> getMe();
  Future<Either<Failure, UserEntity>> updateProfile({
    required UpdateProfileRequestEntity updateProfileRequest,
  });
  Future<Either<Failure, void>> changePassword({
    required ChangePasswordRequestEntity changePasswordRequest,
  });
  
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> verifyOtp({
    required VerifyOtpRequestEntity request,
  });
  Future<Either<Failure, void>> resendOtp({
    required ResendOtpRequestEntity request,
  });
  Future<Either<Failure, VerifyPasswordOtpResponseEntity>> verifyPasswordOtp({
    required VerifyPasswordOtpRequestEntity request,
  });
}
