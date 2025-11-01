import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:studyai/app/modules/auth/views/login_view.dart';
import 'package:studyai/app/modules/onboardingScreens/onboardingScreen.dart';
import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/root/bindings/root_binding.dart';
import 'app/routes/theme_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/global_services.dart';
import 'app/services/settings_services.dart';
import 'l10n/app_localizations.dart';



  initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => AuthService().init());
  //await Get.putAsync(() => LaravelApiClient(dio:Dio()).init());
  //await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  //Get.lazyPut(()=>RootBinding());
  //await Get.putAsync(() => TranslationService().init());
  Get.log('All services started...');

  await GlobalService().getAppVersion();

}

void main() async{

   WidgetsFlutterBinding.ensureInitialized();

   await initServices();

   runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  var box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   fontFamily: 'Poppins'
      // ),
      //initialRoute: Theme1AppPages.INITIAL,
      onReady: () async {
        //await Get.putAsync(() => FireBaseMessagingService().init());
      },
      onUnknownRoute: (settings) {
        // Optionally, navigate to a specific error page or handle it gracefully
        return GetPageRoute(
          settings: RouteSettings(name: '/notfound'),
          page: () => Scaffold(
            appBar: AppBar(title: Text('Page Not Found')),
            body: Center(child: Text('404 - Page Not Found')),
          ),
        );
      },
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => Scaffold(
          appBar: AppBar(title: Text('Page Not Found')),
          body: Center(child: Text('404 - Page Not Found')),
        )
      ),
      initialBinding: GlobalService.isAuthTokenValid ? RootBinding() : AuthBinding(),
      getPages: Theme1AppPages.routes,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
      home: box.read("exists") == null ? OnboardingScreen() : LoginView(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale.fromSubtags(languageCode: box.read('language')==null? Platform.localeName:box.read('language')),

      supportedLocales: [
        Locale('en', ''), // English
        Locale('fr', ''), // French
        // Add other supported locales
      ],
    );
  }
}


