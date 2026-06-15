// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NoshMesh';

  @override
  String get welcomeMessage => 'Welcome to NoshMesh';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

  @override
  String get language => 'Language';

  @override
  String get change_language => 'Change application language';

  @override
  String get theme => 'Theme';

  @override
  String get change_theme => 'Change application theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get notification_settings => 'Configure notification preferences';

  @override
  String get localization_demo => 'Localization Demo';

  @override
  String get localization_demo_description =>
      'View localization features in action';

  @override
  String get language_settings => 'Language Settings';

  @override
  String get select_your_language => 'Select your preferred language';

  @override
  String get language_explanation =>
      'The selected language will be applied across the entire application';

  @override
  String get localization_assets_demo => 'Localization & Assets Demo';

  @override
  String get current_language => 'Current Language';

  @override
  String get language_code => 'Language code';

  @override
  String get language_name => 'Language name';

  @override
  String get formatting_examples => 'Formatting Examples';

  @override
  String get date_full => 'Date (full)';

  @override
  String get date_short => 'Date (short)';

  @override
  String get time => 'Time';

  @override
  String get currency => 'Currency';

  @override
  String get percent => 'Percent';

  @override
  String get localized_assets => 'Localized Assets';

  @override
  String get localized_assets_explanation =>
      'This section demonstrates how to load different assets based on the selected language. Images, audio, and other resources can be language-specific.';

  @override
  String get image_example => 'Localized Image Example';

  @override
  String get welcome_image_caption =>
      'This image is loaded based on your selected language';

  @override
  String get common_image_example => 'Common Image Example';

  @override
  String get common_image_caption =>
      'This image is the same across all languages';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get content_not_found => 'Content not found';

  @override
  String get content_not_found_generic =>
      'Content not found or an error occurred while fetching it.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String greeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String itemCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Last updated: $dateString';
  }

  @override
  String get content_published_successfully => 'Content published successfully';

  @override
  String get clear_all => 'Clear All';

  @override
  String get search_articles => 'Search articles...';

  @override
  String get enter_email => 'Enter your email';

  @override
  String get enter_password => 'Enter your password';

  @override
  String get no_matching_articles_found => 'No matching articles found.';

  @override
  String get selected => 'Selected';

  @override
  String get select => 'Select';

  @override
  String get filter_by_source => 'Filter by Source';

  @override
  String get clear_all_filters => 'Clear All Filters';

  @override
  String get select_all => 'Select All';

  @override
  String get unselect_all => 'Unselect All';

  @override
  String get merge => 'Merge';

  @override
  String get external_endpoints => 'External Endpoints';

  @override
  String get manage_endpoints => 'Manage your integrated platforms';

  @override
  String get change_password => 'Change Password';

  @override
  String get current_password => 'Current Password';

  @override
  String get new_password => 'New Password';

  @override
  String get confirm_new_password => 'Confirm New Password';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get profile_updated => 'Profile updated successfully';

  @override
  String get update_profile_failed => 'Failed to update profile';

  @override
  String get name => 'Name';

  @override
  String get name_required => 'Name is required';

  @override
  String get email_required => 'Email is required';

  @override
  String get invalid_email => 'Invalid email';

  @override
  String get required => 'Required';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get reset_password_instruction =>
      'Enter your email to receive a password reset link.';

  @override
  String get reset_your_password => 'Reset Your Password';

  @override
  String get back_to_login => 'Back to Login';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get reset_token => 'Reset Token';

  @override
  String get reset_token_hint => 'Paste the token from your email';

  @override
  String get enter_reset_token => 'Please enter the reset token';

  @override
  String get password_reset_success => 'Password reset successfully';

  @override
  String get failed_to_reset_password => 'Failed to reset password';

  @override
  String get verify_email => 'Verify Email';

  @override
  String get check_your_email => 'Check your email';

  @override
  String get verification_code_sent =>
      'We sent a verification code to your email';

  @override
  String get verification_code => 'Verification Code';

  @override
  String get enter_6_digit_code => 'Enter the 6-digit code';

  @override
  String get enter_verification_code => 'Please enter the verification code';

  @override
  String get code_must_be_6_digits => 'The code must be 6 digits';

  @override
  String get verify => 'Verify';

  @override
  String get resend_code => 'Resend Code';

  @override
  String get reset_link_sent =>
      'If an account with that email exists, a password reset link has been sent.';

  @override
  String get passwords_dont_match => 'Passwords do not match';

  @override
  String get update_your_security => 'Update your security';

  @override
  String get ensure_account_secure =>
      'Ensure your account stays secure by using a strong password.';

  @override
  String get password_changed_success => 'Password changed successfully';

  @override
  String get password_changed_error => 'Failed to change password';

  @override
  String get ai_text_generation => 'AI Text Generation';

  @override
  String get quota_exceeded_web_upgrade =>
      'Quota exceeded. Please visit our website to upgrade your plan and continue.';

  @override
  String get monthly_limit_reached_web_upgrade =>
      'Monthly limit reached. Please visit our website to upgrade your plan.';

  @override
  String get enter_your_prompt => 'Enter your prompt';

  @override
  String get generate => 'Generate';

  @override
  String get validate_and_merge => 'Validate and Merge';

  @override
  String get no_articles_to_validate => 'No articles to validate.';

  @override
  String get previous => 'Previous';

  @override
  String get please_enter_title => 'Please enter a title.';

  @override
  String get articles_merged_successfully =>
      'Articles merged successfully! Redirecting to edit.';

  @override
  String get merge_articles => 'Merge Articles';

  @override
  String get cancel => 'Cancel';

  @override
  String validate_article(Object current, Object total) {
    return 'Validate Article $current of $total';
  }

  @override
  String get captcha_instruction =>
      'I have completed the login/captcha on the page';

  @override
  String get quota_reached_web =>
      'Quota reached. Please visit our website to upgrade.';

  @override
  String get title_merged_article => 'Title for merged article';

  @override
  String failed_to_merge(Object error) {
    return 'Failed to merge articles: $error';
  }

  @override
  String get next => 'Next';

  @override
  String get title => 'Title';

  @override
  String get error => 'Error';

  @override
  String get loading_content => 'Loading content...';

  @override
  String get edit_merged_content => 'Edit Merged Content';

  @override
  String get body => 'Body';

  @override
  String get please_enter_content => 'Please enter some content.';

  @override
  String get no_articles_found => 'No articles found.';

  @override
  String get fetching_all_feeds => 'Fetching all feeds...';

  @override
  String get all => 'All';

  @override
  String get draft => 'Draft';

  @override
  String get published => 'Published';

  @override
  String get no_merged_contents => 'No merged contents found.';

  @override
  String status_label(Object status) {
    return 'Status: $status';
  }

  @override
  String get no_rss_feeds => 'No RSS feeds found.';

  @override
  String get delete_rss_feed => 'Delete RSS Feed';

  @override
  String get delete_feed_confirmation =>
      'Are you sure you want to delete this feed?';

  @override
  String get delete => 'Delete';

  @override
  String get publish_options => 'Publish Options';

  @override
  String get status => 'Status';

  @override
  String get external_endpoint => 'External Endpoint';

  @override
  String get none => 'None';

  @override
  String get publish => 'Publish';

  @override
  String get update_rss_feed => 'Update RSS Feed';

  @override
  String get add_rss_feed => 'Add RSS Feed';

  @override
  String get feed_url => 'Feed URL';

  @override
  String get enter_url => 'Please enter a valid URL';

  @override
  String get auto_generate_name => 'Auto-generate Name';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get no_external_endpoints => 'No external endpoints found.';

  @override
  String get delete_endpoint => 'Delete Endpoint';

  @override
  String delete_endpoint_confirmation(Object name) {
    return 'Are you sure you want to delete $name?';
  }

  @override
  String get endpoint_deleted_successfully => 'Endpoint deleted successfully!';

  @override
  String get external_endpoint_updated =>
      'External Endpoint updated successfully!';

  @override
  String get external_endpoint_created =>
      'External Endpoint created successfully!';

  @override
  String get edit_endpoint => 'Edit Endpoint';

  @override
  String get create_new_endpoint => 'Create New Endpoint';

  @override
  String get platform_name => 'Platform Name';

  @override
  String get api_url => 'API URL';

  @override
  String get auth_token_label => 'Auth Token (API Key)';

  @override
  String get update_endpoint => 'Update Endpoint';

  @override
  String get create_endpoint => 'Create Endpoint';

  @override
  String failed_to_save_options(Object error) {
    return 'Failed to save options: $error';
  }

  @override
  String failed_to_publish(Object error) {
    return 'Failed to publish: $error';
  }

  @override
  String get page_not_found => 'Page Not Found';

  @override
  String page_path_not_found(Object path) {
    return 'Page $path not found';
  }

  @override
  String get go_home => 'Go Home';

  @override
  String get live_chat => 'Live Support';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get no_messages =>
      'No messages yet. Send a message to start chatting!';

  @override
  String get type_message => 'Type a message...';

  @override
  String get quota_reached => 'Quota reached';

  @override
  String get quota_reached_upgrade =>
      'Quota reached. Please visit our website to upgrade.';

  @override
  String get monthly_limit_reached => 'Monthly Limit Reached';

  @override
  String get quota_reached_explanation =>
      'You have reached your monthly token quota. Please visit our website to upgrade your plan and continue using AI features.';

  @override
  String get enjoying_app => 'Enjoying the app?';

  @override
  String get no_thanks => 'No thanks';

  @override
  String get sure => 'Sure!';

  @override
  String get whats_new => 'What\'s new:';

  @override
  String get later => 'Later';

  @override
  String get view_plans => 'View Plans';

  @override
  String get close => 'Close';

  @override
  String get share_feedback_question =>
      'Would you like to share your feedback with us?';

  @override
  String get feedback_matters => 'Your Feedback Matters';

  @override
  String get share_thoughts =>
      'Please share your thoughts about the app. If you\'re enjoying it, a review on the app store would be greatly appreciated!';

  @override
  String get feedback_hint => 'Enter your feedback here';

  @override
  String get submit => 'Submit';

  @override
  String get required_update => 'Required Update';

  @override
  String get update_available => 'Update Available';

  @override
  String critical_update_message(Object version) {
    return 'A critical update (version $version) is required to continue using this app.';
  }

  @override
  String new_version_available(Object version) {
    return 'A new version ($version) is available.';
  }

  @override
  String get update_now => 'Update Now';

  @override
  String get update => 'Update';
}
