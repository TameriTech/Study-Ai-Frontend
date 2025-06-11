import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_services.dart';
import '../../auth/controllers/auth_controller.dart';



class ProfileController extends GetxController {
  Rx<UserModel> currentUser = Get.find<AuthService>().user;

  final List<String> subjects = [
    'Maths', 'Droit', 'Info', 'Chimie',
    'Physique', 'Comptabilité', 'Électronique', 'Physique',
    'Maths', 'Histoire', 'SVT', 'Maths',
    'Physique', 'Géographie', 'Economie', 'Physique',
  ];

  final List<String> learningObjectives = [
    'Améliorer mes notes',
    'Préparer un examen spécifique',
    'Comprendre un sujet précis',
    'Apprendre avec l\'IA',
  ];

  RxBool isBestSubjectsForm = true.obs;

  ProfileController() {

  }

  @override
  void onInit() async {

    super.onInit();
  }

}


