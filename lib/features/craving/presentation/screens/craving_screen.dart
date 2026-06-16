import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/services/noshmesh_api.dart';

class CravingScreen extends ConsumerStatefulWidget {
  const CravingScreen({super.key});

  @override
  ConsumerState<CravingScreen> createState() => _CravingScreenState();
}

class _CravingScreenState extends ConsumerState<CravingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cravingController = TextEditingController();
  final _addressController = TextEditingController();
  double _budget = 20.0;
  bool _loading = false;

  @override
  void dispose() {
    _cravingController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final api = ref.read(noshMeshApiProvider);
      final orderUuid = await api.createOrder(
        cravingText: _cravingController.text.trim(),
        budgetMax: _budget,
        deliveryAddress: _addressController.text.trim(),
      );
      if (!mounted) return;
      context.push(AppConstants.biddingRoute, extra: orderUuid);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post craving: ${_extractMessage(e)}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _extractMessage(Object e) {
    final str = e.toString();
    final msg = RegExp(r'"message":"([^"]+)"').firstMatch(str)?.group(1);
    return msg ?? str;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  'What are you craving?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Describe your meal and nearby restaurants will bid to make it for you.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withAlpha(153),
                      ),
                ),
                const SizedBox(height: 32),

                // Craving description
                TextFormField(
                  controller: _cravingController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Describe your craving',
                    hintText: 'e.g. Spicy lamb burger with crispy fries, extra sauce…',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().length < 10) ? 'Please describe your craving (min 10 chars)' : null,
                ),
                const SizedBox(height: 24),

                // Budget slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Max budget', style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      '\$${_budget.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                    ),
                  ],
                ),
                Slider(
                  value: _budget,
                  min: 5,
                  max: 200,
                  divisions: 39,
                  label: '\$${_budget.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _budget = v),
                ),
                const SizedBox(height: 24),

                // Delivery address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Delivery address',
                    hintText: '123 Main St, City',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Delivery address is required' : null,
                ),
                const SizedBox(height: 40),

                // Submit
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Post Craving', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
