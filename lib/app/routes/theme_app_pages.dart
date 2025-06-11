import 'package:get/get.dart' show GetPage, Transition;
import 'package:studyai/app/modules/auth/views/register_views.dart';
import 'package:studyai/app/modules/chat/bindings/chat_binding.dart';
import 'package:studyai/app/modules/chat/views/chat_platform.dart';
import 'package:studyai/app/modules/chat/views/history_view.dart';
import 'package:studyai/app/modules/files/views/import_support_view.dart';
import 'package:studyai/app/modules/files/views/quizz_post_generation_view.dart';
import 'package:studyai/app/modules/files/views/revision_view.dart';
import 'package:studyai/app/modules/profile/views/complete_profile_view.dart';



import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_register_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import 'app_routes.dart';

class Theme1AppPages {

  static final routes = [
    //GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginRegisterView(), binding: AuthBinding(), ),
    GetPage(name: Routes.REGISTER, page: () => RegisterViews(), binding: AuthBinding(), ),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.ROOT, page: () => const RootView(), binding: RootBinding(), transition: Transition.zoom ),
    GetPage(name: Routes.PROFILE, page: () =>const ProfileView(),binding: ProfileBinding(), transition: Transition.rightToLeft ),
    GetPage(name: Routes.COMPLETE_PROFILE_VIEW, page: () => CompleteProfileView(),binding: ProfileBinding(), transition: Transition.rightToLeft ),
    GetPage(name: Routes.HISTORY, page: () => HistoryView(), binding: ChatBinding(), ),
    GetPage(name: Routes.CHAT_PLATFORM, page: () => ChatPlatform(), binding: ChatBinding(), ),
    GetPage(name: Routes.IMPORT_SUPPORT, page: () => ImportSupportView(),  transition: Transition.rightToLeft),
    GetPage(name: Routes.REVISION, page: () => RevisionView(),  transition: Transition.rightToLeft),
    GetPage(name: Routes.QUIZZ_POST_GENERATION_VIEW, page: () => QuizzPostGenerationView(),  transition: Transition.rightToLeft),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () =>LanguageView(), binding: SettingsBinding(),transition: Transition.rightToLeft ),

  ];
}


