import 'package:noshmesh/core/providers/dio_provider.dart';
import 'package:noshmesh/core/services/secure_storage_service.dart';
import 'package:noshmesh/features/auth/data/models/login_request_model.dart';
import 'package:noshmesh/features/auth/data/models/logout_request_model.dart';
import 'package:noshmesh/features/auth/data/models/register_request_model.dart';
import 'package:noshmesh/features/auth/data/models/forgot_password_request_model.dart';
import 'package:noshmesh/features/auth/data/models/change_password_request_model.dart';
import 'package:noshmesh/core/providers/storage_provider.dart';
import 'package:noshmesh/features/auth/data/models/refresh_token_request_model.dart';
import 'package:noshmesh/features/auth/data/models/reset_password_request_model.dart';
import 'package:noshmesh/features/auth/data/models/tokens_model.dart';
import 'package:noshmesh/features/auth/data/models/update_profile_request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/error/exceptions.dart';
import 'package:noshmesh/features/auth/data/models/user_model.dart';
import 'package:noshmesh/features/auth/data/models/verify_otp_request_model.dart';
import 'package:noshmesh/features/auth/data/models/resend_otp_request_model.dart';
import 'package:noshmesh/features/auth/data/models/verify_password_otp_request_model.dart';
import 'package:noshmesh/features/auth/data/models/verify_password_otp_response_model.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<void> register({required RegisterRequestModel registerRequest});
  Future<TokensModel> login({required LoginRequestModel loginRequest});
  Future<TokensModel> googleLogin();
  Future<void> logout({required LogoutRequestModel logoutRequest});
  Future<void> forgotPassword({
    required ForgotPasswordRequestModel forgotPasswordRequest,
  });
  Future<void> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequest,
  });
  Future<TokensModel> refreshToken({
    required RefreshTokenRequestModel refreshTokenRequest,
  });
  Future<UserModel> getMe();
  Future<UserModel> updateProfile({
    required UpdateProfileRequestModel updateProfileRequest,
  });
  Future<void> changePassword({
    required ChangePasswordRequestModel changePasswordRequest,
  });
  
  Future<void> deleteAccount();
  Future<void> verifyOtp({required VerifyOtpRequestModel request});
  Future<void> resendOtp({required ResendOtpRequestModel request});
  Future<VerifyPasswordOtpResponseModel> verifyPasswordOtp({
    required VerifyPasswordOtpRequestModel request,
  });
}

