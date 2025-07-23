import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studyai/app/models/user_model.dart';
import 'package:studyai/app/modules/auth/controllers/google_api.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import 'package:studyai/app/providers/laravel_provider.dart';
import 'package:studyai/app/repositories/user_repository.dart';
import 'package:studyai/app/routes/app_routes.dart';
import 'package:studyai/app/services/auth_service.dart';
import 'package:studyai/common/ui.dart';
import 'package:http/http.dart' as http;

import '../../../services/global_services.dart';
import 'facebook_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AuthController extends GetxController {

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';


  Rx<UserModel> currentUser = Get.find<AuthService>().user;
  late GlobalKey<FormState> loginFormKey;
  late GlobalKey<FormState> registerFormKey;
  RxBool isLoginScreen = true.obs;
  RxBool minimumInformationStep1 = false.obs;
  RxBool minimumInformationStep2 = false.obs;
  RxBool minimumInformationStep3 = false.obs;
  RxBool registerInfoComplete = false.obs;
  RxBool registerInfoHalfSaved = false.obs;
  RxBool hidePassword = false.obs;
  RxBool loginLoading = false.obs;
  RxBool recoverLoading = false.obs;
  late UserRepository userRepository;
  var email = "".obs;
  var schoolLevel = [
  AppLocalizations.of(Get.context!).university_student,
  AppLocalizations.of(Get.context!).high_school_student,
  AppLocalizations.of(Get.context!).middle_school_student,
  AppLocalizations.of(Get.context!).independent_candidate

  ];
  var selectedSchoolLevel = ''.obs;

  var classDegree = [
  AppLocalizations.of(Get.context!).bepc,
  AppLocalizations.of(Get.context!).bac,
  AppLocalizations.of(Get.context!).hnd,
  AppLocalizations.of(Get.context!).bachelor
  ];
  var selectedClassLevel = ''.obs;

  RxDouble progress = 0.0.obs;
  Timer? _timer;
  Duration duration = Duration(seconds: 10);

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
  //   scopes: <String>[PeopleServiceApi.contactsReadonlyScope],
  // );
  //
  // GoogleSignInAccount? _currentUser;
  // String _contactText = '';




  AuthController(){
    userRepository = UserRepository();
    Get.lazyPut(()=>RootController());
    Get.lazyPut(() => AuthService());

    Get.lazyPut(() => LaravelApiClient(dio: Dio()));
    // Get.lazyPut(() => DashboardController());
    // Get.lazyPut(() => CommunityController());
    // Get.lazyPut(() => NotificationController());
    // Get.lazyPut(() => EventsController());

  }


  @override
  void onInit() async {

    super.onInit();

  }

  Future<void> login() async {
    Get.focusScope?.unfocus();
    if (loginFormKey.currentState!.validate()) {
      try{
        loginLoading.value = true;
        var id = await userRepository.login(currentUser.value);
        await getUser(id);
        //Get.showSnackbar(Ui.SuccessSnackBar(message: 'Utilisateur connecte avec succes'));
        loginLoading.value = false;
        var box = GetStorage();
        box.write("exists", true);
        Get.toNamed(Routes.ROOT);
      } catch(e){
        loginLoading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

      }
      finally {
        loginLoading.value = false;
      }
    }else{

    }
  }

  Future<void> register() async {
    Get.focusScope?.unfocus();

    if (registerFormKey.currentState!.validate()) {
      try{
        const int updatesPerSecond = 60; // Smooth updates per second
        final int totalUpdates = duration.inSeconds * updatesPerSecond;
        final double increment = 2.0 / totalUpdates;

        int updateCount = 0;

        currentUser.value = await userRepository.register(currentUser.value);
        Get.find<AuthService>().user.value = currentUser.value;


        _timer = Timer.periodic(
          Duration(milliseconds: 1000 ~/ updatesPerSecond),
              (timer) async {

            progress.value += increment;

            updateCount++;

            if (updateCount >= totalUpdates/3) {
              registerInfoHalfSaved.value = true;
            }
            if (updateCount >= totalUpdates) {
              if (currentUser.value != null) {
                _timer?.cancel();
                await Get.toNamed(Routes.LOGIN);
              }
              else{
                _timer?.cancel();
              }
            }
          },
        );
      }
      catch(e){
        _timer?.cancel();
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

      }
      finally {
        //loading.value = false;
      }
    }else{

    }
  }


  Future<void> getUser(int id) async {
    Get.focusScope?.unfocus();

    try{

      Get.find<AuthService>().user.value = await userRepository.getUser(id);
      currentUser.value= Get.find<AuthService>().user.value;
      print('name is ${Get.find<AuthService>().user.value}');


    } catch(e){
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      //loading.value = false;
    }

  }

  Future<void> handleGoogleSignIn() async {
    try {
      await GoogleApi.signIn();
      debugPrint(GoogleApi.userinfo().toString());
      if(GoogleApi.userinfo() != null){
        GoogleApi.userinfo()?.authentication.then((value) async {
          print('Id token: ${value.idToken}');
          print("Access token: ${value.accessToken}");
          if(value.idToken != null){
            var id = await userRepository.loginGoogle(value.idToken!);
            await getUser(id);
            Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).login_successful));

            loginLoading.value = false;

            Get.toNamed(Routes.ROOT);
          }


        } ,);

      }


    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> handleGoogleSignOut(BuildContext context) async {
    try {
      await GoogleApi.signOut();
      debugPrint(GoogleApi.userinfo().toString());
      Get.offAllNamed(Routes.LOGIN);

    } catch (error) {
      debugPrint(error.toString());
    }
  }


  Future<void> handleFacebookSignIn() async {
    try {
      await FacebookApi.facebookSignIn();
      debugPrint(FacebookApi.userinfo.toString());
      if (FacebookApi.userinfo != null) {
        if(FacebookApi.accessToken != null){
          var id = await userRepository.loginFacebook(FacebookApi.accessToken!);
          await getUser(id);
          Get.showSnackbar(
              Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).login_successful));

          loginLoading.value = false;

          Get.toNamed(Routes.ROOT);
        }

      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future resetPassword(String value) async{
    try {
      var headersList = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('${GlobalService().baseUrl}/forgot-password');

      var body = {
        "email": value
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        Ui.SuccessSnackBar(message: jsonDecode(resBody)["message"]);
        recoverLoading.value = false;
      }
      else {
        Ui.ErrorSnackBar(message: res.reasonPhrase.toString());
        recoverLoading.value = false;
      }
    }catch (e){
      Ui.ErrorSnackBar(message: e.toString());
      recoverLoading.value = false;
    }
  }
}