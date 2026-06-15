import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/logging/logger_provider.dart';
import 'package:noshmesh/core/providers/localization_providers.dart';
import 'package:noshmesh/core/router/locale_aware_router.dart';
import 'package:noshmesh/core/router/navigator_keys.dart';
import 'package:noshmesh/core/ui/main_wrapper.dart';
import 'package:noshmesh/features/auth/presentation/providers/auth_provider.dart';
import 'package:noshmesh/features/auth/presentation/screens/change_password_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/login_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/profile_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/register_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/reset_password_verify_screen.dart';
import 'package:noshmesh/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:noshmesh/features/craving/presentation/screens/bidding_screen.dart';
import 'package:noshmesh/features/craving/presentation/screens/craving_screen.dart';
import 'package:noshmesh/features/orders/presentation/screens/orders_screen.dart';
import 'package:noshmesh/features/restaurant/presentation/screens/restaurant_screen.dart';
import 'package:noshmesh/features/settings/presentation/screens/language_settings_screen.dart';
import 'package:noshmesh/features/tracking/presentation/screens/tracking_screen.dart';
import 'package:noshmesh/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthNotifierListenable extends ChangeNotifier {
  final Ref ref;
  AuthNotifierListenable(this.ref) {
    ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthNotifierListenable(ref);
  final logger = ref.watch(loggerProvider).child('Router');
  ref.watch(persistentLocaleProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppConstants.homeRoute,
    debugLogDiagnostics: true,
    refreshListenable: authListenable,
    observers: [ref.read(localizationRouterObserverProvider)],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final status = authState.status;
      final location = state.matchedLocation;

      logger.d('Redirect check: status=$status, location=$location');

      final isAuthRoute = location == AppConstants.loginRoute ||
          location == AppConstants.registerRoute ||
          location == AppConstants.forgotPasswordRoute ||
          location == AppConstants.resetPasswordRoute ||
          location == AppConstants.resetPasswordVerifyRoute ||
          location == AppConstants.verifyOtpRoute;

      if (status == AuthStatus.loading) return null;

      if (status == AuthStatus.pendingVerification && !isAuthRoute) {
        return AppConstants.verifyOtpRoute;
      }

      if (status == AuthStatus.unauthenticated && !isAuthRoute) {
        return AppConstants.loginRoute;
      }

      if (status == AuthStatus.authenticated && isAuthRoute) {
        return AppConstants.homeRoute;
      }

      return null;
    },
    routes: [
      // ── Authenticated shell (3 tabs) ───────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainWrapper(navigationShell: shell),
        branches: [
          // Tab 0 — Craving (home)
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.homeRoute,
              name: 'craving',
              builder: (context, state) => const CravingScreen(),
            ),
          ]),

          // Tab 1 — Orders
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.orderRoute,
              name: 'orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ]),

          // Tab 2 — Restaurant (staff)
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppConstants.restaurantRoute,
              name: 'restaurant',
              builder: (context, state) => const RestaurantScreen(),
            ),
          ]),
        ],
      ),

      // ── Bidding (pushed from craving) ─────────────────────────────────────
      GoRoute(
        path: AppConstants.biddingRoute,
        name: 'bidding',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final uuid = state.extra as String;
          return BiddingScreen(orderUuid: uuid);
        },
      ),

      // ── Tracking (pushed from orders / bidding) ────────────────────────────
      GoRoute(
        path: AppConstants.trackingRoute,
        name: 'tracking',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final uuid = state.extra as String;
          return TrackingScreen(orderUuid: uuid);
        },
      ),

      // ── Settings ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppConstants.settingsRoute,
        name: 'settings',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'language',
            name: 'language-settings',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const LanguageSettingsScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: AppConstants.changePasswordRoute,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),

      // ── Auth routes ────────────────────────────────────────────────────────
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.forgotPasswordRoute,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.resetPasswordRoute,
        name: 'reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final token = extra?['reset_token'] as String?;
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: AppConstants.resetPasswordVerifyRoute,
        name: 'reset-password-verify',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordVerifyScreen(email: email);
        },
      ),
      GoRoute(
        path: AppConstants.verifyOtpRoute,
        name: 'verify-otp',
        builder: (context, state) => const VerifyOtpScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.tr('page_not_found'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(context.trParams(
                'page_path_not_found', {'path': state.uri.path})),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: Text(context.tr('go_home')),
            ),
          ],
        ),
      ),
    ),
  );
});
