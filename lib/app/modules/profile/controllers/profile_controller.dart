import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../../../services/global_services.dart';


class ProfileController extends GetxController {
  Rx<UserModel> currentUser = Get.find<AuthService>().user;

  var selected = "".obs;
  var hasSelected = false.obs;
  var edit = false.obs;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();




  var selectedHomeIndex = 0.obs;
  var hidePassword = false.obs;
  var oldPassword = "".obs;
  var newPassword = "".obs;
  var confirmPassword = "".obs;

  var newName = '';
  var newEmail = '';
  var newClassLevel = '';
  var newAcademicLevel = '';
  var newSelected = '';
  var newObjSelected = '';

  var onResetPassword = false.obs;
  var onResetUserName = false.obs;

  late UserRepository userRepository;

  ProfileController(){
    userRepository = UserRepository();
  }

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

  final List<String> subjects = [
    AppLocalizations.of(Get.context!).sciences,
    AppLocalizations.of(Get.context!).literature_and_languages,
    AppLocalizations.of(Get.context!).economics_and_management,
    AppLocalizations.of(Get.context!).social_sciences,
    AppLocalizations.of(Get.context!).political_sciences,
    AppLocalizations.of(Get.context!).health_sciences,
    AppLocalizations.of(Get.context!).engineering,
    AppLocalizations.of(Get.context!).computer_science,
    AppLocalizations.of(Get.context!).law,
    AppLocalizations.of(Get.context!).medicine,
    AppLocalizations.of(Get.context!).architecture,
    AppLocalizations.of(Get.context!).philosophy,
    AppLocalizations.of(Get.context!).communication,
    AppLocalizations.of(Get.context!).education,
    AppLocalizations.of(Get.context!).agronomy,
    AppLocalizations.of(Get.context!).fine_arts,
    AppLocalizations.of(Get.context!).tourism_and_hospitality,
    AppLocalizations.of(Get.context!).electronics,
    AppLocalizations.of(Get.context!).accounting_and_finance,
    AppLocalizations.of(Get.context!).marketing,
    AppLocalizations.of(Get.context!).human_resources,
    AppLocalizations.of(Get.context!).journalism,
  ];

  var selectedObj = "".obs;
  var hasSelectedObj = false.obs;

  var isLoading = false.obs;
  var languageBox = GetStorage();

  final List<String> learningObjectives = [
    AppLocalizations.of(Get.context!).improve_my_grades,
    AppLocalizations.of(Get.context!).prepare_for_specific_exam,
    AppLocalizations.of(Get.context!).understand_specific_topic,
    AppLocalizations.of(Get.context!).learn_with_ai,
  ];

  RxBool isBestSubjectsForm = true.obs;

  // ============ NEW: Complete Profile Flow Variables ============

  // School levels with their corresponding class levels
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

  // Registration step tracking
  var registrationStep = 0.obs; // 0: School Level, 1: Class Level, 2: Loading, 3: Success

  // Selected values
  var selectedSchoolLevelIcon = ''.obs;
  var availableClassLevels = <String>[].obs;

  // Loading progress
  var registrationProgress = 0.0.obs;
  Timer? _progressTimer;

  @override
  void dispose() {
    oldPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // ============ NEW: Complete Profile Flow Methods ============

  void selectSchoolLevel(String level, String icon, List<String> classes) {
    selectedSchoolLevel.value = level;
    selectedSchoolLevelIcon.value = icon;
    availableClassLevels.value = classes;
    selectedClassLevel.value = ''; // Reset class level selection
  }

  void selectClassLevel(String classLevel) {
    selectedClassLevel.value = classLevel;
  }

  void nextStep() {
    if (registrationStep.value == 0) {
      // Moving from School Level to Class Level
      if (selectedSchoolLevel.value.isNotEmpty) {
        registrationStep.value = 1;
      }
    } else if (registrationStep.value == 1) {
      // Moving from Class Level to Loading
      if (selectedClassLevel.value.isNotEmpty) {
        registrationStep.value = 2;
        _startLoadingProgress();
      }
    }
  }

  void previousStep() {
    if (registrationStep.value == 1) {
      // Go back to School Level selection
      registrationStep.value = 0;
      selectedClassLevel.value = ''; // Reset class level
    } else if (registrationStep.value == 0) {
      // Go back to previous screen (if needed)
      Get.back();
    }
  }

  void _startLoadingProgress() {
    registrationProgress.value = 0.0;

    _completeRegistration();
    _progressTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (registrationProgress.value < 1.0) {
        registrationProgress.value += 0.02; // Increment by 2%
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _completeRegistration() async {
    try {
      // Update user model with selected values
      currentUser.value.academicLevel = selectedSchoolLevel.value;
      currentUser.value.classLevel = selectedClassLevel.value;

      // Save to backend
     await updateProfile();

      // Show success screen
      if (currentUser.value.userId != null){
        registrationStep.value = 3;
      }


    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      registrationStep.value = 1; // Go back to class level selection
    }
  }

  void resetCompleteProfileFlow() {
    registrationStep.value = 0;
    selectedSchoolLevel.value = '';
    selectedSchoolLevelIcon.value = '';
    selectedClassLevel.value = '';
    availableClassLevels.clear();
    registrationProgress.value = 0.0;
    _progressTimer?.cancel();
  }

  // ============ EXISTING METHODS ============

  Future updateProfile() async {
    try {
      onResetUserName.value = true;
      currentUser.value = await userRepository.updateUser(currentUser.value);
      Get.find<AuthService>().user.value = currentUser.value;
      print(currentUser.value);

      Get.showSnackbar(Ui.SuccessSnackBar(
          message: AppLocalizations.of(Get.context!).profile_info_updated_successful
      ));

      onResetUserName.value = false;
    } catch (e) {
      onResetUserName.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      onResetUserName.value = false;
    }
  }

  Future updatePassword() async {
    print("Password has changed a little bit: ${oldPassword.value}, ${confirmPassword.value}, ${newPassword.value}");
    onResetPassword.value = true;
    try {
      var headersList = {
        'Accept': 'application/json'
      };

      var url = Uri.parse(
          '${GlobalService().baseUrl}/update-password/?user_id=${currentUser.value.userId}&old_password=${oldPassword.value}&new_password=${newPassword.value}&confirm_password=${confirmPassword.value}'
      );

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var msg = jsonDecode(resBody)['message'];
        Get.showSnackbar(Ui.SuccessSnackBar(message: msg));
        onResetPassword.value = false;
        Navigator.of(Get.context!).pop(); // Close the dialog
        print(msg);
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: res.reasonPhrase.toString()));
        onResetPassword.value = false;
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      onResetPassword.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }

  Future deleteAccount() async {
    try {
      var headers = {
        'Accept': 'application/json'
      };
      var request = http.MultipartRequest(
          'DELETE',
          Uri.parse('${GlobalService().baseUrl}/delete/user/${currentUser.value.userId}')
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await response.stream.bytesToString();
        Get.showSnackbar(Ui.SuccessSnackBar(
            message: AppLocalizations.of(Get.context!).delete_account_successful
        ));
        // Navigate to login or splash screen
        Get.offAllNamed('/login');
      } else {
        final resBody = await response.stream.bytesToString();
        print("Failed! $resBody");
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(Get.context!).failed_delete_account));
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}