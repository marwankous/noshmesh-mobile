import 'package:noshmesh/core/logging/logger_provider.dart';
import 'package:noshmesh/core/providers/storage_provider.dart';
import 'package:noshmesh/core/error/failures.dart';
import 'package:noshmesh/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/login_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/logout_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/register_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/update_profile_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/resend_otp_request_entity.dart';
import 'package:noshmesh/features/auth/domain/entities/verify_password_otp_request_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';
import 'package:noshmesh/features/auth/providers/auth_providers.dart';
import 'package:noshmesh/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:noshmesh/core/error/error_mapper.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  pendingVerification,
  loading,
  error,
}

// Auth state
class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? pendingVerificationEmail;
  final String? pendingPasswordResetToken;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.pendingVerificationEmail,
    this.pendingPasswordResetToken,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? pendingVerificationEmail,
    bool clearPendingVerificationEmail = false,
    String? pendingPasswordResetToken,
    bool clearPendingPasswordResetToken = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingVerificationEmail: clearPendingVerificationEmail
          ? null
          : pendingVerificationEmail ?? this.pendingVerificationEmail,
      pendingPasswordResetToken: clearPendingPasswordResetToken
          ? null
          : pendingPasswordResetToken ?? this.pendingPasswordResetToken,
    );
  }
}

