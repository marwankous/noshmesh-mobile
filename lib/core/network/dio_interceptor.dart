import 'dart:async';
import 'package:noshmesh/core/router/navigator_keys.dart';
import 'package:noshmesh/core/utils/jwt_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:noshmesh/core/services/secure_storage_service.dart';
import 'package:noshmesh/features/auth/data/models/tokens_model.dart';
import 'package:noshmesh/l10n/l10n.dart';

void addDioInterceptor(
  Dio dio,
  SecureStorageService secureStorageService, {
  VoidCallback? onLogout,
  Connectivity? connectivity,
}) {
  // A Completer to signal when the refresh token process is ongoing
  // or completed to prevent multiple simultaneous token refresh requests.
  Completer<String?>? refreshTokenCompleter;

  /// Helper to perform the actual refresh call
  Future<String?> performRefresh() async {
    // If we are already refreshing, wait for it to complete
    if (refreshTokenCompleter != null) {
      return refreshTokenCompleter!.future;
    }

    // Start refreshing
    refreshTokenCompleter = Completer<String?>();

    try {
      final refreshToken = await secureStorageService.getRefreshToken();
      final expiredAccessToken = await secureStorageService.getAccessToken();

      if (refreshToken == null || JwtUtils.isExpired(refreshToken)) {
        refreshTokenCompleter!.complete(null);
        refreshTokenCompleter = null;
        await secureStorageService.deleteTokens();
        onLogout?.call();
        return null;
      }

      // Create a temporary Dio instance to avoid interceptor recursion
      final tokenDio = Dio(
        BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (expiredAccessToken != null)
              'Authorization': 'Bearer $expiredAccessToken',
          },
        ),
      );

      final response = await tokenDio.post(
        '/auth/token/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final tokens = TokensModel.fromJson(response.data);
        await secureStorageService.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );

        final newToken = tokens.accessToken;
        refreshTokenCompleter!.complete(newToken);
        refreshTokenCompleter = null;
        return newToken;
      } else {
        refreshTokenCompleter!.complete(null);
        refreshTokenCompleter = null;
        await secureStorageService.deleteTokens();
        onLogout?.call();
        return null;
      }
    } catch (refreshError) {
      refreshTokenCompleter!.complete(null);
      refreshTokenCompleter = null;
      await secureStorageService.deleteTokens();
      onLogout?.call();
      return null;
    }
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Fail fast when offline
        if (connectivity != null) {
          try {
            final result = await connectivity.checkConnectivity();
            if (result.contains(ConnectivityResult.none)) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'No internet connection. Please check your network.',
                  type: DioExceptionType.connectionError,
                ),
              );
            }
          } catch (_) {
            // If connectivity check itself fails, let the request through.
          }
        }

        // Skip adding token for most auth routes, EXCEPT refresh
        if (options.path.contains('/auth/') &&
            !options.path.contains('/token/refresh')) {
          return handler.next(options);
        }

        final accessToken = await secureStorageService.getAccessToken();

        if (accessToken != null) {
          // PROACTIVE CHECK: If access token is expired, refresh it BEFORE sending
          if (JwtUtils.isExpired(accessToken)) {
            final newToken = await performRefresh();
            if (newToken != null) {
              options.headers['Authorization'] = 'Bearer $newToken';
            } else {
              // Refresh failed or logged out
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Session expired',
                  type: DioExceptionType.cancel,
                ),
              );
            }
          } else {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 402) {
          _showQuotaExceededDialog();
          return handler.next(e);
        }

        if (e.response?.statusCode == 403) {
          _showPermissionDeniedSnackbar();
          return handler.next(e);
        }

        // REACTIVE CHECK: If we still get a 401, try to refresh once
        if (e.response?.statusCode == 401) {
          // If the error itself is from the refresh endpoint, don't try to refresh again
          if (e.requestOptions.path.contains('/auth/token/refresh')) {
            await secureStorageService.deleteTokens();
            onLogout?.call();
            return handler.next(e);
          }

          // Guard: only retry once — if this request was already retried, propagate
          if (e.requestOptions.extra.containsKey('_dio_retried')) {
            return handler.next(e);
          }

          final newToken = await performRefresh();
          if (newToken != null) {
            // Retry the original request with the new token
            e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            e.requestOptions.extra['_dio_retried'] = true;
            try {
              final retryResponse = await dio.fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } on DioException catch (retryErr) {
              return handler.next(retryErr);
            }
          }
        }

        return handler.next(e);
      },
    ),
  );
}

void _showPermissionDeniedSnackbar() {
  final context = rootNavigatorKey.currentContext;
  if (context != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Your plan doesn't include this feature. Upgrade to continue.",
        ),
        backgroundColor: Colors.orange.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Upgrade',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

void _showQuotaExceededDialog() {
  final context = rootNavigatorKey.currentContext;
  if (context != null) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              context.tr('monthly_limit_reached'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('quota_reached_explanation'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(context.tr('view_plans')),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr('close')),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
