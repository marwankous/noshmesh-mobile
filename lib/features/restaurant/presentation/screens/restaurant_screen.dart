import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/services/noshmesh_api.dart';

final _availableOrdersProvider = FutureProvider<List<OrderModel>>((ref) {
  return ref.watch(noshMeshApiProvider).availableOrders();
});

final _activeOrdersProvider = FutureProvider<List<OrderModel>>((ref) {
  return ref.watch(noshMeshApiProvider).myRestaurantOrders();
});

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Available Orders'),
              Tab(text: 'Active Orders'),
            ],
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurface.withAlpha(128),
            indicatorColor: cs.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [
                _AvailableOrdersTab(),
                _ActiveOrdersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailableOrdersTab extends ConsumerWidget {
  const _AvailableOrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(_availableOrdersProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(_availableOrdersProvider.future),
      child: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders available right now'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, i) => _AvailableOrderCard(order: orders[i]),
              ),
      ),
    );
  }
}

class _AvailableOrderCard extends ConsumerWidget {
  final OrderModel order;
  const _AvailableOrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.cravingText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  'up to \$${order.budgetMax.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(128)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _showBidDialog(context, ref, order),
                icon: const Icon(Icons.local_offer_outlined, size: 18),
                label: const Text('Place Bid'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showBidDialog(
      BuildContext context, WidgetRef ref, OrderModel order) async {
    final mealCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final etaCtrl = TextEditingController(text: '30');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Place a Bid'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: mealCtrl,
                  decoration: const InputDecoration(labelText: 'Meal name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (\$)'),
                  validator: (v) {
                    final n = double.tryParse(v ?? '');
                    if (n == null || n <= 0) return 'Enter a valid price';
                    if (n > order.budgetMax) return 'Exceeds customer budget';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: etaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'ETA (minutes)'),
                  validator: (v) =>
                      (int.tryParse(v ?? '') == null) ? 'Enter minutes' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await ref.read(noshMeshApiProvider).placeBid(
                      orderUuid: order.uuid,
                      mealName: mealCtrl.text.trim(),
                      mealDescription: descCtrl.text.trim(),
                      price: double.parse(priceCtrl.text),
                      estimatedMinutes: int.parse(etaCtrl.text),
                    );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Bid placed!')),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Failed: $e')),
                  );
                }
              }
            },
            child: const Text('Submit Bid'),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrdersTab extends ConsumerWidget {
  const _ActiveOrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(_activeOrdersProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(_activeOrdersProvider.future),
      child: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No active orders'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, i) {
                  final o = orders[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(o.cravingText, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(o.deliveryAddress),
                      trailing: Chip(
                        label: Text(o.status),
                        backgroundColor: o.status == 'accepted'
                            ? Colors.blue[50]
                            : Colors.green[50],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
