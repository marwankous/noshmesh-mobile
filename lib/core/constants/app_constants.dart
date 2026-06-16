class AppConstants {
  // API
  // 10.0.2.2 is the Android emulator loopback to the host machine
  static const String apiBaseUrl = 'http://10.0.2.2:8080';

  // Storage
  static const String tokenKey = 'authToken';
  static const String userDataKey = 'userData';
  static const String refreshTokenKey = 'refreshToken';

  // App
  static const String appName = 'NoshMesh';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.noshmesh.app';

  // Timeouts (ms)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Routes
  static const String homeRoute            = '/';
  static const String orderRoute           = '/order';
  static const String biddingRoute         = '/order/bidding';
  static const String trackingRoute        = '/order/tracking';
  static const String restaurantRoute      = '/restaurant';
  static const String loginRoute           = '/login';
  static const String registerRoute        = '/register';
  static const String forgotPasswordRoute  = '/forgot-password';
  static const String resetPasswordRoute   = '/reset-password';
  static const String resetPasswordVerifyRoute = '/reset-password/verify';
  static const String verifyOtpRoute       = '/verify-otp';
  static const String changePasswordRoute  = '/change-password';
  static const String profileRoute         = '/profile';
  static const String settingsRoute        = '/settings';
  static const String languageSettingsRoute = '/settings/language';

  // Hive boxes
  static const String settingsBox   = 'settings';
  static const String cacheBox      = 'cache';
  static const String offlineSyncBox = 'offlineSync';

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Accessibility
  static const Duration accessibilityTooltipDuration = Duration(seconds: 5);
  static const double accessibilityTouchTargetMinSize = 48.0;

  // App review
  static const int minSessionsBeforeReview = 5;
  static const int minDaysBeforeReview = 7;
  static const int minActionsBeforeReview = 10;
}
