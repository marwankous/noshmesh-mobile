import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/ui/noshmesh_logo.dart';
import 'package:noshmesh/core/ui/widgets/app_avatar.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.actions,
    this.showAvatar = true,
    this.automaticallyImplyLeading = false,
  });

  final String? title;
  final List<Widget>? actions;
  final bool showAvatar;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleSpacing: 16,
      title: Row(
        children: [
          const NoshMeshWordmark(height: 32),
          if (title != null) ...[
            const SizedBox(width: 8),
            Text(
              title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: cs.onSurface,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (actions != null) ...actions!,
        if (showAvatar)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => context.push(AppConstants.profileRoute),
              child: AppAvatar(name: user?.name ?? '', radius: 16),
            ),
          ),
      ],
    );
  }
}
