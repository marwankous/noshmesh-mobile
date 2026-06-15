import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noshmesh/core/providers/storage_providers.dart';
import 'package:noshmesh/core/providers/theme_providers.dart';
import 'package:noshmesh/core/utils/app_utils.dart';
import 'package:noshmesh/core/ui/widgets/app_avatar.dart';
import 'package:noshmesh/core/services/payment_service.dart';
import 'package:noshmesh/features/auth/domain/entities/user_entity.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:noshmesh/core/theme/app_theme_extension.dart';
import 'package:intl/intl.dart';

// ── Generation defaults provider ─────────────────────────────────────────────

const _kPublishImmediatelyKey = 'generation_publish_immediately';

class _PublishImmediatelyNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(sharedPreferencesProvider).getBool(_kPublishImmediatelyKey) ?? false;

  void toggle() {
    state = !state;
    ref.read(sharedPreferencesProvider).setBool(_kPublishImmediatelyKey, state);
  }
}

final publishImmediatelyProvider = NotifierProvider<_PublishImmediatelyNotifier, bool>(
  _PublishImmediatelyNotifier.new,
);

// ── Variant IDs ───────────────────────────────────────────────────────────────

const _basicMonthlyVariantId = 1725878;
const _basicYearlyVariantId  = 1725879;
const _proMonthlyVariantId   = 1725880;
const _proYearlyVariantId    = 1725881;

