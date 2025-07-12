import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import '../../../../common/helper.dart';
import '../../../color_constants.dart';
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
          child: Container(
            decoration: BoxDecoration(
                color: bgColor,
                ),
            height: Get.height,
            child: ListView(
              children: [
                Image.asset(
                  'assets/images/onboardingImage.png',
                  width: Get.width,
                  fit: BoxFit.cover,
                  height: Get.height/3,
            
                ),
                Container(
                  //margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                        topRight:  Radius.circular(20))
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo_studyai.png',
                          width: 84,
                          fit: BoxFit.fitWidth,
                          height: 32,

                        ).marginOnly(bottom: 20),
                        Text("Apprenez, Revisez, Progressez avec l' IA", style: Get.textTheme.labelMedium, textAlign: TextAlign.center,).marginSymmetric(horizontal: 20, vertical: 20),
                        Text("boostez votre apprentissage grâce à une plateforme intuitive et assistée par l’IA.", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400), textAlign: TextAlign.center,).marginOnly(bottom: 20, left: 50, right: 50),
                        SizedBox(
                          width: Get.width,
                          child: BlockButtonWidget(
                              color: primaryColor,
                              haveBorder: false,
                              text: Text('Commencer', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),),
                              onPressed: (){
                                Get.toNamed(Routes.REGISTER);

                              }),
                        ).marginOnly(top: Get.height/20),

                       Wrap(children: [
                          Text( "J' ai deja un compte: ", style: TextStyle(color: Color(0xff474646), fontWeight: FontWeight.w400, fontSize: 16)),

                          GestureDetector(
                            onTap: (){
                              Get.toNamed(Routes.LOGIN);
                            },
                              child: Text("Je me connecte", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 16) )),

                        ]).marginOnly(top: Get.height/40)

                      ],
                    ),
                  ),
            
                )
            
            
            ],),
          )

      ),
    );
  }
}
