import 'package:noshmesh/core/network/connectivity_provider.dart';
import 'package:noshmesh/core/ui/navigation/app_bottom_navigation_bar.dart';
import 'package:noshmesh/core/ui/widgets/app_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:noshmesh/l10n/l10n.dart';

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider).value ?? true;

    ref.listen<AsyncValue<bool>>(connectivityProvider, (prev, next) {
      if (prev == null) return;
      final wasOnline = prev.value ?? true;
      final nowOnline = next.value ?? true;
      if (wasOnline == nowOnline) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(nowOnline ? 'Back online' : 'You\'re offline'),
          duration: const Duration(seconds: 3),
          backgroundColor: nowOnline ? Colors.green[700] : Colors.red[700],
        ),
      );
    });

    return Scaffold(
      appBar: const AppTopBar(),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isOnline
                ? const SizedBox.shrink(key: ValueKey('online'))
                : Container(
                    key: const ValueKey('offline-banner'),
                    width: double.infinity,
                    color: const Color(0xFF212121),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'No internet connection',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onItemSelected: _goBranch,
        items: [
          AppNavItem(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: context.tr('craving_tab'),
          ),
          AppNavItem(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: context.tr('orders_tab'),
          ),
          AppNavItem(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: context.tr('restaurant_tab'),
          ),
        ],
      ),
    );
  }
}