// ── Profile screen ────────────────────────────────────────────────────────────

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _profileSaving = false;

  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _pwSaving = false;
  String? _pwError;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool _yearlyBilling = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null) {
      _nameCtrl.text = user.name;
      _emailCtrl.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    if (name.isEmpty || email.isEmpty) return;
    setState(() => _profileSaving = true);
    await ref.read(authProvider.notifier).updateProfile(name: name, email: email);
    if (!mounted) return;
    setState(() => _profileSaving = false);
    final s = ref.read(authProvider);
    if (s.status == AuthStatus.error) {
      AppUtils.showSnackBar(context,
          message: s.errorMessage ?? 'Failed to update profile',
          backgroundColor: Theme.of(context).colorScheme.error);
    } else {
      AppUtils.showSnackBar(context, message: 'Profile updated',
          backgroundColor: Theme.of(context).colorScheme.statusSuccess);
    }
  }

  Future<void> _savePassword() async {
    final cur = _currentPwCtrl.text;
    final nw = _newPwCtrl.text;
    final cf = _confirmPwCtrl.text;
    if (cur.isEmpty || nw.isEmpty || cf.isEmpty) {
      setState(() => _pwError = 'Please fill in all fields');
      return;
    }
    if (nw != cf) {
      setState(() => _pwError = 'Passwords do not match');
      return;
    }
    if (nw.length < 8) {
      setState(() => _pwError = 'Password must be at least 8 characters');
      return;
    }
    setState(() { _pwSaving = true; _pwError = null; });
    await ref.read(authProvider.notifier).changePassword(currentPassword: cur, newPassword: nw);
    if (!mounted) return;
    setState(() => _pwSaving = false);
    final s = ref.read(authProvider);
    if (s.status == AuthStatus.error) {
      setState(() => _pwError = s.errorMessage ?? 'Failed to change password');
    } else {
      _currentPwCtrl.clear();
      _newPwCtrl.clear();
      _confirmPwCtrl.clear();
      AppUtils.showSnackBar(context, message: 'Password changed',
          backgroundColor: Theme.of(context).colorScheme.statusSuccess);
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openCheckout(int variantId) async {
    try {
      final url = await ref.read(paymentServiceProvider).createCheckoutUrl(variantId);
      await _launch(url);
    } catch (_) {
      if (mounted) {
        AppUtils.showSnackBar(context,
            message: 'Could not open checkout. Please try again.',
            backgroundColor: Theme.of(context).colorScheme.error);
      }
    }
  }

  void _showDeleteDialog() {
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure? This will permanently delete your account and all associated data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).deleteAccount();
              if (!mounted) return;
              final s = ref.read(authProvider);
              if (s.status == AuthStatus.error) {
                AppUtils.showSnackBar(context,
                    message: s.errorMessage ?? 'Failed to delete account',
                    backgroundColor: Theme.of(context).colorScheme.error);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: cs.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final planName = user.plan.name.isNotEmpty ? user.plan.name : 'Free';
    final isFree  = planName.toLowerCase() == 'free';
    final isBasic = planName.toLowerCase() == 'basic';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // ── Profile ──────────────────────────────────────────────────────────
          _SectionLabel(label: 'Profile'),
          const SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                Row(
                  children: [
                    AppAvatar(name: user.name, radius: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(user.email,
                              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SettingsField(label: 'Name', controller: _nameCtrl, hint: 'Your name'),
                const SizedBox(height: 12),
                _SettingsField(
                    label: 'Email', controller: _emailCtrl,
                    hint: 'your@email.com', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _profileSaving ? null : _saveProfile,
                    child: _profileSaving
                        ? SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.onPrimary))
                        : const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Plan & Usage ─────────────────────────────────────────────────────
          _SectionLabel(label: 'Plan & Usage'),
          const SizedBox(height: 8),
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(planName,
                          style: tt.labelMedium?.copyWith(
                              color: cs.onPrimaryContainer, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(color: cs.statusSuccess, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('Active',
                        style: tt.bodySmall?.copyWith(color: cs.statusSuccess)),
                    const Spacer(),
                    Text(
                      'Resets ${DateFormat('MM/dd/yyyy').format(user.tokenResetDate)}',
                      style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _TokenBar(user: user),
                const SizedBox(height: 16),
                _LimitsGrid(user: user),
                if (isFree || isBasic) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Billing:'),
                      const SizedBox(width: 10),
                      _BillingToggle(
                        isYearly: _yearlyBilling,
                        onToggle: (v) => setState(() => _yearlyBilling = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Basic card — only shown to Free users
                      if (isFree) ...[
                        Expanded(
                          child: _UpgradeCard(
                            title: 'Basic',
                            price: _yearlyBilling ? r'$150/yr' : r'$15/mo',
                            isPrimary: false,
                            onUpgrade: () => _openCheckout(
                                _yearlyBilling ? _basicYearlyVariantId : _basicMonthlyVariantId),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      // Pro card — shown to Free and Basic users
                      Expanded(
                        child: _UpgradeCard(
                          title: 'Pro',
                          price: _yearlyBilling ? r'$290/yr' : r'$29/mo',
                          isPrimary: true,
                          onUpgrade: () => _openCheckout(
                              _yearlyBilling ? _proYearlyVariantId : _proMonthlyVariantId),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Appearance ───────────────────────────────────────────────────────
          _SectionLabel(label: 'Appearance'),
          const SizedBox(height: 8),
          _Card(child: _AppearanceRow()),

          const SizedBox(height: 24),

          // ── Generation Defaults ──────────────────────────────────────────────
          _SectionLabel(label: 'Generation Defaults'),
          const SizedBox(height: 8),
          _Card(child: _GenerationDefaultsRow()),

          const SizedBox(height: 24),

          // ── Change Password ──────────────────────────────────────────────────
          _SectionLabel(label: 'Change Password'),
          const SizedBox(height: 8),
          _Card(
            child: Column(
              children: [
                _PasswordField(
                  label: 'Current Password',
                  controller: _currentPwCtrl,
                  obscure: !_showCurrent,
                  onToggle: () => setState(() => _showCurrent = !_showCurrent),
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  label: 'New Password',
                  controller: _newPwCtrl,
                  obscure: !_showNew,
                  onToggle: () => setState(() => _showNew = !_showNew),
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  label: 'Confirm New Password',
                  controller: _confirmPwCtrl,
                  obscure: !_showConfirm,
                  onToggle: () => setState(() => _showConfirm = !_showConfirm),
                ),
                if (_pwError != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_pwError!,
                        style: tt.bodySmall?.copyWith(color: cs.onErrorContainer)),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _pwSaving ? null : _savePassword,
                    child: _pwSaving
                        ? SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).colorScheme.onPrimary))
                        : const Text('Save Password'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Sign Out ─────────────────────────────────────────────────────────
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          ),

          const SizedBox(height: 24),

          // ── Danger Zone ──────────────────────────────────────────────────────
          _SectionLabel(label: 'Danger Zone', color: cs.error),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: cs.error.withValues(alpha: 0.35)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delete Account',
                    style: tt.titleSmall?.copyWith(
                        color: cs.error, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Permanently deletes your account and all data.',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _showDeleteDialog,
                  style: FilledButton.styleFrom(backgroundColor: cs.error),
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 0),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.8),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: child,
    );
  }
}

class _SettingsField extends StatelessWidget {
  const _SettingsField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 18),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}

class _TokenBar extends StatelessWidget {
  const _TokenBar({required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final used = user.monthlyTokensUsed;
    final max = user.plan.maxMonthlyTokens;
    final progress = max > 0 ? (used / max).clamp(0.0, 1.0) : 0.0;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final color = progress > 0.9 ? cs.statusCritical : progress > 0.7 ? cs.statusWarning : cs.primary;
    final pct = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monthly Tokens', style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w500)),
            Text('$used / $max  ($pct%)',
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _LimitsGrid extends StatelessWidget {
  const _LimitsGrid({required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final plan = user.plan;
    final items = [
      ('Tokens/mo', _fmt(plan.maxMonthlyTokens)),
      ('RSS Feeds', _fmt(plan.maxFeedSubscriptions)),
      ('Art/Merge', _fmt(plan.maxArticlesPerMerge)),
      ('Endpoints', _fmt(plan.maxExternalEndpoints)),
    ];
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(item.$2,
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.$1,
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _fmt(int n) => n >= 1000000 ? '${(n / 1000000).round()}M' : n >= 1000 ? '${(n / 1000).round()}K' : '$n';
}

class _BillingToggle extends StatelessWidget {
  const _BillingToggle({required this.isYearly, required this.onToggle});
  final bool isYearly;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Tab(label: 'Monthly', active: !isYearly, onTap: () => onToggle(false)),
          _Tab(label: 'Yearly', active: isYearly, onTap: () => onToggle(true)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: active ? cs.onPrimary : cs.onSurfaceVariant,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    required this.title,
    required this.price,
    this.savings,
    required this.isPrimary,
    required this.onUpgrade,
  });
  final String title;
  final String price;
  final String? savings;
  final bool isPrimary;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final bgColor = isPrimary ? cs.primaryContainer : cs.surfaceContainerHigh;
    final borderColor = isPrimary ? cs.primary.withValues(alpha: 0.4) : cs.outlineVariant;
    final textOnBg = isPrimary ? cs.onPrimaryContainer : cs.onSurface;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: textOnBg)),
          if (savings != null) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: cs.statusSuccess.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(savings!,
                  style: tt.labelSmall?.copyWith(
                      color: cs.statusSuccess, fontWeight: FontWeight.w600)),
            ),
          ],
          const SizedBox(height: 4),
          Text(price,
              style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800, color: textOnBg)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onUpgrade,
              style: isPrimary
                  ? FilledButton.styleFrom(
                      backgroundColor: cs.onPrimaryContainer,
                      foregroundColor: cs.primaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                    )
                  : FilledButton.styleFrom(
                      backgroundColor: cs.onSurface.withValues(alpha: 0.15),
                      foregroundColor: cs.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
              child: const Text('Upgrade'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.dark_mode_outlined, size: 20, color: cs.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge),
        ),
        Switch(
          value: themeMode == ThemeMode.dark,
          onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
          activeThumbColor: cs.primary,
        ),
      ],
    );
  }
}

class _GenerationDefaultsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publishImmediately = ref.watch(publishImmediatelyProvider);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(Icons.publish_outlined, size: 20, color: cs.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Publish Immediately', style: tt.bodyLarge),
              Text(
                publishImmediately
                    ? 'Generated content is published right away'
                    : 'Generated content is saved as draft',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Switch(
          value: publishImmediately,
          onChanged: (_) => ref.read(publishImmediatelyProvider.notifier).toggle(),
          activeThumbColor: cs.primary,
        ),
      ],
    );
  }
}
