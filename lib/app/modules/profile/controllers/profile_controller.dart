
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  Rx<UserModel> currentUser = Get.find<AuthService>().user;

  var selected = "".obs;
  var hasSelected = false.obs;
  var edit = false.obs;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

  var selectedHomeIndex = 0.obs;
  var hidePassword = false.obs;
  var newPassword = "".obs;
  var confirmPassword = "".obs;

  var newName = '';
  var newEmail = '';
  var newClassLevel = '';
  var newAcademicLevel = '';
  var newSelected = '';
  var newObjSelected = '';

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

  @override
  void onInit() async {

    super.onInit();
  }

  Future updatePassword() async{

  }

}