const _webClientId =
    '985038668902-1ltjb0j96nniuc582kppdas940j64865.apps.googleusercontent.com';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  AuthRemoteDataSourceImpl({
    required Dio dio,
    required SecureStorageService storageService,
  }) : _dio = dio,
       _storageService = storageService;

  @override
  Future<void> register({required RegisterRequestModel registerRequest}) async {
    try {
      await _dio.post(
        '/auth/signup',
        data: registerRequest.toJson(),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map)
          ? (data['message'] ?? data['email'] ?? data['general'] ?? e.message)
          : e.message;
      throw ServerException(message: msg?.toString() ?? 'Registration failed.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> login({required LoginRequestModel loginRequest}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: loginRequest.toJson(),
      );
      final tokens = TokensModel.fromJson(response.data);
      await _storageService.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return tokens;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        final data = e.response?.data;
        if (data is Map && data['status'] == 'unverified') {
          throw UnverifiedAccountException(
            email: data['email']?.toString() ?? '',
          );
        }
      }
      final data = e.response?.data;
      final msg = (data is Map)
          ? (data['message'] ?? data['general'] ?? e.message)
          : e.message;
      throw ServerException(message: msg?.toString() ?? 'Login failed.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> googleLogin() async {
    final googleSignIn = GoogleSignIn(serverClientId: _webClientId);
    await googleSignIn.signOut(); // clear cached account so picker always appears
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw RequestCancelledException();
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) {
      throw ServerException(message: 'Google sign-in failed. Please try again.');
    }

    try {
      final response = await _dio.post(
        '/auth/google/token',
        data: {'id_token': idToken},
      );
      final tokens = TokensModel.fromJson(response.data);
      await _storageService.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return tokens;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['general'] ?? e.message);
    }
  }

  @override
  Future<void> logout({required LogoutRequestModel logoutRequest}) async {
    // Capture credentials before wiping — the server needs the refresh token to
    // invalidate the session, and the access token for the Authorization header.
    final accessToken = await _storageService.getAccessToken();
    final refreshToken = await _storageService.getRefreshToken();

    // Delete locally FIRST so the main Dio interceptor cannot refresh and
    // re-save new tokens if the network call triggers a 401 retry cycle.
    await _storageService.deleteTokens();

    // Best-effort server invalidation using a bare Dio (no interceptors) to
    // prevent the auth interceptor from interfering.
    try {
      final bare = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      await bare.post('/auth/logout', data: {'refresh_token': refreshToken ?? ''});
    } catch (_) {
      // Swallow — local tokens already cleared, best-effort server call.
    }
  }

  @override
  Future<void> forgotPassword({
    required ForgotPasswordRequestModel forgotPasswordRequest,
  }) async {
    try {
      await _dio.post(
        '/auth/password/forgot',
        data: forgotPasswordRequest.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> resetPassword({
    required ResetPasswordRequestModel resetPasswordRequest,
  }) async {
    try {
      await _dio.post(
        '/auth/password/reset',
        data: resetPasswordRequest.toJson(),
      );
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> refreshToken({
    required RefreshTokenRequestModel refreshTokenRequest,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/token/refresh',
        data: refreshTokenRequest.toJson(),
      );
      final tokens = TokensModel.fromJson(response.data);
      await _storageService.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return tokens;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException();
    }
  }



  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/me');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> updateProfile({
    required UpdateProfileRequestModel updateProfileRequest,
  }) async {
    try {
      final response = await _dio.put(
        '/me',
        data: updateProfileRequest.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? e.message);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> changePassword({
    required ChangePasswordRequestModel changePasswordRequest,
  }) async {
    try {
      await _dio.post(
        '/me/change-password',
        data: changePasswordRequest.toJson(),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map)
          ? (data['general'] ?? data['message'] ?? data['current_password'] ?? data['new_password'])
          : null;
      throw ServerException(message: msg?.toString() ?? 'Failed to change password.');
    } catch (e) {
      throw ServerException();
    }
  }



  

  @override
  Future<void> verifyOtp({required VerifyOtpRequestModel request}) async {
    try {
      final response = await _dio.post('/auth/email/verify-otp', data: request.toJson());
      final data = response.data;
      if (data is Map) {
        final accessToken = data['access_token']?.toString();
        final refreshToken = data['refresh_token']?.toString();
        if (accessToken == null || refreshToken == null) {
          throw ServerException(message: 'Verification failed. Please try again.');
        }
        await _storageService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map) ? (data['general'] ?? e.message) : e.message;
      throw ServerException(message: msg?.toString() ?? 'Verification failed.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> resendOtp({required ResendOtpRequestModel request}) async {
    try {
      await _dio.post('/auth/email/resend-otp', data: request.toJson());
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map) ? (data['general'] ?? e.message) : e.message;
      throw ServerException(message: msg?.toString() ?? 'Failed to resend code.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete('/me');
      await _storageService.deleteTokens();
    } on DioException catch (e) {
      // Handle the specific error structure mentioned by user
      final data = e.response?.data;
      String? errorMessage;

      if (data is Map<String, dynamic> && data.containsKey('general')) {
        errorMessage = data['general'];
      } else {
        errorMessage = data?['message'] ?? e.message;
      }

      throw ServerException(message: errorMessage ?? 'Failed to delete account.');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<VerifyPasswordOtpResponseModel> verifyPasswordOtp({
    required VerifyPasswordOtpRequestModel request,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/password/verify-otp',
        data: request.toJson(),
      );
      return VerifyPasswordOtpResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map) ? (data['general'] ?? e.message) : e.message;
      throw ServerException(message: msg?.toString() ?? 'Verification failed.');
    } catch (e) {
      throw ServerException();
    }
  }
}

// Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return AuthRemoteDataSourceImpl(
    dio: dio,
    storageService: storageService,
  );
});
