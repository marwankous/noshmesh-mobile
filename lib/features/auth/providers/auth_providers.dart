import 'package:noshmesh/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:noshmesh/features/auth/domain/usecases/delete_account_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/get_me_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/register_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/login_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/logout_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/refresh_token_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/change_password_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/resend_otp_use_case.dart';
import 'package:noshmesh/features/auth/domain/usecases/verify_password_otp_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Use Cases ---

final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  return DeleteAccountUseCase(ref.watch(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});



final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  return RefreshTokenUseCase(ref.watch(authRepositoryProvider));
});



final getMeUseCaseProvider = Provider<GetMeUseCase>((ref) {
  return GetMeUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
});

final resendOtpUseCaseProvider = Provider<ResendOtpUseCase>((ref) {
  return ResendOtpUseCase(ref.watch(authRepositoryProvider));
});

final verifyPasswordOtpUseCaseProvider = Provider<VerifyPasswordOtpUseCase>((ref) {
  return VerifyPasswordOtpUseCase(ref.watch(authRepositoryProvider));
});

