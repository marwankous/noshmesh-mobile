import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/providers/storage_provider.dart';
import 'package:noshmesh/core/services/noshmesh_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BiddingScreen extends ConsumerStatefulWidget {
  final String orderUuid;
  const BiddingScreen({super.key, required this.orderUuid});

  @override
  ConsumerState<BiddingScreen> createState() => _BiddingScreenState();
}

class _BiddingScreenState extends ConsumerState<BiddingScreen> {
  final List<BidModel> _bids = [];
  WebSocketChannel? _channel;
  Timer? _countdownTimer;
  int _secondsLeft = 90;
  bool _accepting = false;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    _loadBids();
    _connectWebSocket();
    _startCountdown();
  }

  Future<void> _loadBids() async {
    try {
      final bids = await ref.read(noshMeshApiProvider).bidsForOrder(widget.orderUuid);
      if (mounted) setState(() => _bids.addAll(bids));
    } catch (_) {}
  }

  Future<void> _connectWebSocket() async {
    final token = await ref.read(secureStorageServiceProvider).getAccessToken();
    if (token == null || !mounted) return;

    final wsUrl = AppConstants.apiBaseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    final uri = Uri.parse('$wsUrl/v1/ws/orders/${widget.orderUuid}?token=$token');

    try {
      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen(
        _onMessage,
        onError: (_) {},
        onDone: () {},
      );
    } catch (_) {}
  }

  void _onMessage(dynamic raw) {
    if (!mounted) return;
    try {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      if (msg['event'] == 'bid.new') {
        final payload = msg['payload'] as Map<String, dynamic>;
        setState(() {
          _bids.insert(0, BidModel.fromJson(payload));
        });
      } else if (msg['event'] == 'order.accepted') {
        setState(() => _expired = true);
      }
    } catch (_) {}
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft <= 0) {
        t.cancel();
        setState(() => _expired = true);
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  Future<void> _acceptBid(BidModel bid) async {
    setState(() => _accepting = true);
    try {
      await ref.read(noshMeshApiProvider).acceptBid(widget.orderUuid, bid.uuid);
      if (!mounted) return;
      context.pushReplacement(AppConstants.trackingRoute, extra: widget.orderUuid);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept: $e')),
      );
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bids coming in…'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          // Countdown banner
          Container(
            width: double.infinity,
            color: _expired
                ? cs.errorContainer
                : (_secondsLeft <= 20 ? Colors.orange[800] : cs.primary),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  _expired ? Icons.timer_off : Icons.timer,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _expired
                      ? 'Bidding window closed'
                      : 'Bids close in $_secondsLeft seconds',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Bids list
          Expanded(
            child: _bids.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          _expired ? 'No bids received.' : 'Waiting for bids…',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _bids.length,
                    itemBuilder: (context, i) => _BidCard(
                      bid: _bids[i],
                      canAccept: !_expired && !_accepting,
                      onAccept: () => _acceptBid(_bids[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  final BidModel bid;
  final bool canAccept;
  final VoidCallback onAccept;

  const _BidCard({
    required this.bid,
    required this.canAccept,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                    bid.restaurantName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: cs.primary,
                        ),
                  ),
                ),
                Text(
                  '\$${bid.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              bid.mealName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (bid.mealDescription.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(bid.mealDescription,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: cs.onSurface.withAlpha(128)),
                const SizedBox(width: 4),
                Text('~${bid.estimatedMinutes} min',
                    style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
                if (canAccept)
                  FilledButton(
                    onPressed: onAccept,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: const Text('Accept'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
