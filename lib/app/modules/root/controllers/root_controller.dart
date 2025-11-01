// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/file_card_model.dart';
import 'package:studyai/app/modules/files/controllers/files_controller.dart';
import 'package:studyai/app/modules/files/views/files_view.dart';
import 'package:studyai/app/modules/chat/views/chat_view.dart';
import 'package:studyai/app/modules/profile/views/profile_view.dart';
import 'package:studyai/app/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../quiz/controllers/quiz_controller.dart';
import '../../quiz/views/quiz_view.dart';




class RootController extends GetxController {
  final currentIndex = 0.obs;

  RootController() {
  }

  @override
  void onInit() async {
    super.onInit();
  }

  List<Widget> pages = [
    const FilesView(),
    const QuizView(),
    const ChatView(),
    const ProfileView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  Future<void> changePageInRoot(int _index) async {
    if (Get.find<AuthService>().user.value.email == null && _index > 0) {
      await Get.offNamed(Routes.LOGIN);
    } else {
      if(_index == 1){
        Get.find<QuizController>().generationState = QuizGenerationState.start.obs;
        Get.find<QuizController>().selectedCourse = FileCardModel(title: '', timeInfo: '', type: '', createdAt: '', ).obs;
      }
      if(_index == 0){
        //Get.find<FilesController>().getCompleteFileList();
      }

      currentIndex.value = _index;
      await refreshPage(_index);
      Get.lazyPut(()=>AuthController());
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if (Get.find<AuthService>().user.value.email == null && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }else{
      currentIndex.value = _index;
      await refreshPage(_index);
       await Get.offNamedUntil(Routes.ROOT, (Route route) {
        if (route.settings.name == Routes.ROOT) {
          return true;
        }
        return true;
      }, arguments: _index);
    }
  }

  Future<void> changePage(int _index) async {

    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          Get.lazyPut(()=>AuthController());
          Get.lazyPut(()=>FilesController());
          if(Get.find<AuthService>().user.value.email != null){
            //await Get.find<FilesController>().refreshCommunity();
            await Get.find<FilesController>().getCompleteFileList();
          }

          break;
        }
      case 1:
        {
          //await Get.find<QuizzController>().refreshDashboard();
          break;
        }
      case 2:
        {
          //Get.find<ChatController>().isRootFolder = true;
          break;
        }
      case 3:
        {
          if(Get.find<AuthService>().user.value.email != null){
            //await Get.find<ProfileController>().refreshEvents();
          }
          break;
        }
    }
  }



}

