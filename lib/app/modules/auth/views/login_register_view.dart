import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/app/modules/global_widgets/text_field_widget.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginRegisterView extends GetView<AuthController> {

  //backgroundColor: Colors.white,
  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: SafeArea(
        child: Scaffold(
            body: Form(
                key: controller.loginFormKey,
                child: Obx(() => controller.isLoginScreen.value?
                loginScreen(context):
                registerScreen(context),)
            )

        ),
      ),
    );
  }

  Widget registerScreen(BuildContext context){
    return Stack(
      children: [

        Image.asset(
          'assets/images/new_account.png',
          width: Get.width,
          fit: BoxFit.fitWidth,
          height: 231,

        ),
        Positioned(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: ListView(
                children: [
                  TextFieldWidget(
                    suffixIcon: Icon(null),
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    labelText: 'Votre addresse Gmail',
                    hintText: "johndoe@gmail.com",
                  ).marginOnly(top: 80),

                  SizedBox(
                    width: Get.width,
                    child: BlockButtonWidget(
                        color: Colors.black,
                        haveBorder: false,
                        text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                        onPressed: (){
                          Get.toNamed(Routes.REGISTER);

                        }),
                  ).marginOnly(top: 20),

                  Align(
                      alignment: Alignment.center,
                      child: Text('Creer avec', style: Get.textTheme.displaySmall,)).marginOnly(top: 40, bottom: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logos_facebook.png',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/images/logos_google.png',
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/images/logos_apple.png',
                        fit: BoxFit.cover,
                      )
                    ],
                  ).paddingSymmetric(horizontal: Get.width/3.8),

                  Align(
                    alignment: Alignment.center,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.transparent, Colors.grey, Colors.grey, Colors.transparent],
                          stops: [0.0, 0.2, 0.8, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        height: 2, // Line thickness
                        width: 200, // Line width
                        color: Colors.grey, // Line color
                      ),
                    ),
                  ).marginOnly(top: 10, bottom: 40),


                  BlockButtonWidget(color: Colors.white,
                      haveBorder: true,
                      text: Text('Connexion', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.black, fontWeight: FontWeight.w600, ), ),),
                      onPressed: (){


                      }),

                  GestureDetector(
                      onTap: (){
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: Text("Ajouter un nouveau compte"))

                ],
              ),
            ).marginOnly(top: 180))
      ],
    );
  }

  Widget loginScreen(BuildContext context){
    return Stack(
      children: [
        Image.asset(
          'assets/images/login_image.png',
          width: Get.width,
          fit: BoxFit.cover,
          height: 231,

        ),
        Positioned(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: ListView(
                children: [
                  TextFieldWidget(
                    suffixIcon: Icon(null),
                    suffix: Icon(null),
                    readOnly: false,
                    labelText: 'Gmail',
                    hintText: 'user@gmail.com',
                    isFirst: true,
                    onChanged: (value) => {
                      controller.currentUser.value.email = value,
                    },
                    validator: (input) => !input!.contains('@') ? 'Input an email' : null,

                  ),
                  Obx(() => TextFieldWidget(
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    labelText: 'Mot de passe',
                    hintText: "••••••••••••••••",
                    textController: TextEditingController(text: controller.currentUser.value.password),
                    obscureText: !controller.hidePassword.value,
                    onChanged: (value) => {
                      controller.currentUser.value.password = value
                    },
                    validator: (input) => input!.length < 6 ? 'input at least 6 characters' : null,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePassword.value = !controller.hidePassword.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),

                  ),
                  ),

                  SizedBox(
                    width: Get.width,
                    child: Obx(() => !controller.loginLoading.value?
                    BlockButtonWidget(
                        color: Colors.black,
                        haveBorder: false,
                        text: Text('Connexion', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                        onPressed: (){
                          controller.login();
                        }):
                    BlockButtonWidget(
                      haveBorder: false,
                      onPressed: () async {

                      },
                      color: primaryColor,
                      text: const SizedBox(height: 30,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ),),
                  ).marginOnly(top: 20),

                  Align(
                      alignment: Alignment.center,
                      child: Text('Se connecter avec', style: Get.textTheme.displaySmall,)).marginOnly(top: 40, bottom: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/images/logos_facebook.png',
                          fit: BoxFit.cover,
                        ),
                        onTap: (){

                        },
                      ),

                      GestureDetector(
                        child: Image.asset(
                          'assets/images/logos_google.png',
                          fit: BoxFit.cover,
                        ),
                        onTap: (){
                          controller.handleSignIn();
                        },
                      ),

                      Image.asset(
                        'assets/images/logos_apple.png',
                        fit: BoxFit.cover,
                      )
                    ],
                  ).paddingSymmetric(horizontal: Get.width/3.8),
                  Align(
                    alignment: Alignment.center,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.transparent, Colors.grey, Colors.grey, Colors.transparent],
                          stops: [0.0, 0.2, 0.8, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Container(
                        height: 2, // Line thickness
                        width: 200, // Line width
                        color: Colors.grey, // Line color
                      ),
                    ),
                  ).marginOnly(top: 10),

                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                        onTap: (){
                          controller.minimumInformationStep1.value = false;
                          controller.minimumInformationStep2.value = false;
                          controller.minimumInformationStep3.value = false;
                          controller.registerInfoComplete.value = false;
                          controller.registerInfoHalfSaved.value = false;
                          Get.toNamed(Routes.REGISTER);
                        },
                        child: Text("Ajouter un nouveau compte", style: TextStyle(color: Color(0xff474646), fontSize: 16, fontWeight: FontWeight.w400),)),
                  ).marginOnly(top: Get.height/12)
                ],
              ),
            ).marginOnly(top: 180)
        )
      ],
    );
  }
}
