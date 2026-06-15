import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/providers/dio_provider.dart';

// ── Models ──────────────────────────────────────────────────────────────────

class OrderModel {
  final String uuid;
  final String status;
  final String cravingText;
  final double budgetMax;
  final String deliveryAddress;
  final String? biddingExpiresAt;
  final String? glovoTrackingUrl;
  final String paymentMethod;
  final String createdAt;

  const OrderModel({
    required this.uuid,
    required this.status,
    required this.cravingText,
    required this.budgetMax,
    required this.deliveryAddress,
    this.biddingExpiresAt,
    this.glovoTrackingUrl,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> j) => OrderModel(
        uuid: j['uuid'] as String,
        status: j['status'] as String,
        cravingText: j['craving_text'] as String,
        budgetMax: (j['budget_max'] as num).toDouble(),
        deliveryAddress: j['delivery_address'] as String,
        biddingExpiresAt: j['bidding_expires_at'] as String?,
        glovoTrackingUrl: j['glovo_tracking_url'] as String?,
        paymentMethod: j['payment_method'] as String? ?? 'cash',
        createdAt: j['created_at'] as String,
      );
}

class BidModel {
  final String uuid;
  final String orderUuid;
  final String restaurantName;
  final String mealName;
  final String mealDescription;
  final double price;
  final int estimatedMinutes;
  final String status;
  final String createdAt;

  const BidModel({
    required this.uuid,
    required this.orderUuid,
    required this.restaurantName,
    required this.mealName,
    required this.mealDescription,
    required this.price,
    required this.estimatedMinutes,
    required this.status,
    required this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> j) => BidModel(
        uuid: j['uuid'] as String,
        orderUuid: j['order_uuid'] as String? ?? '',
        restaurantName: j['restaurant_name'] as String? ?? '',
        mealName: j['meal_name'] as String,
        mealDescription: j['meal_description'] as String? ?? '',
        price: (j['price'] as num).toDouble(),
        estimatedMinutes: j['estimated_minutes'] as int? ?? 30,
        status: j['status'] as String? ?? 'pending',
        createdAt: j['created_at'] as String? ?? '',
      );
}

class RestaurantModel {
  final String uuid;
  final String name;
  final String address;
  final bool isActive;

  const RestaurantModel({
    required this.uuid,
    required this.name,
    required this.address,
    required this.isActive,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> j) => RestaurantModel(
        uuid: j['uuid'] as String,
        name: j['name'] as String,
        address: j['address'] as String? ?? '',
        isActive: j['is_active'] == true || j['is_active'] == 1,
      );
}

// ── Service ──────────────────────────────────────────────────────────────────

class NoshMeshApi {
  final Dio _dio;
  NoshMeshApi(this._dio);

  static const _base = '/v1/app';

  Future<OrderModel> createOrder({
    required String cravingText,
    required double budgetMax,
    required String deliveryAddress,
    double? deliveryLat,
    double? deliveryLng,
  }) async {
    final r = await _dio.post('$_base/orders', data: {
      'craving_text': cravingText,
      'budget_max': budgetMax,
      'delivery_address': deliveryAddress,
      if (deliveryLat != null) 'delivery_lat': deliveryLat,
      if (deliveryLng != null) 'delivery_lng': deliveryLng,
      'payment_method': 'cash',
    });
    return OrderModel.fromJson(r.data as Map<String, dynamic>);
  }

  Future<List<OrderModel>> myOrders() async {
    final r = await _dio.get('$_base/orders/mine');
    return (r.data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderModel> getOrder(String uuid) async {
    final r = await _dio.get('$_base/orders/$uuid');
    return OrderModel.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> cancelOrder(String uuid) async {
    await _dio.post('$_base/orders/$uuid/cancel');
  }

  Future<void> acceptBid(String orderUuid, String bidUuid) async {
    await _dio.post('$_base/orders/$orderUuid/accept/$bidUuid');
  }

  Future<List<BidModel>> bidsForOrder(String orderUuid) async {
    final r = await _dio.get('$_base/bids/order/$orderUuid');
    return (r.data as List).map((e) => BidModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> placeBid({
    required String orderUuid,
    required String mealName,
    required String mealDescription,
    required double price,
    required int estimatedMinutes,
  }) async {
    await _dio.post('$_base/bids', data: {
      'order_uuid': orderUuid,
      'meal_name': mealName,
      'meal_description': mealDescription,
      'price': price,
      'estimated_minutes': estimatedMinutes,
    });
  }

  Future<List<OrderModel>> availableOrders() async {
    final r = await _dio.get('$_base/available');
    return (r.data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<OrderModel>> myRestaurantOrders() async {
    final r = await _dio.get('$_base/mine/restaurant');
    return (r.data as List).map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}

final noshMeshApiProvider = Provider<NoshMeshApi>((ref) {
  return NoshMeshApi(ref.watch(dioProvider));
});
