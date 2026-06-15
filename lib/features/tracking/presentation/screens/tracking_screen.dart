import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noshmesh/core/services/noshmesh_api.dart';

final _orderDetailProvider =
    FutureProvider.family<OrderModel, String>((ref, uuid) {
  return ref.watch(noshMeshApiProvider).getOrder(uuid);
});

class TrackingScreen extends ConsumerWidget {
  final String orderUuid;
  const TrackingScreen({super.key, required this.orderUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(_orderDetailProvider(orderUuid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Status'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (order) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusHeader(status: order.status),
              const SizedBox(height: 24),
              _InfoCard(order: order),
              const SizedBox(height: 16),
              _StatusTimeline(status: order.status),
              if (order.glovoTrackingUrl != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _launchUrl(order.glovoTrackingUrl!),
                    icon: const Icon(Icons.delivery_dining),
                    label: const Text('Track with Glovo'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final String status;
  const _StatusHeader({required this.status});

  IconData get _icon {
    switch (status) {
      case 'bidding': return Icons.gavel;
      case 'accepted': return Icons.restaurant;
      case 'delivering': return Icons.delivery_dining;
      case 'delivered': return Icons.check_circle;
      case 'cancelled': return Icons.cancel;
      default: return Icons.info;
    }
  }

  Color _color(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (status) {
      case 'bidding': return Colors.orange;
      case 'accepted': return cs.primary;
      case 'delivering': return Colors.blue;
      case 'delivered': return Colors.green;
      case 'cancelled': return cs.error;
      default: return cs.onSurface;
    }
  }

  String get _label {
    switch (status) {
      case 'bidding': return 'Awaiting Bids';
      case 'accepted': return 'Preparing Your Order';
      case 'delivering': return 'Out for Delivery';
      case 'delivered': return 'Delivered!';
      case 'cancelled': return 'Cancelled';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: color, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            _label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final OrderModel order;
  const _InfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Craving',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
                    )),
            const SizedBox(height: 4),
            Text(order.cravingText,
                style: Theme.of(context).textTheme.bodyLarge),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(order.deliveryAddress)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18),
                const SizedBox(width: 8),
                Text('Cash on delivery'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String status;
  const _StatusTimeline({required this.status});

  static const _steps = ['bidding', 'accepted', 'delivering', 'delivered'];

  int get _currentStep => _steps.indexOf(status);

  @override
  Widget build(BuildContext context) {
    if (status == 'cancelled') return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            ..._steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              final done = i < _currentStep;
              final active = i == _currentStep;
              final labels = {
                'bidding': 'Collecting bids',
                'accepted': 'Restaurant accepted',
                'delivering': 'Out for delivery',
                'delivered': 'Delivered',
              };
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? cs.primary
                            : active
                                ? cs.primaryContainer
                                : cs.surfaceContainerHighest,
                      ),
                      child: done
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : active
                              ? Icon(Icons.circle, size: 10, color: cs.primary)
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      labels[step] ?? step,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: active ? FontWeight.bold : FontWeight.normal,
                            color: done || active ? cs.onSurface : cs.onSurface.withAlpha(100),
                          ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
