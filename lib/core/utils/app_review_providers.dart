import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:noshmesh/core/constants/app_constants.dart';
import 'package:noshmesh/core/utils/app_review_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:noshmesh/l10n/l10n.dart';

/// Provider for the InAppReview instance
final inAppReviewProvider = Provider<InAppReview>((ref) {
  return InAppReview.instance;
});

/// Provider for the app review service
final appReviewServiceProvider = Provider<AppReviewService>((ref) {
  final inAppReview = ref.watch(inAppReviewProvider);
  final preferences = ref.watch(sharedPreferencesProvider);

  final service = AppReviewServiceImpl(
    inAppReview: inAppReview,
    preferences: preferences,
    minSessionsBeforeReview: AppConstants.minSessionsBeforeReview,
    minDaysBeforeReview: AppConstants.minDaysBeforeReview,
    minActionsBeforeReview: AppConstants.minActionsBeforeReview,
  );

  // Initialize the service
  service.init();

  return service;
});

/// Provider to check if a review should be requested
final shouldRequestReviewProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final reviewService = ref.watch(appReviewServiceProvider);
  return await reviewService.shouldRequestReview();
});

/// Provider for SharedPreferences - should be defined in your main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferencesProvider not initialized');
});

/// Smart review prompt that uses feedback before store reviews
class SmartReviewPrompt extends ConsumerWidget {
  /// The child widget
  final Widget child;

  /// Create a smart review prompt
  const SmartReviewPrompt({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<bool>>(shouldRequestReviewProvider, (_, state) {
      state.whenData((shouldRequest) {
        if (shouldRequest && context.mounted) {
          _showReviewFlow(context, ref);
        }
      });
    });

    return child;
  }

  Future<void> _showReviewFlow(BuildContext context, WidgetRef ref) async {
    final reviewService = ref.read(appReviewServiceProvider);

    // First, show a dialog to gauge satisfaction
    final shouldContinue =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.tr('enjoying_app')),
            content: Text(
              context.tr('share_feedback_question'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(context.tr('no_thanks')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(context.tr('sure')),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldContinue || !context.mounted) return;

    // Then, show feedback form
    final hasFeedback = await reviewService.showFeedbackForm(
      context: context,
      title: context.tr('feedback_matters'),
      message:
          context.tr('share_thoughts'),
    );

    // If user didn't provide feedback, prompt for review directly
    if (!hasFeedback) {
      await reviewService.requestReview();
    }
  }
}
