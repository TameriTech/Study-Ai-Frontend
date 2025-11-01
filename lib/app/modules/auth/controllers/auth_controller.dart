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
  final List<Map<String, dynamic>> schoolLevels = [
    {
      'name': 'Primary Education',
      'icon': '🏫',
      'classes': ['Form One', 'Form Two', 'Form Three', 'Form Four']
    },
    {
      'name': 'High School',
      'icon': '🏠',
      'classes': ['Grade 6', 'Grade 7', 'Grade 8', 'Grade 9']
    },
    {
      'name': 'Senior High School',
      'icon': '📚',
      'classes': ['Grade 10', 'Grade 11', 'Grade 12']
    },
    {
      'name': 'Undergraduate',
      'icon': '🎓',
      'classes': ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5']
    },
    {
      'name': 'Postgraduate',
      'icon': '📖',
      'classes': ['Master\'s Degree', 'Doctoral Degree', 'Postgraduate Diplomas', 'Professional Doctorates']
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
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Passwords do not match"));
          return;
        }
        registrationStep.value++;
      }
    } else if (registrationStep.value == 1) {
      // Validate school level selection
      if (selectedSchoolLevel.value.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select a school level"));
        return;
      }
      registrationStep.value++;
    } else if (registrationStep.value == 2) {
      // Validate class level selection
      if (selectedClassLevel.value.isEmpty) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select a class level"));
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
      registrationStep.value = 4;

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
        throw Exception("Email is required");
      }
      if (currentUser.value.password == null || currentUser.value.password!.isEmpty) {
        throw Exception("Password is required");
      }
      if (currentUser.value.fullName == null || currentUser.value.fullName!.isEmpty) {
        throw Exception("Full name is required");
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
            Get.showSnackbar(Ui.SuccessSnackBar(
                message: AppLocalizations.of(Get.context!).login_successful));

            loginLoading.value = false;

            Get.toNamed(Routes.ROOT);
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
                    'Password Changed',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0056D2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We sent an email with a new password to $value',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
















//
// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:studyai/app/models/user_model.dart';
// import 'package:studyai/app/modules/auth/controllers/google_api.dart';
// import 'package:studyai/app/modules/root/controllers/root_controller.dart';
// import 'package:studyai/app/providers/laravel_provider.dart';
// import 'package:studyai/app/repositories/user_repository.dart';
// import 'package:studyai/app/routes/app_routes.dart';
// import 'package:studyai/app/services/auth_service.dart';
// import 'package:studyai/common/ui.dart';
// import 'package:http/http.dart' as http;
// import '../../../../color_constants.dart';
// import '../../../../l10n/app_localizations.dart';
// import '../../../services/global_services.dart';
// import 'facebook_api.dart';
//
// class AuthController extends GetxController {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false;
//   String _contactText = '';
//   Rx<UserModel> currentUser = Get.find<AuthService>().user;
//   final loginFormKey = GlobalKey<FormState>();
//   final registerFormKey = GlobalKey<FormState>();
//
//   // Text Editing Controllers
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   //Forgot password process
//   var email = "".obs;
//
//   // Observable variables
//   RxInt registrationStep = 0.obs;
//   RxBool hidePassword = false.obs;
//   RxBool hideConfirmPassword = false.obs;
//   RxBool loginLoading = false.obs;
//   RxBool recoverLoading = false.obs;
//   RxString confirmPassword = ''.obs;
//
//   // School and Class Level
//   RxString selectedSchoolLevel = ''.obs;
//   RxString selectedSchoolLevelTitle = ''.obs;
//   RxString selectedClassLevel = ''.obs;
//   RxString classLevelQuestion = ''.obs;
//   RxList<String> availableClassLevels = <String>[].obs;
//
//   // Registration progress
//   RxDouble registrationProgress = 0.0.obs;
//   Timer? _progressTimer;
//
//   late UserRepository userRepository;
//
//   // School levels with their corresponding class levels
//   List<Map<String, dynamic>> schoolLevels = [
//     {
//       'name': 'Nursery School',
//       'icon': '👶',
//       'classes': ['Nursery 1', 'Nursery 2', 'Nursery 3']
//     },
//     {
//       'name': 'Primary School',
//       'icon': '📚',
//       'classes': ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6']
//     },
//     {
//       'name': 'Secondary School',
//       'icon': '🎓',
//       'classes': ['Form 1', 'Form 2', 'Form 3', 'Form 4', 'Form 5']
//     },
//     {
//       'name': 'High School',
//       'icon': '🏫',
//       'classes': ['Lower Sixth', 'Upper Sixth']
//     },
//     {
//       'name': 'University',
//       'icon': '🎯',
//       'classes': ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5+']
//     },
//   ];
//
//   @override
//   void onInit() {
//     super.onInit();
//     userRepository = UserRepository();
//     Get.lazyPut(()=>RootController());
//     Get.lazyPut(() => AuthService());
//
//     Get.lazyPut(() => LaravelApiClient(dio: Dio()));
//     // Get.lazyPut(() => DashboardController());
//     // Get.lazyPut(() => CommunityController());
//     // Get.lazyPut(() => NotificationController());
//     // Get.lazyPut(() => EventsController());
//     userRepository = UserRepository();
//
//     // Initialize text controllers with current user data if available
//     if (currentUser.value.fullName != null) {
//       fullNameController.text = currentUser.value.fullName!;
//     }
//     if (currentUser.value.email != null) {
//       emailController.text = currentUser.value.email!;
//     }
//   }
//
//   @override
//   void onClose() {
//     fullNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     _progressTimer?.cancel();
//     super.onClose();
//   }
//
//   // Navigate to next registration step
//   void nextStep() {
//     if (registrationStep.value == 0) {
//       // Validate form before proceeding
//       if (registerFormKey.currentState!.validate()) {
//         if (passwordController.text != confirmPasswordController.text) {
//           Get.showSnackbar(Ui.ErrorSnackBar(message: "Passwords do not match"));
//           return;
//         }
//         registrationStep.value++;
//       }
//     } else if (registrationStep.value == 1) {
//       // Validate school level selection
//       if (selectedSchoolLevel.value.isEmpty) {
//         Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select a school level"));
//         return;
//       }
//       registrationStep.value++;
//     } else if (registrationStep.value == 2) {
//       // Validate class level selection
//       if (selectedClassLevel.value.isEmpty) {
//         Get.showSnackbar(Ui.ErrorSnackBar(message: "Please select a class level"));
//         return;
//       }
//       submitRegistration();
//     }
//   }
//
//   // Navigate to previous registration step
//   void previousStep() {
//     if (registrationStep.value > 0) {
//       registrationStep.value--;
//     }
//   }
//
//   // Select school level
//   void selectSchoolLevel(String level, String icon, List<String> classes) {
//     selectedSchoolLevel.value = level;
//     selectedSchoolLevelTitle.value = level;
//     availableClassLevels.value = classes;
//
//     // Set the appropriate question based on school level
//     if (level == 'Nursery School') {
//       classLevelQuestion.value = 'Which nursery class are you in?';
//     } else if (level == 'Primary School') {
//       classLevelQuestion.value = 'Which primary class are you in?';
//     } else if (level == 'Secondary School') {
//       classLevelQuestion.value = 'Which form are you in?';
//     } else if (level == 'High School') {
//       classLevelQuestion.value = 'Which level are you in?';
//     } else if (level == 'University') {
//       classLevelQuestion.value = 'Which year are you in?';
//     }
//   }
//
//   // Select class level
//   void selectClassLevel(String classLevel) {
//     selectedClassLevel.value = classLevel;
//   }
//
//   // Submit registration
//   Future<void> submitRegistration() async {
//     try {
//       registrationStep.value = 3; // Move to loading screen
//       startProgressAnimation();
//
//       // Update user model with all collected data
//       currentUser.value.fullName = fullNameController.text;
//       currentUser.value.email = emailController.text;
//       currentUser.value.password = passwordController.text;
//       currentUser.value.academicLevel = selectedSchoolLevel.value;
//       currentUser.value.classLevel = selectedClassLevel.value;
//
//       // Call your registration API
//       await register();
//
//       // Stop progress animation
//       _progressTimer?.cancel();
//       registrationProgress.value = 1.0;
//
//       // Wait a bit to show completion
//       await Future.delayed(Duration(milliseconds: 500));
//
//       // Move to success screen
//       registrationStep.value = 4;
//
//     } catch (e) {
//       _progressTimer?.cancel();
//       registrationStep.value = 2; // Go back to class selection
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//     }
//   }
//
//   // Start progress animation
//   void startProgressAnimation() {
//     registrationProgress.value = 0.0;
//     const duration = Duration(seconds: 3);
//     const steps = 30;
//     const increment = 1.0 / steps;
//
//     _progressTimer = Timer.periodic(duration ~/ steps, (timer) {
//       if (registrationProgress.value >= 1.0) {
//         timer.cancel();
//       } else {
//         registrationProgress.value += increment;
//       }
//     });
//   }
//
//
//   Future<void> login() async {
//     Get.focusScope?.unfocus();
//     if (loginFormKey.currentState!.validate()) {
//       try{
//         currentUser.value.email = emailController.text;
//         currentUser.value.password = passwordController.text;
//         loginLoading.value = true;
//         var id = await userRepository.login(currentUser.value);
//         await getUser(id);
//         //Get.showSnackbar(Ui.SuccessSnackBar(message: 'Utilisateur connecte avec succes'));
//         loginLoading.value = false;
//         var box = GetStorage();
//         box.write("exists", true);
//         Get.toNamed(Routes.ROOT);
//       } catch(e){
//         loginLoading.value = false;
//         Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//
//       }
//       finally {
//         loginLoading.value = false;
//       }
//     }else{
//
//     }
//   }
//
//   // Register user
//   Future<void> register() async {
//     try {
//       Get.focusScope?.unfocus();
//
//       // Validate required fields
//       if (currentUser.value.email == null || currentUser.value.email!.isEmpty) {
//         throw Exception("Email is required");
//       }
//       if (currentUser.value.password == null || currentUser.value.password!.isEmpty) {
//         throw Exception("Password is required");
//       }
//       if (currentUser.value.fullName == null || currentUser.value.fullName!.isEmpty) {
//         throw Exception("Full name is required");
//       }
//
//       // Call API to register
//       currentUser.value = await userRepository.register(currentUser.value);
//
//       // Save auth token if provided
//       if (currentUser.value.userId != null) {
//         registrationStep.value = 0;
//         await Get.toNamed(Routes.LOGIN);
//       }
//
//     } catch (e) {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//       throw e;
//     }
//   }
//
//
//   Future<void> getUser(int id) async {
//     Get.focusScope?.unfocus();
//
//     try{
//
//       Get.find<AuthService>().user.value = await userRepository.getUser(id);
//       currentUser.value= Get.find<AuthService>().user.value;
//       print('name is ${Get.find<AuthService>().user.value}');
//
//
//     } catch(e){
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//
//     }
//     finally {
//       //loading.value = false;
//     }
//
//   }
//
//   Future<void> handleGoogleSignIn() async {
//     try {
//       await GoogleApi.signIn();
//       debugPrint(GoogleApi.userinfo().toString());
//       if(GoogleApi.userinfo() != null){
//         GoogleApi.userinfo()?.authentication.then((value) async {
//           print('Id token: ${value.idToken}');
//           print("Access token: ${value.accessToken}");
//           if(value.idToken != null){
//             var id = await userRepository.loginGoogle(value.idToken!);
//             await getUser(id);
//             Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).login_successful));
//
//             loginLoading.value = false;
//
//             Get.toNamed(Routes.ROOT);
//           }
//
//
//         } ,);
//
//       }
//
//
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }
//
//   Future<void> handleGoogleSignOut(BuildContext context) async {
//     try {
//       await GoogleApi.signOut();
//       debugPrint(GoogleApi.userinfo().toString());
//       Get.offAllNamed(Routes.LOGIN);
//
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }
//
//
//   Future<void> handleFacebookSignIn() async {
//     try {
//       await FacebookApi.facebookSignIn();
//       debugPrint(FacebookApi.userinfo.toString());
//       if (FacebookApi.userinfo != null) {
//         if(FacebookApi.accessToken != null){
//           var id = await userRepository.loginFacebook(FacebookApi.accessToken!);
//           await getUser(id);
//           Get.showSnackbar(
//               Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).login_successful));
//
//           loginLoading.value = false;
//
//           Get.toNamed(Routes.ROOT);
//         }
//
//       }
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }
//
//   Future resetPassword(String value) async {
//     try {
//       var headersList = {'Content-Type': 'application/json'};
//       var url = Uri.parse('${GlobalService().baseUrl}/forgot-password');
//
//       var body = {"email": value};
//
//       var req = http.Request('POST', url);
//       req.headers.addAll(headersList);
//       req.body = json.encode(body);
//
//       var res = await req.send();
//       final resBody = await res.stream.bytesToString();
//
//       if (res.statusCode >= 200 && res.statusCode < 300) {
//         print(resBody);
//         recoverLoading.value = false;
//
//         // Show success dialog matching the design
//         showDialog(
//           context: Get.context!,
//           barrierDismissible: false,
//           builder: (context) => Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 8),
//                   Text(
//                     'Password Changed',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF0056D2),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'We sent an email with a new password to $value',
//                     style: TextStyle(
//                       fontSize: 15,
//                       color: Colors.black87,
//                       height: 1.4,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         Get.offAllNamed(Routes.LOGIN);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF0056D2),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         'Continue',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                 ],
//               ),
//             ),
//           ),
//         );
//       } else {
//         Get.showSnackbar(
//           Ui.ErrorSnackBar(message: res.reasonPhrase.toString()),
//         );
//         recoverLoading.value = false;
//       }
//     } catch (e) {
//       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
//       recoverLoading.value = false;
//     }
//   }
//}