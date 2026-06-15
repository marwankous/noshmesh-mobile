import 'package:noshmesh/core/providers/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentService {
  final Dio _dio;
  PaymentService(this._dio);

  Future<String> createCheckoutUrl(int variantId) async {
    final response = await _dio.post(
      '/v1/app/payments/checkout',
      data: {'variant_id': variantId},
    );
    final url = response.data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('No checkout URL returned');
    }
    return url;
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ref.watch(dioProvider));
});
