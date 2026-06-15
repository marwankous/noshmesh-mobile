import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/ui/buttons/app_button.dart';
import 'package:noshmesh/core/ui/inputs/app_text_field.dart';
import 'package:noshmesh/core/utils/app_utils.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:noshmesh/features/auth/presentation/widgets/google_auth_widgets.dart';
import 'package:noshmesh/core/ui/noshmesh_logo.dart';
import 'package:noshmesh/l10n/l10n.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _googleLogin() async {
    FocusScope.of(context).unfocus();
    await ref.read(authProvider.notifier).googleLogin();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState.status == AuthStatus.error && authState.errorMessage != null) {
      // ignore: use_build_context_synchronously
      AppUtils.showSnackBar(
        context,
        message: authState.errorMessage!,
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Close keyboard
      FocusScope.of(context).unfocus();

      // Get email and password
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Call login method from auth provider
      await ref
          .read(authProvider.notifier)
          .login(email: email, password: password);

      // Check if login was successful
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.error) {
        // Show error message if login failed
        if (!mounted) return;

        // ignore: use_build_context_synchronously
        AppUtils.showSnackBar(
          context,
          message: authState.errorMessage!,
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } else if (authState.status == AuthStatus.pendingVerification) {
        if (!mounted) return;
        context.go(AppConstants.verifyOtpRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 64),
                const Center(child: NoshMeshWordmark(height: 48)),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    context.tr('sign_in_subtitle'),
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _emailController,
                  label: context.tr('email'),
                  hint: context.tr('enter_email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) return context.tr('email_required');
                    if (!AppUtils.isValidEmail(value)) return context.tr('invalid_email');
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: context.tr('password'),
                  hint: context.tr('enter_password'),
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return context.tr('required');
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(AppConstants.forgotPasswordRoute),
                    child: Text(context.tr('forgot_password')),
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: context.tr('login'),
                  onPressed: authState.status == AuthStatus.loading ? null : _login,
                  isLoading: authState.status == AuthStatus.loading,
                ),
                const SizedBox(height: 16),
                const OrDivider(),
                const SizedBox(height: 16),
                GoogleSignInButton(
                  onPressed: authState.status == AuthStatus.loading ? null : _googleLogin,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('no_account'),
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppConstants.registerRoute),
                      child: Text(context.tr('sign_up')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

