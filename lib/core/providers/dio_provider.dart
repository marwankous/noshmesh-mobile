import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/network/connectivity_provider.dart';
import 'package:noshmesh/core/network/dio_interceptor.dart';
import 'package:noshmesh/core/providers/storage_provider.dart'; // Import storage_provider
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));
  final secureStorageService = ref.watch(
    secureStorageServiceProvider,
  ); // Get SecureStorageService
  addDioInterceptor(
    dio,
    secureStorageService,
    onLogout: () {
      ref.read(authProvider.notifier).logout();
    },
    connectivity: ref.watch(connectivityServiceProvider),
  ); // Pass SecureStorageService directly
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true),
  ); // Add LogInterceptor
  return dio;
});
