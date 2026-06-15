import 'package:noshmesh/core/error/failures.dart';

class ErrorMapper {
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No connection. Check your internet and try again.';
    }
    if (failure is CacheFailure) {
      return 'Failed to load local data.';
    }
    if (failure is TimeoutFailure) {
      return 'Server took too long to respond. Please try again.';
    }

    if (failure is ServerFailure) {
      // Check by status code first — more reliable than string matching
      final code = failure.statusCode;
      if (code == 403) {
        return "Your plan doesn't include this feature. Upgrade to continue.";
      }
      if (code == 401) return 'Your session has expired. Please sign in again.';
      if (code == 402) return "You've reached your plan limit. Upgrade to continue.";
      if (code == 429) return 'Too many requests. Please slow down and try again.';
      if (code != null && code >= 500) {
        return 'Something went wrong on our end. Please try again.';
      }
      if (code == 404) return 'The requested resource was not found.';
      if (code == 409) return 'A conflict occurred. Please try again.';

      // Fall back to message-content inspection for cases without a status code
      final msg = failure.message;
      final lower = msg.toLowerCase();

      if (lower.contains('access denied') ||
          lower.contains('missing required permission') ||
          lower.contains('forbidden')) {
        return "Your plan doesn't include this feature. Upgrade to continue.";
      }
      if (lower.contains('unauthorized') || lower.contains('credentials')) {
        return 'Invalid email or password.';
      }
      if (lower.contains('timeout')) {
        return 'Server took too long to respond. Please try again.';
      }

      // Return the backend message if it looks like intentional user-facing copy
      if (msg.isNotEmpty &&
          !lower.contains('status code') &&
          !lower.contains('500') &&
          !lower.contains('404') &&
          msg.length < 200) {
        return msg;
      }

      return 'Something went wrong. Please try again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
