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

import '../../../../color_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../services/global_services.dart';
import 'facebook_api.dart';

class AuthController extends GetxController {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String _contactText = '';

  Rx<UserModel> currentUser = Get.find<AuthService>().user;
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Text Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  RxInt registrationStep = 0.obs;
  RxBool hidePassword = false.obs;
  RxBool hideConfirmPassword = false.obs;
  RxBool loginLoading = false.obs;
  RxBool recoverLoading = false.obs;
  RxString confirmPassword = ''.obs;

  // School and Class Level
  RxString selectedSchoolLevel = ''.obs;
  RxString selectedSchoolLevelIcon = ''.obs;
  RxString selectedClassLevel = ''.obs;
  RxList<String> availableClassLevels = <String>[].obs;

  // Registration progress
  RxDouble registrationProgress = 0.0.obs;
  Timer? _progressTimer;

  late UserRepository userRepository;

  // School levels with their corresponding class levels
  //AppLocalizations.of(Get.context!).
  final List<Map<String, dynamic>> schoolLevels = [
    {
      'name': AppLocalizations.of(Get.context!).primary_education,
      'icon': '🏫',
      'classes': [AppLocalizations.of(Get.context!).form_one, AppLocalizations.of(Get.context!).form_two, AppLocalizations.of(Get.context!).form_three, AppLocalizations.of(Get.context!).form_four]
    },
    {
      'name': AppLocalizations.of(Get.context!).high_school_student,
      'icon': '🏠',
      'classes': [AppLocalizations.of(Get.context!).grade_six, AppLocalizations.of(Get.context!).grade_seven, AppLocalizations.of(Get.context!).grade_eight, AppLocalizations.of(Get.context!).grade_nine]
    },
    {
      'name': AppLocalizations.of(Get.context!).senior_high_school,
      'icon': '📚',
      'classes': [AppLocalizations.of(Get.context!).grade_ten, AppLocalizations.of(Get.context!).grade_eleven, AppLocalizations.of(Get.context!).grade_twelve]
    },
    {
      'name': AppLocalizations.of(Get.context!).undergraduate,
      'icon': '🎓',
      'classes': [AppLocalizations.of(Get.context!).year_one, AppLocalizations.of(Get.context!).year_two, AppLocalizations.of(Get.context!).year_three, AppLocalizations.of(Get.context!).year_four, AppLocalizations.of(Get.context!).year_five]
    },
    {
      'name': AppLocalizations.of(Get.context!).post_graduate,
      'icon': '📖',
      'classes': [AppLocalizations.of(Get.context!).master_degree, AppLocalizations.of(Get.context!).doctoral_degree, AppLocalizations.of(Get.context!).postgraduate_diplomas, AppLocalizations.of(Get.context!).professional_doctorates]
    },
  ];

