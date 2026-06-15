import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/ui/buttons/app_button.dart';
import 'package:noshmesh/core/ui/noshmesh_logo.dart';
import 'package:noshmesh/core/ui/inputs/app_text_field.dart';
import 'package:noshmesh/core/utils/app_utils.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:noshmesh/features/auth/presentation/widgets/google_auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      await ref.read(authProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.error) {
        final msg = authState.errorMessage!;
        final isEmailTaken = msg.toLowerCase().contains('already exists') ||
            msg.toLowerCase().contains('already in use');
        AppUtils.showSnackBar(
          context,
          message: isEmailTaken
              ? 'An account with this email already exists.'
              : msg,
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: isEmailTaken
              ? const Duration(seconds: 6)
              : const Duration(seconds: 3),
          action: isEmailTaken
              ? SnackBarAction(
                  label: 'Sign in',
                  textColor: Colors.white,
                  onPressed: () => context.go(AppConstants.loginRoute),
                )
              : null,
        );
      } else if (authState.status == AuthStatus.pendingVerification) {
        context.go(AppConstants.verifyOtpRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'Create your account',
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                  prefixIcon: const Icon(Icons.person_outline),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password is required' : null,
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: 'Create account',
                  onPressed: ref.watch(authProvider).status == AuthStatus.loading ? null : _register,
                  isLoading: ref.watch(authProvider).status == AuthStatus.loading,
                ),
                const SizedBox(height: 16),
                const OrDivider(),
                const SizedBox(height: 16),
                GoogleSignInButton(
                  onPressed: ref.watch(authProvider).status == AuthStatus.loading ? null : _googleLogin,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppConstants.loginRoute),
                      child: const Text('Sign in'),
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
