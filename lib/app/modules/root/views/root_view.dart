import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';

import '../controllers/root_controller.dart';


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
          itemColor: primaryColor,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 0? Icon(Icons.home, color: primaryColor,)
                  :Icon(Icons.home_outlined,) ,
              label: AppLocalizations.of(context).file,
            ),
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 1?Icon(Icons.electric_bolt, color: primaryColor,)
                  :Icon(Icons.electric_bolt_outlined, color: Colors.grey.shade400, ) ,
              label: AppLocalizations.of(context).quiz,
            ),

            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 2?Icon(Icons.smart_toy, color: primaryColor,)
                  :Icon(Icons.smart_toy_outlined, ),
              label: AppLocalizations.of(context).ai,
            ),
            CustomBottomNavigationItem(
              icon: controller.currentIndex.value == 3?Icon(Icons.person, color: primaryColor,)
                  :Icon(Icons.person_outlined,) ,
              label: AppLocalizations.of(context).profile,

            ),
          ],
        ),
      ),
    ));
    }
  }

