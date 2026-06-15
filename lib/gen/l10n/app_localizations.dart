import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'NoshMesh'**
  String get appTitle;

  /// The welcome message displayed on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to NoshMesh'**
  String get welcomeMessage;

  /// Label for the home tab or button
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for the settings tab or button
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for the profile tab or button
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Label for the dark mode option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for the light mode option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Label for the system mode option
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for changing the application language
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get change_language;

  /// Label for theme selection
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Label for changing the application theme
  ///
  /// In en, this message translates to:
  /// **'Change application theme'**
  String get change_theme;

  /// Label for notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label for notification settings description
  ///
  /// In en, this message translates to:
  /// **'Configure notification preferences'**
  String get notification_settings;

  /// Label for the localization demo option
  ///
  /// In en, this message translates to:
  /// **'Localization Demo'**
  String get localization_demo;

  /// Description for the localization demo option
  ///
  /// In en, this message translates to:
  /// **'View localization features in action'**
  String get localization_demo_description;

  /// Title for the language settings screen
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// Instruction to select a language
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get select_your_language;

  /// Explanation of the language selection effects
  ///
  /// In en, this message translates to:
  /// **'The selected language will be applied across the entire application'**
  String get language_explanation;

  /// Title for the localization assets demo screen
  ///
  /// In en, this message translates to:
  /// **'Localization & Assets Demo'**
  String get localization_assets_demo;

  /// Label for displaying current language info
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get current_language;

  /// Label for language code
  ///
  /// In en, this message translates to:
  /// **'Language code'**
  String get language_code;

  /// Label for language name
  ///
  /// In en, this message translates to:
  /// **'Language name'**
  String get language_name;

  /// Title for formatting examples section
  ///
  /// In en, this message translates to:
  /// **'Formatting Examples'**
  String get formatting_examples;

  /// Label for full date format example
  ///
  /// In en, this message translates to:
  /// **'Date (full)'**
  String get date_full;

  /// Label for short date format example
  ///
  /// In en, this message translates to:
  /// **'Date (short)'**
  String get date_short;

  /// Label for time format example
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Label for currency format example
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// Label for percent format example
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get percent;

  /// Title for localized assets section
  ///
  /// In en, this message translates to:
  /// **'Localized Assets'**
  String get localized_assets;

  /// Explanation of localized assets feature
  ///
  /// In en, this message translates to:
  /// **'This section demonstrates how to load different assets based on the selected language. Images, audio, and other resources can be language-specific.'**
  String get localized_assets_explanation;

  /// Title for localized image example
  ///
  /// In en, this message translates to:
  /// **'Localized Image Example'**
  String get image_example;

  /// Caption for the welcome image example
  ///
  /// In en, this message translates to:
  /// **'This image is loaded based on your selected language'**
  String get welcome_image_caption;

  /// Title for common image example
  ///
  /// In en, this message translates to:
  /// **'Common Image Example'**
  String get common_image_example;

  /// Caption for the common image example
  ///
  /// In en, this message translates to:
  /// **'This image is the same across all languages'**
  String get common_image_caption;

  /// Label for the logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for the login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for the email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for the password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for the sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Label for the register button
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for the forgot password button
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Error message when content is not found
  ///
  /// In en, this message translates to:
  /// **'Content not found'**
  String get content_not_found;

  /// Generic error message when content is not found or could not be fetched
  ///
  /// In en, this message translates to:
  /// **'Content not found or an error occurred while fetching it.'**
  String get content_not_found_generic;

  /// Label for the try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// A greeting message with the person's name
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String greeting(String name);

  /// A plural message based on an item count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(num count);

  /// When something was last updated
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(DateTime date);

  /// Message displayed when content is published successfully
  ///
  /// In en, this message translates to:
  /// **'Content published successfully'**
  String get content_published_successfully;

  /// Label for the clear all selections button
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clear_all;

  /// Hint text for the article search bar
  ///
  /// In en, this message translates to:
  /// **'Search articles...'**
  String get search_articles;

  /// Hint text for the email field
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_email;

  /// Hint text for the password field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_password;

  /// Message displayed when no articles match the search query
  ///
  /// In en, this message translates to:
  /// **'No matching articles found.'**
  String get no_matching_articles_found;

  /// Label for an item that is currently selected
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// Label for an action to select an item
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Title for the source filter bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Filter by Source'**
  String get filter_by_source;

  /// Label for clearing all applied filters
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clear_all_filters;

  /// Label for the select all button
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get select_all;

  /// Label for the unselect all button
  ///
  /// In en, this message translates to:
  /// **'Unselect All'**
  String get unselect_all;

  /// Label for the merge button
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// Label for external endpoints settings
  ///
  /// In en, this message translates to:
  /// **'External Endpoints'**
  String get external_endpoints;

  /// Subtitle for external endpoints settings
  ///
  /// In en, this message translates to:
  /// **'Manage your integrated platforms'**
  String get manage_endpoints;

  /// Title for change password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// Label for current password field
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// Label for new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// Label for confirm new password field
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirm_new_password;

  /// Label for save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// Success message when profile is updated
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profile_updated;

  /// Error message when profile update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get update_profile_failed;

  /// Label for name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Error message when name is missing
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required;

  /// Error message when email is missing
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// Error message when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// Error message when a required field is missing
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @send_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get send_reset_link;

  /// No description provided for @reset_password_instruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link.'**
  String get reset_password_instruction;

  /// No description provided for @reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get reset_your_password;

  /// No description provided for @back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get back_to_login;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @reset_token.
  ///
  /// In en, this message translates to:
  /// **'Reset Token'**
  String get reset_token;

  /// No description provided for @reset_token_hint.
  ///
  /// In en, this message translates to:
  /// **'Paste the token from your email'**
  String get reset_token_hint;

  /// No description provided for @enter_reset_token.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reset token'**
  String get enter_reset_token;

  /// No description provided for @password_reset_success.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get password_reset_success;

  /// No description provided for @failed_to_reset_password.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password'**
  String get failed_to_reset_password;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verify_email;

  /// No description provided for @check_your_email.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get check_your_email;

  /// No description provided for @verification_code_sent.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to your email'**
  String get verification_code_sent;

  /// No description provided for @verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// No description provided for @enter_6_digit_code.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get enter_6_digit_code;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get enter_verification_code;

  /// No description provided for @code_must_be_6_digits.
  ///
  /// In en, this message translates to:
  /// **'The code must be 6 digits'**
  String get code_must_be_6_digits;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend_code;

  /// No description provided for @reset_link_sent.
  ///
  /// In en, this message translates to:
  /// **'If an account with that email exists, a password reset link has been sent.'**
  String get reset_link_sent;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_dont_match;

  /// No description provided for @update_your_security.
  ///
  /// In en, this message translates to:
  /// **'Update your security'**
  String get update_your_security;

  /// No description provided for @ensure_account_secure.
  ///
  /// In en, this message translates to:
  /// **'Ensure your account stays secure by using a strong password.'**
  String get ensure_account_secure;

  /// No description provided for @password_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get password_changed_success;

  /// No description provided for @password_changed_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get password_changed_error;

  /// No description provided for @ai_text_generation.
  ///
  /// In en, this message translates to:
  /// **'AI Text Generation'**
  String get ai_text_generation;

  /// No description provided for @quota_exceeded_web_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Quota exceeded. Please visit our website to upgrade your plan and continue.'**
  String get quota_exceeded_web_upgrade;

  /// No description provided for @monthly_limit_reached_web_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Monthly limit reached. Please visit our website to upgrade your plan.'**
  String get monthly_limit_reached_web_upgrade;

  /// No description provided for @enter_your_prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your prompt'**
  String get enter_your_prompt;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @validate_and_merge.
  ///
  /// In en, this message translates to:
  /// **'Validate and Merge'**
  String get validate_and_merge;

  /// No description provided for @no_articles_to_validate.
  ///
  /// In en, this message translates to:
  /// **'No articles to validate.'**
  String get no_articles_to_validate;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @please_enter_title.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title.'**
  String get please_enter_title;

  /// No description provided for @articles_merged_successfully.
  ///
  /// In en, this message translates to:
  /// **'Articles merged successfully! Redirecting to edit.'**
  String get articles_merged_successfully;

  /// No description provided for @merge_articles.
  ///
  /// In en, this message translates to:
  /// **'Merge Articles'**
  String get merge_articles;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @validate_article.
  ///
  /// In en, this message translates to:
  /// **'Validate Article {current} of {total}'**
  String validate_article(Object current, Object total);

  /// No description provided for @captcha_instruction.
  ///
  /// In en, this message translates to:
  /// **'I have completed the login/captcha on the page'**
  String get captcha_instruction;

  /// No description provided for @quota_reached_web.
  ///
  /// In en, this message translates to:
  /// **'Quota reached. Please visit our website to upgrade.'**
  String get quota_reached_web;

  /// No description provided for @title_merged_article.
  ///
  /// In en, this message translates to:
  /// **'Title for merged article'**
  String get title_merged_article;

  /// No description provided for @failed_to_merge.
  ///
  /// In en, this message translates to:
  /// **'Failed to merge articles: {error}'**
  String failed_to_merge(Object error);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading_content.
  ///
  /// In en, this message translates to:
  /// **'Loading content...'**
  String get loading_content;

  /// No description provided for @edit_merged_content.
  ///
  /// In en, this message translates to:
  /// **'Edit Merged Content'**
  String get edit_merged_content;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @please_enter_content.
  ///
  /// In en, this message translates to:
  /// **'Please enter some content.'**
  String get please_enter_content;

  /// No description provided for @no_articles_found.
  ///
  /// In en, this message translates to:
  /// **'No articles found.'**
  String get no_articles_found;

  /// No description provided for @fetching_all_feeds.
  ///
  /// In en, this message translates to:
  /// **'Fetching all feeds...'**
  String get fetching_all_feeds;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @no_merged_contents.
  ///
  /// In en, this message translates to:
  /// **'No merged contents found.'**
  String get no_merged_contents;

  /// No description provided for @status_label.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status_label(Object status);

  /// No description provided for @no_rss_feeds.
  ///
  /// In en, this message translates to:
  /// **'No RSS feeds found.'**
  String get no_rss_feeds;

  /// No description provided for @delete_rss_feed.
  ///
  /// In en, this message translates to:
  /// **'Delete RSS Feed'**
  String get delete_rss_feed;

  /// No description provided for @delete_feed_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this feed?'**
  String get delete_feed_confirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @publish_options.
  ///
  /// In en, this message translates to:
  /// **'Publish Options'**
  String get publish_options;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @external_endpoint.
  ///
  /// In en, this message translates to:
  /// **'External Endpoint'**
  String get external_endpoint;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @update_rss_feed.
  ///
  /// In en, this message translates to:
  /// **'Update RSS Feed'**
  String get update_rss_feed;

  /// No description provided for @add_rss_feed.
  ///
  /// In en, this message translates to:
  /// **'Add RSS Feed'**
  String get add_rss_feed;

  /// No description provided for @feed_url.
  ///
  /// In en, this message translates to:
  /// **'Feed URL'**
  String get feed_url;

  /// No description provided for @enter_url.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get enter_url;

  /// No description provided for @auto_generate_name.
  ///
  /// In en, this message translates to:
  /// **'Auto-generate Name'**
  String get auto_generate_name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @no_external_endpoints.
  ///
  /// In en, this message translates to:
  /// **'No external endpoints found.'**
  String get no_external_endpoints;

  /// No description provided for @delete_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Delete Endpoint'**
  String get delete_endpoint;

  /// No description provided for @delete_endpoint_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String delete_endpoint_confirmation(Object name);

  /// No description provided for @endpoint_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Endpoint deleted successfully!'**
  String get endpoint_deleted_successfully;

  /// No description provided for @external_endpoint_updated.
  ///
  /// In en, this message translates to:
  /// **'External Endpoint updated successfully!'**
  String get external_endpoint_updated;

  /// No description provided for @external_endpoint_created.
  ///
  /// In en, this message translates to:
  /// **'External Endpoint created successfully!'**
  String get external_endpoint_created;

  /// No description provided for @edit_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Edit Endpoint'**
  String get edit_endpoint;

  /// No description provided for @create_new_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Create New Endpoint'**
  String get create_new_endpoint;

  /// No description provided for @platform_name.
  ///
  /// In en, this message translates to:
  /// **'Platform Name'**
  String get platform_name;

  /// No description provided for @api_url.
  ///
  /// In en, this message translates to:
  /// **'API URL'**
  String get api_url;

  /// No description provided for @auth_token_label.
  ///
  /// In en, this message translates to:
  /// **'Auth Token (API Key)'**
  String get auth_token_label;

  /// No description provided for @update_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Update Endpoint'**
  String get update_endpoint;

  /// No description provided for @create_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Create Endpoint'**
  String get create_endpoint;

  /// No description provided for @failed_to_save_options.
  ///
  /// In en, this message translates to:
  /// **'Failed to save options: {error}'**
  String failed_to_save_options(Object error);

  /// No description provided for @failed_to_publish.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish: {error}'**
  String failed_to_publish(Object error);

  /// No description provided for @page_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get page_not_found;

  /// No description provided for @page_path_not_found.
  ///
  /// In en, this message translates to:
  /// **'Page {path} not found'**
  String page_path_not_found(Object path);

  /// No description provided for @go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get go_home;

  /// No description provided for @live_chat.
  ///
  /// In en, this message translates to:
  /// **'Live Support'**
  String get live_chat;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @no_messages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Send a message to start chatting!'**
  String get no_messages;

  /// No description provided for @type_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get type_message;

  /// No description provided for @quota_reached.
  ///
  /// In en, this message translates to:
  /// **'Quota reached'**
  String get quota_reached;

  /// No description provided for @quota_reached_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Quota reached. Please visit our website to upgrade.'**
  String get quota_reached_upgrade;

  /// No description provided for @monthly_limit_reached.
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit Reached'**
  String get monthly_limit_reached;

  /// No description provided for @quota_reached_explanation.
  ///
  /// In en, this message translates to:
  /// **'You have reached your monthly token quota. Please visit our website to upgrade your plan and continue using AI features.'**
  String get quota_reached_explanation;

  /// No description provided for @enjoying_app.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the app?'**
  String get enjoying_app;

  /// No description provided for @no_thanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get no_thanks;

  /// No description provided for @sure.
  ///
  /// In en, this message translates to:
  /// **'Sure!'**
  String get sure;

  /// No description provided for @whats_new.
  ///
  /// In en, this message translates to:
  /// **'What\'s new:'**
  String get whats_new;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @view_plans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get view_plans;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @share_feedback_question.
  ///
  /// In en, this message translates to:
  /// **'Would you like to share your feedback with us?'**
  String get share_feedback_question;

  /// No description provided for @feedback_matters.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback Matters'**
  String get feedback_matters;

  /// No description provided for @share_thoughts.
  ///
  /// In en, this message translates to:
  /// **'Please share your thoughts about the app. If you\'re enjoying it, a review on the app store would be greatly appreciated!'**
  String get share_thoughts;

  /// No description provided for @feedback_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your feedback here'**
  String get feedback_hint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @required_update.
  ///
  /// In en, this message translates to:
  /// **'Required Update'**
  String get required_update;

  /// No description provided for @update_available.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get update_available;

  /// No description provided for @critical_update_message.
  ///
  /// In en, this message translates to:
  /// **'A critical update (version {version}) is required to continue using this app.'**
  String critical_update_message(Object version);

  /// No description provided for @new_version_available.
  ///
  /// In en, this message translates to:
  /// **'A new version ({version}) is available.'**
  String new_version_available(Object version);

  /// No description provided for @update_now.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get update_now;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
