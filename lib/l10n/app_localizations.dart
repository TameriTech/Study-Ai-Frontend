import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
    Locale('fr')
  ];

  /// No description provided for @fr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get fr;

  /// No description provided for @en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get en;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Select your language preference'**
  String get choose_language;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get select_language;

  /// No description provided for @please_select_language.
  ///
  /// In en, this message translates to:
  /// **'Please Select a language'**
  String get please_select_language;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get create_account;

  /// No description provided for @logout_of_app.
  ///
  /// In en, this message translates to:
  /// **'log out of the app'**
  String get logout_of_app;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get greeting;

  /// No description provided for @farewell.
  ///
  /// In en, this message translates to:
  /// **'Goodbye!'**
  String get farewell;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @connect_with.
  ///
  /// In en, this message translates to:
  /// **'Connect with'**
  String get connect_with;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sign_out;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @delete_account_of_app.
  ///
  /// In en, this message translates to:
  /// **'Delete Account from the app'**
  String get delete_account_of_app;

  /// No description provided for @delete_account_successful.
  ///
  /// In en, this message translates to:
  /// **'Your account was Deleted Successfully'**
  String get delete_account_successful;

  /// No description provided for @delete_account_warning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account and leave the application? All your personal data will be deleted and you will no more access the app'**
  String get delete_account_warning;

  /// No description provided for @sign_out_warning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave the application?'**
  String get sign_out_warning;

  /// No description provided for @input_email.
  ///
  /// In en, this message translates to:
  /// **'Input Email'**
  String get input_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @school_level_question.
  ///
  /// In en, this message translates to:
  /// **'What is your academic level?'**
  String get school_level_question;

  /// No description provided for @class_level_question.
  ///
  /// In en, this message translates to:
  /// **'Quelle classe précisément?'**
  String get class_level_question;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @institution_information.
  ///
  /// In en, this message translates to:
  /// **'Institution Information'**
  String get institution_information;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @owner_name.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get owner_name;

  /// No description provided for @enter_first_name.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enter_first_name;

  /// No description provided for @enter_owner_name.
  ///
  /// In en, this message translates to:
  /// **'Enter owner name'**
  String get enter_owner_name;

  /// No description provided for @enter_valid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enter_valid_email_address;

  /// No description provided for @enter_six_characters.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 6 characters'**
  String get enter_six_characters;

  /// No description provided for @enter_three_characters.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters'**
  String get enter_three_characters;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_password;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'You don\'\'t have an account'**
  String get no_account;

  /// No description provided for @no_account_yet.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get no_account_yet;

  /// No description provided for @already_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get already_account;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @enter_second_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Second Name'**
  String get enter_second_name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @input_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Input a phone number'**
  String get input_phone_number;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get date_of_birth;

  /// No description provided for @please_select_date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Please select date of birth'**
  String get please_select_date_of_birth;

  /// No description provided for @enter_date_in_format.
  ///
  /// In en, this message translates to:
  /// **'Format Day/Month/Year'**
  String get enter_date_in_format;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @select_gender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get select_gender;

  /// No description provided for @please_select_gender.
  ///
  /// In en, this message translates to:
  /// **'Please select a gender'**
  String get please_select_gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others...'**
  String get others;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @enter_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get enter_confirm_password;

  /// No description provided for @password_not_same.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password are not the same'**
  String get password_not_same;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @continu.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continu;

  /// No description provided for @smart_study_assistant_message.
  ///
  /// In en, this message translates to:
  /// **'Your smart study assistant to help you understand, revise and progress.'**
  String get smart_study_assistant_message;

  /// No description provided for @ask_question_upload_file.
  ///
  /// In en, this message translates to:
  /// **'Ask questions or upload pdf file: Let\'\'s work together.'**
  String get ask_question_upload_file;

  /// No description provided for @discussion_history.
  ///
  /// In en, this message translates to:
  /// **'Discussion history'**
  String get discussion_history;

  /// No description provided for @recents.
  ///
  /// In en, this message translates to:
  /// **'Recents'**
  String get recents;

  /// No description provided for @no_files.
  ///
  /// In en, this message translates to:
  /// **'No files'**
  String get no_files;

  /// No description provided for @my_files.
  ///
  /// In en, this message translates to:
  /// **'My files'**
  String get my_files;

  /// No description provided for @search_course_quizz.
  ///
  /// In en, this message translates to:
  /// **'Search course, quizz'**
  String get search_course_quizz;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @ai.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get ai;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @revisions.
  ///
  /// In en, this message translates to:
  /// **'Revisions'**
  String get revisions;

  /// No description provided for @capture_courses.
  ///
  /// In en, this message translates to:
  /// **'Capture your course...'**
  String get capture_courses;

  /// No description provided for @import_document.
  ///
  /// In en, this message translates to:
  /// **'Import your document'**
  String get import_document;

  /// No description provided for @import_support.
  ///
  /// In en, this message translates to:
  /// **'Support importation'**
  String get import_support;

  /// No description provided for @add_instructions.
  ///
  /// In en, this message translates to:
  /// **'Add instructions'**
  String get add_instructions;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @ongoing_generation.
  ///
  /// In en, this message translates to:
  /// **'Ongoing generation'**
  String get ongoing_generation;

  /// No description provided for @ongoing_generation_message.
  ///
  /// In en, this message translates to:
  /// **'Cette opération peut prendre un certain temps en fonction de votre connexion'**
  String get ongoing_generation_message;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @notations_and_vocabularies.
  ///
  /// In en, this message translates to:
  /// **'Notations and vocabularies'**
  String get notations_and_vocabularies;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get term;

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @learn_revise_progress.
  ///
  /// In en, this message translates to:
  /// **'Learn revise and progress with AI'**
  String get learn_revise_progress;

  /// No description provided for @power_learning_message.
  ///
  /// In en, this message translates to:
  /// **'Boost your learning through an AI powered platform'**
  String get power_learning_message;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @i_login.
  ///
  /// In en, this message translates to:
  /// **'I login'**
  String get i_login;

  /// No description provided for @my_progress.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get my_progress;

  /// No description provided for @favorite_courses.
  ///
  /// In en, this message translates to:
  /// **'Favourite_subjects'**
  String get favorite_courses;

  /// No description provided for @objectives.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get objectives;

  /// No description provided for @more_option_and_more.
  ///
  /// In en, this message translates to:
  /// **'More option and more'**
  String get more_option_and_more;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'personalization'**
  String get personalization;

  /// No description provided for @remember_to_finalize_your.
  ///
  /// In en, this message translates to:
  /// **'Remember to finalize your'**
  String get remember_to_finalize_your;

  /// No description provided for @hey.
  ///
  /// In en, this message translates to:
  /// **'Hey'**
  String get hey;

  /// No description provided for @school_level.
  ///
  /// In en, this message translates to:
  /// **'Academic level'**
  String get school_level;

  /// No description provided for @sciences.
  ///
  /// In en, this message translates to:
  /// **'Sciences'**
  String get sciences;

  /// No description provided for @literature_and_languages.
  ///
  /// In en, this message translates to:
  /// **'Literature and Languages'**
  String get literature_and_languages;

  /// No description provided for @economics_and_management.
  ///
  /// In en, this message translates to:
  /// **'Economics and Management'**
  String get economics_and_management;

  /// No description provided for @social_sciences.
  ///
  /// In en, this message translates to:
  /// **'Social Sciences'**
  String get social_sciences;

  /// No description provided for @political_sciences.
  ///
  /// In en, this message translates to:
  /// **'Political Sciences'**
  String get political_sciences;

  /// No description provided for @health_sciences.
  ///
  /// In en, this message translates to:
  /// **'Health Sciences'**
  String get health_sciences;

  /// No description provided for @engineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get engineering;

  /// No description provided for @computer_science.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get computer_science;

  /// No description provided for @law.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get law;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @philosophy.
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get philosophy;

  /// No description provided for @communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @agronomy.
  ///
  /// In en, this message translates to:
  /// **'Agronomy'**
  String get agronomy;

  /// No description provided for @fine_arts.
  ///
  /// In en, this message translates to:
  /// **'Fine Arts'**
  String get fine_arts;

  /// No description provided for @tourism_and_hospitality.
  ///
  /// In en, this message translates to:
  /// **'Tourism and Hospitality'**
  String get tourism_and_hospitality;

  /// No description provided for @electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// No description provided for @accounting_and_finance.
  ///
  /// In en, this message translates to:
  /// **'Accounting and Finance'**
  String get accounting_and_finance;

  /// No description provided for @marketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get marketing;

  /// No description provided for @human_resources.
  ///
  /// In en, this message translates to:
  /// **'Human Resources'**
  String get human_resources;

  /// No description provided for @journalism.
  ///
  /// In en, this message translates to:
  /// **'Journalism'**
  String get journalism;

  /// No description provided for @improve_my_grades.
  ///
  /// In en, this message translates to:
  /// **'Improve my grades'**
  String get improve_my_grades;

  /// No description provided for @prepare_for_specific_exam.
  ///
  /// In en, this message translates to:
  /// **'Prepare for a specific exam'**
  String get prepare_for_specific_exam;

  /// No description provided for @understand_specific_topic.
  ///
  /// In en, this message translates to:
  /// **'Understand a specific topic'**
  String get understand_specific_topic;

  /// No description provided for @learn_with_ai.
  ///
  /// In en, this message translates to:
  /// **'Learn with AI'**
  String get learn_with_ai;

  /// No description provided for @university_student.
  ///
  /// In en, this message translates to:
  /// **'University student'**
  String get university_student;

  /// No description provided for @high_school_student.
  ///
  /// In en, this message translates to:
  /// **'High school student'**
  String get high_school_student;

  /// No description provided for @middle_school_student.
  ///
  /// In en, this message translates to:
  /// **'middle school student'**
  String get middle_school_student;

  /// No description provided for @independent_candidate.
  ///
  /// In en, this message translates to:
  /// **'Independent student'**
  String get independent_candidate;

  /// No description provided for @bepc.
  ///
  /// In en, this message translates to:
  /// **'BEPC'**
  String get bepc;

  /// No description provided for @bac.
  ///
  /// In en, this message translates to:
  /// **'BAC'**
  String get bac;

  /// No description provided for @hnd.
  ///
  /// In en, this message translates to:
  /// **'HND'**
  String get hnd;

  /// No description provided for @bachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor'**
  String get bachelor;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @mcq.
  ///
  /// In en, this message translates to:
  /// **'MCQ'**
  String get mcq;

  /// No description provided for @true_false.
  ///
  /// In en, this message translates to:
  /// **'True/False'**
  String get true_false;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @user_answer_sending_failure.
  ///
  /// In en, this message translates to:
  /// **'Failure to save your answer'**
  String get user_answer_sending_failure;

  /// No description provided for @try_again_call.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get try_again_call;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @account_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Your account was created successfully'**
  String get account_created_successfully;

  /// No description provided for @login_successful.
  ///
  /// In en, this message translates to:
  /// **'User logged in successfully'**
  String get login_successful;

  /// No description provided for @logout_successful.
  ///
  /// In en, this message translates to:
  /// **'User logged out successfully'**
  String get logout_successful;

  /// No description provided for @login_with_email.
  ///
  /// In en, this message translates to:
  /// **'login with email?'**
  String get login_with_email;

  /// No description provided for @login_with_number.
  ///
  /// In en, this message translates to:
  /// **'login with number?'**
  String get login_with_number;

  /// No description provided for @profile_info_successful.
  ///
  /// In en, this message translates to:
  /// **'User Profile info retrieved successfully'**
  String get profile_info_successful;

  /// No description provided for @profile_info_updated_successful.
  ///
  /// In en, this message translates to:
  /// **'User Profile info updated successfully'**
  String get profile_info_updated_successful;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get my_profile;

  /// No description provided for @enter_other_subject.
  ///
  /// In en, this message translates to:
  /// **'Enter another subject'**
  String get enter_other_subject;

  /// No description provided for @learning_objectives.
  ///
  /// In en, this message translates to:
  /// **'Learning objectives'**
  String get learning_objectives;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @generate_quiz.
  ///
  /// In en, this message translates to:
  /// **'Generate quiz'**
  String get generate_quiz;

  /// No description provided for @no_course_available.
  ///
  /// In en, this message translates to:
  /// **'No course available'**
  String get no_course_available;

  /// No description provided for @choose_subject.
  ///
  /// In en, this message translates to:
  /// **'Choose subject'**
  String get choose_subject;

  /// No description provided for @questions_number.
  ///
  /// In en, this message translates to:
  /// **'Number of questions'**
  String get questions_number;

  /// No description provided for @difficulty_level.
  ///
  /// In en, this message translates to:
  /// **'Difficulty level'**
  String get difficulty_level;

  /// No description provided for @question_type.
  ///
  /// In en, this message translates to:
  /// **'Question type'**
  String get question_type;

  /// No description provided for @ongoing_quiz_generation.
  ///
  /// In en, this message translates to:
  /// **'Quiz generation ongoing...'**
  String get ongoing_quiz_generation;

  /// No description provided for @warning_no_course_available.
  ///
  /// In en, this message translates to:
  /// **'A course should be available to generate a quiz'**
  String get warning_no_course_available;

  /// No description provided for @congratulation.
  ///
  /// In en, this message translates to:
  /// **'Congratulation'**
  String get congratulation;

  /// No description provided for @better_luck_next_time.
  ///
  /// In en, this message translates to:
  /// **'Better luck next time'**
  String get better_luck_next_time;

  /// No description provided for @succeeded.
  ///
  /// In en, this message translates to:
  /// **'succeeded'**
  String get succeeded;

  /// No description provided for @look_at_answers.
  ///
  /// In en, this message translates to:
  /// **'Look at the answers'**
  String get look_at_answers;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_occurred;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @close_account.
  ///
  /// In en, this message translates to:
  /// **'Close Account'**
  String get close_account;

  /// No description provided for @update_information.
  ///
  /// In en, this message translates to:
  /// **'Update Information'**
  String get update_information;

  /// No description provided for @password_management.
  ///
  /// In en, this message translates to:
  /// **'Password Management'**
  String get password_management;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @currrent_pwd.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currrent_pwd;

  /// No description provided for @reset_password_explanation.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address we will send you a mail that will help you to reset your password'**
  String get reset_password_explanation;

  /// No description provided for @remember_password.
  ///
  /// In en, this message translates to:
  /// **'You remember your password?'**
  String get remember_password;

  /// No description provided for @ask_any_question.
  ///
  /// In en, this message translates to:
  /// **'Ask any question'**
  String get ask_any_question;

  /// No description provided for @inscription.
  ///
  /// In en, this message translates to:
  /// **'Inscription'**
  String get inscription;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send us your feedback'**
  String get send_feedback;

  /// No description provided for @enter_feedback.
  ///
  /// In en, this message translates to:
  /// **'Enter your feedback here...'**
  String get enter_feedback;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @update_profile_success.
  ///
  /// In en, this message translates to:
  /// **'Updated profile successful'**
  String get update_profile_success;

  /// No description provided for @no_notification.
  ///
  /// In en, this message translates to:
  /// **'You have no notification'**
  String get no_notification;

  /// No description provided for @no_alert.
  ///
  /// In en, this message translates to:
  /// **'You have no alert'**
  String get no_alert;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get notification;

  /// No description provided for @create_mass_message.
  ///
  /// In en, this message translates to:
  /// **'Create mass message'**
  String get create_mass_message;

  /// No description provided for @notification_title.
  ///
  /// In en, this message translates to:
  /// **'Notification title'**
  String get notification_title;

  /// No description provided for @enter_notification_title.
  ///
  /// In en, this message translates to:
  /// **'Enter notification title'**
  String get enter_notification_title;

  /// No description provided for @notification_content.
  ///
  /// In en, this message translates to:
  /// **'Notification content'**
  String get notification_content;

  /// No description provided for @enter_notification_content.
  ///
  /// In en, this message translates to:
  /// **'Enter notification content'**
  String get enter_notification_content;

  /// No description provided for @select_notification_location_description.
  ///
  /// In en, this message translates to:
  /// **'Select the location you would like this message to reach'**
  String get select_notification_location_description;

  /// No description provided for @notification_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Notification created successfully'**
  String get notification_created_successfully;

  /// No description provided for @forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to get your verification email'**
  String get forgot_password_description;

  /// No description provided for @enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get enter_new_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get old_password;

  /// No description provided for @confirm_enter_new_password.
  ///
  /// In en, this message translates to:
  /// **'confirm password and new password must be the same'**
  String get confirm_enter_new_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reset_password;

  /// No description provided for @enter_password_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Enter password confirmation'**
  String get enter_password_confirmation;

  /// No description provided for @reset_password_message.
  ///
  /// In en, this message translates to:
  /// **'An email has been sent to your Gmail with a temporary password,It may take some minutes, please be patient'**
  String get reset_password_message;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get required_field;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// No description provided for @read_less.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get read_less;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get on;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get at;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