  AuthController() {
    userRepository = UserRepository();
    Get.lazyPut(() => RootController());
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => LaravelApiClient(dio: Dio()));
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _progressTimer?.cancel();
    super.onClose();
  }

  // Navigate to next registration step
  void nextStep() {
    if (registrationStep.value == 0) {
      // Validate form before proceeding
      if (registerFormKey.currentState!.validate()) {
        if (passwordController.text != confirmPasswordController.text) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context!).password_not_same));
          return;
        }
        registrationStep.value++;
      }
    } else if (registrationStep.value == 1) {
      // Validate school level selection
      if (selectedSchoolLevel.value.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context!).please_select_school_level));
        return;
      }
      registrationStep.value++;
    } else if (registrationStep.value == 2) {
      // Validate class level selection
      if (selectedClassLevel.value.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context!).please_select_class_level));
        return;
      }
      submitRegistration();
    }
  }

  // Navigate to previous registration step
  void previousStep() {
    if (registrationStep.value > 0) {
      registrationStep.value--;
    }
  }

  // Select school level
  void selectSchoolLevel(String level, String icon, List<String> classes) {
    selectedSchoolLevel.value = level;
    selectedSchoolLevelIcon.value = icon;
    availableClassLevels.value = classes;
  }

  // Select class level
  void selectClassLevel(String classLevel) {
    selectedClassLevel.value = classLevel;
  }

  // Submit registration
  Future<void> submitRegistration() async {
    try {
      registrationStep.value = 3; // Move to loading screen
      startProgressAnimation();

      // Update user model with all collected data
      currentUser.value.fullName = fullNameController.text;
      currentUser.value.email = emailController.text;
      currentUser.value.password = passwordController.text;
      currentUser.value.academicLevel = selectedSchoolLevel.value;
      currentUser.value.classLevel = selectedClassLevel.value;

      // Call your registration API
      await register();

      // Stop progress animation
      _progressTimer?.cancel();
      registrationProgress.value = 1.0;

      // Wait a bit to show completion
      await Future.delayed(Duration(milliseconds: 500));
      // Move to success screen
      if (currentUser.value.userId != null){
        registrationStep.value = 4;
      }



    } catch (e) {
      _progressTimer?.cancel();
      registrationStep.value = 2; // Go back to class selection
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // Start progress animation
  void startProgressAnimation() {
    registrationProgress.value = 0.0;
    const duration = Duration(seconds: 3);
    const steps = 30;
    const increment = 1.0 / steps;

    _progressTimer = Timer.periodic(duration ~/ steps, (timer) {
      if (registrationProgress.value >= 1.0) {
        timer.cancel();
      } else {
        registrationProgress.value += increment;
      }
    });
  }

  Future<void> login() async {
    Get.focusScope?.unfocus();
    if (loginFormKey.currentState!.validate()) {
      try {
        currentUser.value.email = emailController.text;
        currentUser.value.password = passwordController.text;
        loginLoading.value = true;
        var id = await userRepository.login(currentUser.value);
        await getUser(id);
        loginLoading.value = false;
        var box = GetStorage();
        box.write("exists", true);
        Get.toNamed(Routes.ROOT);
      } catch (e) {
        loginLoading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loginLoading.value = false;
      }
    }
  }

  // Register user
  Future<void> register() async {
    try {
      Get.focusScope?.unfocus();

      // Validate required fields
      if (currentUser.value.email == null || currentUser.value.email!.isEmpty) {
        throw Exception(AppLocalizations.of(Get.context!).email_required);
      }
      if (currentUser.value.password == null || currentUser.value.password!.isEmpty) {
        throw Exception(AppLocalizations.of(Get.context!).password_required);
      }
      if (currentUser.value.fullName == null || currentUser.value.fullName!.isEmpty) {
        throw Exception(AppLocalizations.of(Get.context!).full_name_required);
      }

      // Call API to register
      currentUser.value = await userRepository.register(currentUser.value);

      // Save to AuthService
      Get.find<AuthService>().user.value = currentUser.value;

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      throw e;
    }
  }

  Future<void> getUser(int id) async {
    Get.focusScope?.unfocus();

    try {
      Get.find<AuthService>().user.value = await userRepository.getUser(id);
      currentUser.value = Get.find<AuthService>().user.value;
      print('name is ${Get.find<AuthService>().user.value}');
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      await GoogleApi.signIn();
      debugPrint(GoogleApi.userinfo().toString());
      if (GoogleApi.userinfo() != null) {
        GoogleApi.userinfo()?.authentication.then((value) async {
          print('Id token: ${value.idToken}');
          print("Access token: ${value.accessToken}");
          if (value.idToken != null) {
            var id = await userRepository.loginGoogle(value.idToken!);
            await getUser(id);

            if(id != null){
              Get.showSnackbar(Ui.SuccessSnackBar(
                  message: AppLocalizations.of(Get.context!).login_successful));
              loginLoading.value = false;
              Get.toNamed(Routes.ROOT);
            }


          }
        });
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
        if (FacebookApi.accessToken != null) {
          var id = await userRepository.loginFacebook(FacebookApi.accessToken!);
          await getUser(id);
          Get.showSnackbar(Ui.SuccessSnackBar(
              message: AppLocalizations.of(Get.context!).login_successful));

          loginLoading.value = false;

          Get.toNamed(Routes.ROOT);
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future resetPassword(String value) async {
    try {
      var headersList = {'Content-Type': 'application/json'};
      var url = Uri.parse('${GlobalService().baseUrl}/forgot-password');

      var body = {"email": value};

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
        recoverLoading.value = false;

        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(Get.context!).password_changed,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      fontFamily: 'Inter'
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${AppLocalizations.of(Get.context!).sent_email_with_password} $value',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff2A2A2A),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter'
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(Get.context!).continu,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      } else {
        Get.showSnackbar(
          Ui.ErrorSnackBar(message: res.reasonPhrase.toString()),
        );
        recoverLoading.value = false;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      recoverLoading.value = false;
    }
  }
}

