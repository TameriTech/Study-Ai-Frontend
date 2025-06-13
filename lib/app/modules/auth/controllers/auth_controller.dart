import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/user_model.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import 'package:studyai/app/providers/laravel_provider.dart';
import 'package:studyai/app/repositories/user_repository.dart';
import 'package:studyai/app/routes/app_routes.dart';
import 'package:studyai/app/services/auth_service.dart';
import 'package:studyai/common/ui.dart';




class AuthController extends GetxController {

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
  late UserRepository userRepository;
  var schoolLevel = [
  "etudiant",
  "lyceen",
  "collegien",
  "candidat Libre"

];
  var selectedSchoolLevel = ''.obs;

  var classDegree = [
    "BEPC",
    "BAC",
    "BTS/DUT",
    "License"

  ];
  var selectedClassLevel = ''.obs;

  RxDouble progress = 0.0.obs;
  Timer? _timer;
  Duration duration = Duration(seconds: 10);


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
        Get.showSnackbar(Ui.SuccessSnackBar(message: 'Utilisateur connecte avec succes'));

        loginLoading.value = false;

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


}