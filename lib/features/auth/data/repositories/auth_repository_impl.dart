import 'package:noshmesh/features/auth/data/models/change_password_request_model.dart';
import 'package:noshmesh/features/auth/data/models/forgot_password_request_model.dart';
import 'package:noshmesh/features/auth/data/models/login_request_model.dart';
import 'package:noshmesh/features/auth/data/models/register_request_model.dart';
import 'package:noshmesh/features/auth/domain/entities/register_request_entity.dart';
import 'package:noshmesh/features/auth/data/models/logout_request_model.dart';
import 'package:noshmesh/features/auth/data/models/refresh_token_request_model.dart';
import 'package:noshmesh/features/auth/data/models/reset_password_request_model.dart';
import 'package:noshmesh/features/auth/data/models/tokens_model.dart';
import 'package:noshmesh/features/auth/data/models/update_profile_request_model.dart';
import 'package:noshmesh/features/auth/data/models/verify_otp_request_model.dart';
import 'package:noshmesh/features/auth/data/models/resend_otp_request_model.dart';
import 'package:noshmesh/features/auth/data/models/verify_password_otp_request_model.dart';
import 'package:noshmesh/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/login_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/logout_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/refresh_token_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/tokens_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/update_profile_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/resend_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_response_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';
import 'package:noshmesh/features/auth/domain/repositories/auth_repository.dart';
import 'package:noshmesh/core/error/exceptions.dart';
import 'package:noshmesh/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> register({
    required RegisterRequestEntity registerRequest,
  }) async {
    try {
      await remoteDataSource.register(
        registerRequest: RegisterRequestModel.fromEntity(registerRequest),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> login({
    required LoginRequestEntity loginRequest,
  }) async {
    try {
      final tokensModel = await remoteDataSource.login(
        loginRequest: LoginRequestModel.fromEntity(loginRequest),
      );
      return Right(tokensModel.toEntity());
    } on UnverifiedAccountException catch (e) {
      return Left(UnverifiedAccountFailure(email: e.email));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> googleLogin() async {
    try {
      final tokensModel = await remoteDataSource.googleLogin();
      return Right(tokensModel.toEntity());
    } on RequestCancelledException {
      return const Left(AuthFailure(message: 'sign_in_cancelled'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout({
    required LogoutRequestEntity logoutRequest,
  }) async {
    try {
      await remoteDataSource.logout(
        logoutRequest: LogoutRequestModel.fromEntity(logoutRequest),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required ForgotPasswordRequestEntity forgotPasswordRequest,
  }) async {
    try {
      await remoteDataSource.forgotPassword(
        forgotPasswordRequest: ForgotPasswordRequestModel.fromEntity(
          forgotPasswordRequest,
        ),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required ResetPasswordRequestEntity resetPasswordRequest,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        resetPasswordRequest: ResetPasswordRequestModel.fromEntity(
          resetPasswordRequest,
        ),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TokensEntity>> refreshToken({
    required RefreshTokenRequestEntity refreshTokenRequest,
  }) async {
    try {
      final tokensModel = await remoteDataSource.refreshToken(
        refreshTokenRequest: RefreshTokenRequestModel.fromEntity(
          refreshTokenRequest,
        ),
      );
      return Right(tokensModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }



  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final userModel = await remoteDataSource.getMe();
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required UpdateProfileRequestEntity updateProfileRequest,
  }) async {
    try {
      final userModel = await remoteDataSource.updateProfile(
        updateProfileRequest: UpdateProfileRequestModel.fromEntity(
          updateProfileRequest,
        ),
      );
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required ChangePasswordRequestEntity changePasswordRequest,
  }) async {
    try {
      await remoteDataSource.changePassword(
        changePasswordRequest: ChangePasswordRequestModel.fromEntity(
          changePasswordRequest,
        ),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }



  

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required VerifyOtpRequestEntity request,
  }) async {
    try {
      await remoteDataSource.verifyOtp(
        request: VerifyOtpRequestModel.fromEntity(request),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({
    required ResendOtpRequestEntity request,
  }) async {
    try {
      await remoteDataSource.resendOtp(
        request: ResendOtpRequestModel.fromEntity(request),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VerifyPasswordOtpResponseEntity>> verifyPasswordOtp({
    required VerifyPasswordOtpRequestEntity request,
  }) async {
    try {
      final result = await remoteDataSource.verifyPasswordOtp(
        request: VerifyPasswordOtpRequestModel.fromEntity(request),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});
