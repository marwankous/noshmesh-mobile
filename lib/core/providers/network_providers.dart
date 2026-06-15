import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:noshmesh/core/network/connectivity_provider.dart';
import 'package:noshmesh/core/network/dio_interceptor.dart';
import '../network/interceptors/retry_interceptor.dart';
import '../constants/app_constants.dart';
import 'package:noshmesh/core/providers/storage_provider.dart'; // Import storage_provider
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';

part 'network_providers.g.dart';

@riverpod
Dio dio(Ref ref) {
  // Keep the provider alive to ensure interceptors can complete async tasks
  ref.onDispose(() {});

  final dio = Dio();
  final secureStorageService = ref.watch(
    secureStorageServiceProvider,
  ); // Get SecureStorageService

  dio.options.baseUrl = AppConstants.apiBaseUrl;
  dio.options.connectTimeout = const Duration(milliseconds: 30000);
  dio.options.receiveTimeout = const Duration(milliseconds: 30000);
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Add interceptors here
  addDioInterceptor(
    dio,
    secureStorageService,
    onLogout: () {
      ref.read(authProvider.notifier).logout();
    },
    connectivity: ref.watch(connectivityServiceProvider),
  ); // Pass SecureStorageService directly
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio: dio));

  return dio;
}
