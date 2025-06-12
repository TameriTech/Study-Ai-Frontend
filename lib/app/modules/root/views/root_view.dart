import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../../common/helper.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';

import '../controllers/root_controller.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: controller.currentPage,
        backgroundColor: bgColor,
        extendBody: true,
        bottomNavigationBar: CustomBottomNavigationBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          itemColor: secondaryColor,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 0?Image.asset(
                'assets/images/Fichiers_bold.png',
              ):Image.asset(
                'assets/images/Fichiers.png',
              ),
              label: 'Fichier',
            ),
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 1?Image.asset(
                'assets/images/quizz_bold.png',
              ):Image.asset(
                'assets/images/quizz.png',
              ),
              label: 'Quiz',
            ),

            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 2?Image.asset(
                'assets/images/chat_bold.png',
              ):Image.asset(
                'assets/images/chat.png',
              ),
              label: 'Chat',
            ),
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 3?Image.asset(
                'assets/images/profil_bold.png',
              ):Image.asset(
                'assets/images/profil.png',
              ),
              label: 'Profil',

            ),
          ],
        ),
      ),
    ));
    }
  }

