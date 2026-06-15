import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/services/secure_storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