// Auth notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Trigger auth check immediately when the provider is first used
    Future.microtask(() => checkAuthStatus());
    return const AuthState(status: AuthStatus.loading);
  }

  // Check auth status
  Future<void> checkAuthStatus() async {
    final logger = ref.read(loggerProvider).child('AuthNotifier');
    logger.d('checkAuthStatus: starting');
    
    // Start timer for minimum splash visibility
    final startTime = DateTime.now();
    const minSplashTime = Duration(milliseconds: 1500);

    try {
      final accessToken = await ref
          .read(secureStorageServiceProvider)
          .getAccessToken();
      logger.d('checkAuthStatus: accessToken found = ${accessToken != null}');
      if (accessToken != null) {
        final getMeUseCase = ref.read(getMeUseCaseProvider);
        final result = await getMeUseCase.execute();
        
        result.fold(
          (failure) {
            logger.w('checkAuthStatus: getMe failed: ${failure.message}');
            state = state.copyWith(status: AuthStatus.unauthenticated);
          },
          (user) {
            logger.i('checkAuthStatus: authenticated as ${user.email}');
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
            );
          },
        );
      } else {
        logger.d('checkAuthStatus: no accessToken, setting unauthenticated');
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      logger.e('checkAuthStatus: unexpected error', error: e);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    } finally {
      logger.d('checkAuthStatus: finished, state status = ${state.status}');
      
      // Ensure the splash has been visible for at least 1.5 seconds
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minSplashTime) {
        await Future.delayed(minSplashTime - elapsed);
      }
      
      // Remove the native splash screen
      FlutterNativeSplash.remove();
    }
  }

  // Refresh user usage data
  Future<void> refreshUserUsage() async {
    final getMeUseCase = ref.read(getMeUseCaseProvider);
    final result = await getMeUseCase.execute();
    result.fold(
      (failure) {
        // Handle failure if needed, maybe don't change state if it fails during refresh
      },
      (user) {
        state = state.copyWith(user: user);
      },
    );
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final result = await loginUseCase.execute(
        LoginRequestEntity(email: email, password: password),
      );

      result.fold(
        (failure) {
          if (failure is UnverifiedAccountFailure) {
            state = state.copyWith(
              status: AuthStatus.pendingVerification,
              pendingVerificationEmail: failure.email,
            );
          } else {
            state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
            );
          }
        },
        (_) async {
          final getMeUseCase = ref.read(getMeUseCaseProvider);
          final userResult = await getMeUseCase.execute();
          userResult.fold(
            (failure) => state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: 'Failed to load profile. Please try again.',
            ),
            (user) {
              state = state.copyWith(
                status: AuthStatus.authenticated,
                user: user,
              );
            },
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final registerUseCase = ref.read(registerUseCaseProvider);
      final result = await registerUseCase.execute(
        RegisterRequestEntity(name: name, email: email, password: password),
      );

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) => state = state.copyWith(
          status: AuthStatus.pendingVerification,
          pendingVerificationEmail: email,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  // Google Sign-In
  Future<void> googleLogin() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await ref.read(authRepositoryProvider).googleLogin();
      await result.fold(
        (failure) async {
          if (failure.message == 'sign_in_cancelled') {
            state = state.copyWith(status: AuthStatus.unauthenticated);
            return;
          }
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
          );
        },
        (_) async {
          final getMeUseCase = ref.read(getMeUseCaseProvider);
          final userResult = await getMeUseCase.execute();
          userResult.fold(
            (failure) => state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: 'Failed to load profile. Please try again.',
            ),
            (user) => state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
            ),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp({required String email, required String code}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await ref.read(verifyOtpUseCaseProvider).execute(
            VerifyOtpRequestEntity(email: email, code: code),
          );
      await result.fold(
        (failure) async => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) async {
          final userResult = await ref.read(getMeUseCaseProvider).execute();
          userResult.fold(
            (failure) => state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: 'Verified! But failed to load profile — please log in.',
            ),
            (user) => state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              clearPendingVerificationEmail: true,
            ),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  // Resend OTP
  Future<void> resendOtp({required String email}) async {
    try {
      final result = await ref.read(resendOtpUseCaseProvider).execute(
            ResendOtpRequestEntity(email: email),
          );
      result.fold(
        (failure) => state = state.copyWith(
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) {},
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  // Logout
  Future<void> logout() async {
    final logger = ref.read(loggerProvider).child('AuthNotifier');
    logger.d('Logout called');

    // Update UI immediately so navigation away from protected screens happens
    // before any async work, but we still await the actual token deletion.
    state = const AuthState(status: AuthStatus.unauthenticated);

    try {
      // Awaited — datasource deletes tokens before the network call, so tokens
      // are gone even if the server call fails or times out.
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final result = await logoutUseCase.execute(
        LogoutRequestEntity(refreshToken: ''),
      );
      result.fold(
        (failure) => logger.w('Logout server call failed: ${failure.message}'),
        (_) => logger.d('Logout complete'),
      );
    } catch (e) {
      logger.e('Logout unexpected error', error: e);
    }
  }

  // Forgot password
  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);
      final result = await forgotPasswordUseCase.execute(
        ForgotPasswordRequestEntity(email: email),
      );

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) => state = state.copyWith(status: AuthStatus.unauthenticated),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  // Verify password reset OTP
  Future<void> verifyPasswordOtp({required String email, required String code}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final result = await ref.read(verifyPasswordOtpUseCaseProvider).execute(
            VerifyPasswordOtpRequestEntity(email: email, code: code),
          );
      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (response) => state = state.copyWith(
          status: AuthStatus.unauthenticated,
          pendingPasswordResetToken: response.resetToken,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
      final result = await resetPasswordUseCase.execute(
        ResetPasswordRequestEntity(token: token, newPassword: newPassword),
      );

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) => state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearPendingPasswordResetToken: true,
        ), // User needs to login again
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }





  // Update profile
  Future<void> updateProfile({String? name, String? email}) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
      final result = await updateProfileUseCase.execute(
        UpdateProfileRequestEntity(name: name, email: email),
      );

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (user) => state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final changePasswordUseCase = ref.read(changePasswordUseCaseProvider);
      final result = await changePasswordUseCase.execute(
        ChangePasswordRequestEntity(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) => state = state.copyWith(status: AuthStatus.authenticated),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final deleteAccountUseCase = ref.read(deleteAccountUseCaseProvider);
      final result = await deleteAccountUseCase.execute();

      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: ErrorMapper.getUserFriendlyMessage(failure),
        ),
        (_) => state = const AuthState(status: AuthStatus.unauthenticated),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Something went wrong. Please try again later.',
      );
    }
  }
}

// Auth provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
