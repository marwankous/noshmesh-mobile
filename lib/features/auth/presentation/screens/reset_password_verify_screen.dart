import 'dart:async';

import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/ui/buttons/app_button.dart';
import 'package:noshmesh/core/ui/noshmesh_logo.dart';
import 'package:noshmesh/core/utils/app_utils.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordVerifyScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordVerifyScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordVerifyScreen> createState() =>
      _ResetPasswordVerifyScreenState();
}

class _ResetPasswordVerifyScreenState
    extends ConsumerState<ResetPasswordVerifyScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<FocusNode> _keyboardListenerNodes =
      List.generate(6, (_) => FocusNode(skipTraversal: true));

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  Timer? _expireTimer;
  Timer? _resendTimer;
  int _secondsLeft = 600;
  int _resendCooldown = 60;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 24).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _startTimers();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    for (final f in _keyboardListenerNodes) f.dispose();
    _shakeController.dispose();
    _expireTimer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startTimers() {
    _expireTimer?.cancel();
    _resendTimer?.cancel();
    _expireTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _expireTimer?.cancel();
      }
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_resendCooldown > 0) {
        setState(() => _resendCooldown--);
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  String get _currentCode => _controllers.map((c) => c.text).join();
  bool get _isFilled => _currentCode.length == 6;
  String _fmt(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  void _onDigitInput(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      _focusNodes[5].requestFocus();
      setState(() {});
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _shake() {
    _shakeController.reset();
    _shakeController.forward();
  }

  Future<void> _verify() async {
    setState(() => _errorMessage = null);
    await ref.read(authProvider.notifier).verifyPasswordOtp(
          email: widget.email,
          code: _currentCode,
        );
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.status == AuthStatus.error) {
      final msg = s.errorMessage ?? 'Verification failed.';
      setState(() => _errorMessage = msg);
      if (msg.toLowerCase().contains('too many') ||
          msg.toLowerCase().contains('expired')) {
        for (final c in _controllers) c.clear();
        _focusNodes[0].requestFocus();
        setState(() => _resendCooldown = 0);
      } else {
        _shake();
      }
    } else {
      final resetToken = s.pendingPasswordResetToken ?? '';
      if (resetToken.isEmpty) {
        setState(() => _errorMessage = 'Verification failed. Please try again.');
        _shake();
        return;
      }
      context.push(
        AppConstants.resetPasswordRoute,
        extra: {'reset_token': resetToken},
      );
    }
  }

  Future<void> _resend() async {
    await ref.read(authProvider.notifier).forgotPassword(email: widget.email);
    if (!mounted) return;
    final s = ref.read(authProvider);
    if (s.status == AuthStatus.error) {
      AppUtils.showSnackBar(
        context,
        message: s.errorMessage ?? 'Could not resend code.',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } else {
      for (final c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
      setState(() {
        _errorMessage = null;
        _secondsLeft = 600;
        _resendCooldown = 60;
      });
      _startTimers();
      AppUtils.showSnackBar(context, message: 'A new code has been sent.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLoading = ref.watch(authProvider).status == AuthStatus.loading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              const Center(child: NoshMeshWordmark(height: 48)),
              const SizedBox(height: 32),
              Text(
                'Check your email',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF09090B),
                    ),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to\n'),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF09090B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final t = _shakeController.value;
                  final offset = t == 0
                      ? 0.0
                      : _shakeAnimation.value * (t < 0.5 ? 1 : -1) * (1 - t);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    final filled = _controllers[i].text.isNotEmpty;
                    final hasError = _errorMessage != null;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 44,
                        height: 52,
                        child: KeyboardListener(
                          focusNode: _keyboardListenerNodes[i],
                          onKeyEvent: (e) => _onKeyDown(i, e),
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF09090B),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: hasError
                                      ? cs.error
                                      : filled
                                          ? const Color(0xFFFF5722)
                                          : const Color(0xFFE4E4E7),
                                  width: filled ? 2 : 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: hasError
                                      ? cs.error
                                      : const Color(0xFFFF5722),
                                  width: 2,
                                ),
                              ),
                              filled: !filled,
                              fillColor: const Color(0xFFF4F4F5),
                            ),
                            onChanged: (v) => _onDigitInput(i, v),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(fontSize: 13, color: cs.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Code expires in ${_fmt(_secondsLeft)}',
                style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Verify',
                  onPressed: (_isFilled && !isLoading) ? _verify : null,
                  isLoading: isLoading,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get a code? ",
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                  if (_resendCooldown > 0)
                    Text(
                      'Resend in ${_fmt(_resendCooldown)}',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFA1A1AA)),
                    )
                  else
                    GestureDetector(
                      onTap: _resend,
                      child: const Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Wrong email? Go back',
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
