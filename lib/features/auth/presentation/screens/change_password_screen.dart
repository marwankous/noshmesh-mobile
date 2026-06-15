import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noshmesh/core/theme/app_theme_extension.dart';
import 'package:noshmesh/core/utils/app_utils.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:noshmesh/l10n/l10n.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    if (_isSubmitting) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      FocusScope.of(context).unfocus();

      try {
        await ref.read(authProvider.notifier).changePassword(
              currentPassword: _currentPasswordController.text,
              newPassword: _newPasswordController.text,
            );

        if (!mounted) return;
        final authState = ref.read(authProvider);

        if (authState.status == AuthStatus.error) {
          AppUtils.showSnackBar(
            context,
            message: authState.errorMessage ?? context.tr('password_changed_error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        } else {
          AppUtils.showSnackBar(
            context,
            message: context.tr('password_changed_success'),
            backgroundColor: Theme.of(context).colorScheme.statusSuccess,
          );
          Navigator.pop(context);
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('change_password')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr('update_your_security'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('ensure_account_secure'),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: !_isCurrentVisible,
                decoration: InputDecoration(
                  labelText: context.tr('current_password'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isCurrentVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isCurrentVisible = !_isCurrentVisible),
                  ),
                ),
                validator: (v) => v!.isEmpty ? context.tr('required') : null,
              ),
              const SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_isNewVisible,
                decoration: InputDecoration(
                  labelText: context.tr('new_password'),
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_isNewVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isNewVisible = !_isNewVisible),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.length < 8) {
                    return context.trParams('min_length', {'length': '8'});
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm New Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmVisible,
                decoration: InputDecoration(
                  labelText: context.tr('confirm_new_password'),
                  prefixIcon: const Icon(Icons.check_circle_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
                  ),
                ),
                validator: (v) {
                  if (v != _newPasswordController.text) {
                    return context.tr('passwords_dont_match');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: (authState.status == AuthStatus.loading || _isSubmitting) ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: authState.status == AuthStatus.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.tr('change')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
