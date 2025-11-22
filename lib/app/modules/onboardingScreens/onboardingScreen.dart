import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import '../../../../common/helper.dart';
import '../../../color_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../routes/app_routes.dart';
import '../auth/controllers/auth_controller.dart';


class OnboardingScreen extends GetView<AuthController> {

  //backgroundColor: Colors.white,
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  color: bgColor,
                  ),
              height: Get.height,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/onboardingImage.png',
                    width: Get.width,
                    fit: BoxFit.cover,
              
                  ),
                  Positioned(
                    top:MediaQuery.of(context).size.height*0.38,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.75,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),
                            topRight:  Radius.circular(24),
                        ),
                        color: secondBgColor
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo_studyai.png',
                              width: 98,
                              fit: BoxFit.fitHeight,
                              height: 32,
              
                            ).marginOnly(bottom: 60, top: 20),
                            Text(AppLocalizations.of(context).learn_revise_progress,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 24
                              ), textAlign: TextAlign.center,).marginSymmetric(horizontal: 20, vertical: 20),
                            Text(AppLocalizations.of(context).power_learning_message,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xff2A2A2A)), textAlign: TextAlign.center,)
                                .marginOnly(bottom: 20, left: 60, right: 50),
                            SizedBox(
                              width: Get.width,
                              child: BlockButtonWidget(
                                  color: primaryColor,
                                  haveBorder: false,
                                  text: Text(AppLocalizations.of(context).create_account, style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),),
                                  onPressed: (){
                                    Get.toNamed(Routes.REGISTER);
              
                                  }),
                            ).marginOnly(top: Get.height/20),
              
                          GestureDetector(
                              onTap: (){
                                Get.toNamed(Routes.LOGIN);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    AppLocalizations.of(context).login,
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16) ),
                              )).marginOnly(top: Get.height/25, bottom: Get.height*0.01)
              
                          ],
                        ),
                      ),
              
                    ),
                  )
              
              
              ],),
            ),
          )

      ),
    );
  }
}
