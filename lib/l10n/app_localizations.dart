import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('es'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @default_ride.
  ///
  /// In en, this message translates to:
  /// **'Default Ride'**
  String get default_ride;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and you will lose all your data.'**
  String get delete_account_confirm;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to sign in again to access your account.'**
  String get logout_confirm;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @total_rides.
  ///
  /// In en, this message translates to:
  /// **'Total Rides'**
  String get total_rides;

  /// No description provided for @total_spent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get total_spent;

  /// No description provided for @frequent_location.
  ///
  /// In en, this message translates to:
  /// **'Frequent Location'**
  String get frequent_location;

  /// No description provided for @avg_ride_time.
  ///
  /// In en, this message translates to:
  /// **'Avg Ride Time'**
  String get avg_ride_time;

  /// No description provided for @linked_accounts.
  ///
  /// In en, this message translates to:
  /// **'Linked Accounts'**
  String get linked_accounts;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help_center;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @link_platform.
  ///
  /// In en, this message translates to:
  /// **'Link Platform'**
  String get link_platform;

  /// No description provided for @search_country.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get search_country;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @drivers_license_number.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s license number'**
  String get drivers_license_number;

  /// No description provided for @continue_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_btn;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enter_verification_code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didnt_receive_code;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @security_footer.
  ///
  /// In en, this message translates to:
  /// **'We only read earnings data. We never modify your account.'**
  String get security_footer;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncing;

  /// No description provided for @pulling_ride_history.
  ///
  /// In en, this message translates to:
  /// **'Pulling your ride history...'**
  String get pulling_ride_history;

  /// No description provided for @connecting_to.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {platform}...'**
  String connecting_to(String platform);

  /// No description provided for @platform_connected.
  ///
  /// In en, this message translates to:
  /// **'{platform} Connected'**
  String platform_connected(String platform);

  /// No description provided for @found_trips.
  ///
  /// In en, this message translates to:
  /// **'Found {count} trips'**
  String found_trips(String count);

  /// No description provided for @estimated_sync_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated sync time: 1 minute'**
  String get estimated_sync_time;

  /// No description provided for @securely_syncing.
  ///
  /// In en, this message translates to:
  /// **'Securely syncing your ride data.'**
  String get securely_syncing;

  /// No description provided for @trips_synced.
  ///
  /// In en, this message translates to:
  /// **'Your trips are now synced with\nRYDE-IQ.'**
  String get trips_synced;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @send_otp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get send_otp;

  /// No description provided for @otp_sent.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get otp_sent;

  /// No description provided for @enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enter_otp;

  /// No description provided for @resend_otp_in.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in '**
  String get resend_otp_in;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @verification_code_msg.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a verification code to your number.'**
  String get verification_code_msg;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get last_name;

  /// No description provided for @email_optional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get email_optional;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @by_clicking_confirm.
  ///
  /// In en, this message translates to:
  /// **'By Clicking Confirm, I agree to\n'**
  String get by_clicking_confirm;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_and_conditions;

  /// No description provided for @and_text.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and_text;

  /// No description provided for @what_brings_you_here.
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get what_brings_you_here;

  /// No description provided for @im_a_passenger.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Passenger'**
  String get im_a_passenger;

  /// No description provided for @find_cheapest_ride_fares.
  ///
  /// In en, this message translates to:
  /// **'Find cheapest ride fares'**
  String get find_cheapest_ride_fares;

  /// No description provided for @im_a_driver.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Driver'**
  String get im_a_driver;

  /// No description provided for @compare_my_earnings.
  ///
  /// In en, this message translates to:
  /// **'Compare my earnings'**
  String get compare_my_earnings;

  /// No description provided for @allow_permissions.
  ///
  /// In en, this message translates to:
  /// **'Allow Permissions'**
  String get allow_permissions;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @location_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Used to detect pickup location'**
  String get location_subtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notifications_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Used for fare alerts and driver insights'**
  String get notifications_subtitle;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Turn every trip\ninto insight.'**
  String get welcome_title;

  /// No description provided for @welcome_login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get welcome_login;

  /// No description provided for @welcome_signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get welcome_signup;

  /// No description provided for @paywall_billed_after_trial.
  ///
  /// In en, this message translates to:
  /// **'After FREE trial, you will be billed...'**
  String get paywall_billed_after_trial;

  /// No description provided for @paywall_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywall_monthly;

  /// No description provided for @paywall_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get paywall_yearly;

  /// No description provided for @paywall_save_percent.
  ///
  /// In en, this message translates to:
  /// **'Save 30%'**
  String get paywall_save_percent;

  /// No description provided for @paywall_month.
  ///
  /// In en, this message translates to:
  /// **' /Month'**
  String get paywall_month;

  /// No description provided for @paywall_year.
  ///
  /// In en, this message translates to:
  /// **' /Year'**
  String get paywall_year;

  /// No description provided for @paywall_benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get paywall_benefits;

  /// No description provided for @paywall_benefit_1.
  ///
  /// In en, this message translates to:
  /// **'1. Compare ride prices instantly'**
  String get paywall_benefit_1;

  /// No description provided for @paywall_benefit_2.
  ///
  /// In en, this message translates to:
  /// **'2. Track your earnings across platforms'**
  String get paywall_benefit_2;

  /// No description provided for @paywall_benefit_3.
  ///
  /// In en, this message translates to:
  /// **'3. Get smart insights to maximize income'**
  String get paywall_benefit_3;

  /// No description provided for @paywall_start_trial.
  ///
  /// In en, this message translates to:
  /// **'Start Free Trial'**
  String get paywall_start_trial;

  /// No description provided for @paywall_title.
  ///
  /// In en, this message translates to:
  /// **'Start saving more\non every ride'**
  String get paywall_title;

  /// No description provided for @paywall_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare fares and track earnings across platforms. all in one place.'**
  String get paywall_subtitle;

  /// No description provided for @paywall_7_day_trial.
  ///
  /// In en, this message translates to:
  /// **'7-Day Free Trial'**
  String get paywall_7_day_trial;

  /// No description provided for @paywall_no_charges.
  ///
  /// In en, this message translates to:
  /// **'No charges today. Cancel anytime.'**
  String get paywall_no_charges;

  /// No description provided for @rider.
  ///
  /// In en, this message translates to:
  /// **'Rider'**
  String get rider;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @version_info.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version_info(String version);

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @no_notifications_yet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get no_notifications_yet;

  /// No description provided for @search_location.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get search_location;

  /// No description provided for @current_location.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get current_location;

  /// No description provided for @opening_platform.
  ///
  /// In en, this message translates to:
  /// **'Opening {platform}'**
  String opening_platform(String platform);

  /// No description provided for @locations_added.
  ///
  /// In en, this message translates to:
  /// **'Your pickup and drop location\nhave been added.'**
  String get locations_added;

  /// No description provided for @app_not_installed_title.
  ///
  /// In en, this message translates to:
  /// **'App is not installed'**
  String get app_not_installed_title;

  /// No description provided for @get_app_to_book.
  ///
  /// In en, this message translates to:
  /// **'Get {platform} to book selected ride.'**
  String get_app_to_book(String platform);

  /// No description provided for @install_platform.
  ///
  /// In en, this message translates to:
  /// **'Install {platform}'**
  String install_platform(String platform);

  /// No description provided for @app_not_installed_question.
  ///
  /// In en, this message translates to:
  /// **'App not installed?'**
  String get app_not_installed_question;

  /// No description provided for @driver_dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Driver Dashboard'**
  String get driver_dashboard_title;

  /// No description provided for @driver_dashboard_subtitle.
  ///
  /// In en, this message translates to:
  /// **'See what you\'re really earning.'**
  String get driver_dashboard_subtitle;

  /// No description provided for @tab_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tab_today;

  /// No description provided for @tab_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get tab_weekly;

  /// No description provided for @tab_all_time.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get tab_all_time;

  /// No description provided for @todays_earnings.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get todays_earnings;

  /// No description provided for @quick_stats_platform.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats of {platform}'**
  String quick_stats_platform(String platform);

  /// No description provided for @trips_today.
  ///
  /// In en, this message translates to:
  /// **'Trips Today'**
  String get trips_today;

  /// No description provided for @online_hours.
  ///
  /// In en, this message translates to:
  /// **'Online Hours'**
  String get online_hours;

  /// No description provided for @miles_driven.
  ///
  /// In en, this message translates to:
  /// **'Miles Driven'**
  String get miles_driven;

  /// No description provided for @tips_earned.
  ///
  /// In en, this message translates to:
  /// **'Tips Earned'**
  String get tips_earned;

  /// No description provided for @idle_time.
  ///
  /// In en, this message translates to:
  /// **'Idle Time'**
  String get idle_time;

  /// No description provided for @acceptance_rate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptance_rate;

  /// No description provided for @insight_today_uber.
  ///
  /// In en, this message translates to:
  /// **'You earned more per hour on Uber today compared to the other platforms.'**
  String get insight_today_uber;

  /// No description provided for @insight_weekly_uber.
  ///
  /// In en, this message translates to:
  /// **'You earned more per hour on Uber this week compared to the other platforms.'**
  String get insight_weekly_uber;

  /// No description provided for @earnings_by_day.
  ///
  /// In en, this message translates to:
  /// **'Earnings by Day'**
  String get earnings_by_day;

  /// No description provided for @quick_stats_for_platform.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats for {platform}'**
  String quick_stats_for_platform(String platform);

  /// No description provided for @total_earnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earnings;

  /// No description provided for @earnings_per_hour.
  ///
  /// In en, this message translates to:
  /// **'Earnings per Hour'**
  String get earnings_per_hour;

  /// No description provided for @total_trips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get total_trips;

  /// No description provided for @total_hours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get total_hours;

  /// No description provided for @platform_earnings_comparison.
  ///
  /// In en, this message translates to:
  /// **'Platform Earnings Comparison'**
  String get platform_earnings_comparison;

  /// No description provided for @best_platform.
  ///
  /// In en, this message translates to:
  /// **'Best Platform'**
  String get best_platform;

  /// No description provided for @per_hour.
  ///
  /// In en, this message translates to:
  /// **'{amount} per hour'**
  String per_hour(String amount);

  /// No description provided for @milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestones;

  /// No description provided for @milestone_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get milestone_completed;

  /// No description provided for @milestone_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get milestone_in_progress;

  /// No description provided for @milestone_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get milestone_locked;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @milestone_earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get milestone_earned;

  /// No description provided for @quick_stats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quick_stats;

  /// No description provided for @avg_rating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avg_rating;

  /// No description provided for @go_to_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get go_to_dashboard;

  /// No description provided for @not_linked.
  ///
  /// In en, this message translates to:
  /// **'Not Linked'**
  String get not_linked;

  /// No description provided for @driver_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Driver Verification'**
  String get driver_verification_title;

  /// No description provided for @verify_income_title.
  ///
  /// In en, this message translates to:
  /// **'Verify your income'**
  String get verify_income_title;

  /// No description provided for @verify_income_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Securely connect your payroll or gig platform to verify your driver status and income.'**
  String get verify_income_subtitle;

  /// No description provided for @income_verified_success.
  ///
  /// In en, this message translates to:
  /// **'Income verified successfully'**
  String get income_verified_success;

  /// No description provided for @verify_income_with_truv.
  ///
  /// In en, this message translates to:
  /// **'Verify Income with Truv'**
  String get verify_income_with_truv;

  /// No description provided for @truv_income_verification.
  ///
  /// In en, this message translates to:
  /// **'Income Verification'**
  String get truv_income_verification;

  /// No description provided for @verification_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get verification_pending;

  /// No description provided for @verification_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verification_verified;

  /// No description provided for @verification_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get verification_failed;

  /// No description provided for @verification_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get verification_connected;

  /// No description provided for @verification_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get verification_unknown;

  /// No description provided for @income_source_connected.
  ///
  /// In en, this message translates to:
  /// **'Income Source Connected'**
  String get income_source_connected;

  /// No description provided for @verified_employer.
  ///
  /// In en, this message translates to:
  /// **'Verified Employer'**
  String get verified_employer;

  /// No description provided for @link_btn.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link_btn;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @enter_first_name.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enter_first_name;

  /// No description provided for @enter_last_name.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enter_last_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter email'**
  String get enter_email;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required_field;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @pickup_location.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickup_location;

  /// No description provided for @drop_location.
  ///
  /// In en, this message translates to:
  /// **'Drop location'**
  String get drop_location;

  /// No description provided for @stop_label.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop_label;

  /// No description provided for @stops_label.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops_label;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @edit_locations.
  ///
  /// In en, this message translates to:
  /// **'Edit locations'**
  String get edit_locations;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// No description provided for @filter_economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get filter_economy;

  /// No description provided for @filter_premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get filter_premium;

  /// No description provided for @min_abbreviation.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min_abbreviation;

  /// No description provided for @email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get email_or_phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @compare_fares.
  ///
  /// In en, this message translates to:
  /// **'Compare Fares'**
  String get compare_fares;

  /// No description provided for @recent_locations.
  ///
  /// In en, this message translates to:
  /// **'Recent locations'**
  String get recent_locations;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
