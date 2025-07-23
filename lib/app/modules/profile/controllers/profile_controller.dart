
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../../../services/global_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileController extends GetxController {
  Rx<UserModel> currentUser = Get.find<AuthService>().user;

  var selected = "".obs;
  var hasSelected = false.obs;
  var edit = false.obs;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

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
  var languageBox =  GetStorage();


  final List<String> learningObjectives = [
    AppLocalizations.of(Get.context!).improve_my_grades,
    AppLocalizations.of(Get.context!).prepare_for_specific_exam,
    AppLocalizations.of(Get.context!).understand_specific_topic,
    AppLocalizations.of(Get.context!).learn_with_ai,
  ];

  RxBool isBestSubjectsForm = true.obs;

  Future updateProfile()async{

    try{
      isLoading.value = true;
      currentUser.value = await userRepository.updateUser(currentUser.value);
      Get.find<AuthService>().user.value = currentUser.value;
      print(currentUser.value);

      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).profile_info_updated_successful));

      isLoading.value = false;

    } catch(e){
      isLoading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {
      isLoading.value = false;
    }
  }

  Future updatePassword()async{
    onResetPassword.value = true;
    try{
      var headersList = {
        'Accept': 'application/json'
      };

      var url = Uri.parse('${GlobalService().baseUrl}/update-password/?user_id=${currentUser.value.userId}&old_password=${oldPassword.value}&new_password=${newPassword.value}%40&confirm_password=${confirmPassword.value}%40');

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var msg = jsonDecode(resBody)['message'];
        Ui.SuccessSnackBar(message: msg);
        onResetPassword.value = false;
        print(msg);
      }else{
        Ui.ErrorSnackBar(message: res.reasonPhrase.toString());
        onResetPassword.value = false;
      }

    }catch (e){
      print(e);
      onResetPassword.value = false;
    }
  }

  @override
  void onInit() async {

    super.onInit();
  }

  Future deleteAccount()async {
    try {
      var headers = {
        'Accept': 'application/json'
      };
      var request = http.MultipartRequest('DELETE', Uri.parse('${GlobalService().baseUrl}/delete/user/${currentUser.value.userId}'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await response.stream.bytesToString();
        Ui.SuccessSnackBar(message: AppLocalizations.of(Get.context!).delete_account_successful);
      }
      else {
        final resBody = await response.stream.bytesToString();
        print("Failed! $resBody");
      }
    } catch (e) {
      print(e);
    }
  }

}


