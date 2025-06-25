
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
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

  final List<String> subjects = [
    'Sciences',
    'Lettres et Langues',
    'Économie et Gestion',
    'Sciences Sociales',
    'Sciences Politiques',
    'Sciences de la Santé',
    'Ingénierie',
    'Informatique',
    'Droit',
    'Médecine',
    'Architecture',
    'Philosophie',
    'Communication',
    'Éducation',
    'Agronomie',
    'Beaux-Arts',
    'Tourisme et Hôtellerie',
    'Électronique',
    'Comptabilité et Finance',
    'Marketing',
    'Ressources Humaines',
    'Journalisme',
  ];

  var selectedObj = "".obs;
  var hasSelectedObj = false.obs;

  var isLoading = false.obs;

  final List<String> learningObjectives = [
    'Améliorer mes notes',
    'Préparer un examen spécifique',
    'Comprendre un sujet précis',
    'Apprendre avec l\'IA',
  ];

  RxBool isBestSubjectsForm = true.obs;

  Future updateProfile()async{

    try{
      isLoading.value = true;
      currentUser.value = await userRepository.updateUser(currentUser.value);
      Get.find<AuthService>().user.value = currentUser.value;
      print(currentUser.value);

      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Inscription complété avec succès!'));

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
        Ui.SuccessSnackBar(message: "Compte supprimé avec succès!");
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


