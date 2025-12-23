import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/app/modules/global_widgets/text_field_widget.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';



class LoginView extends GetView<AuthController> {

  //backgroundColor: Colors.white,
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            color: bgColor,
            height: MediaQuery.of(context).size.height,
            child: Form(
                key: controller.loginFormKey,
                child: loginScreen(context)
            )
        ),
      ),
    );
  }

  Widget loginScreen(BuildContext context){
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
          color: bgColor,
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 48,
                  width: 48,
                ),
                Text("Studyai", style: Get.textTheme.titleLarge,)
              ],
            ),
          ),
        ),
        Positioned(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: secondBgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
              ),
              child: ListView(
                padding: EdgeInsets.only(top: 10),
                children: [
                  Text("${AppLocalizations.of(context).login_to_your_account}".tr, style: Get.textTheme.titleSmall,),
                  SizedBox(height: MediaQuery.of(context).size.height/35,),
                  TextFieldWidget(
                    textController: TextEditingController(text: controller.emailController.text),
                    suffixIcon: Icon(null),
                    suffix: Icon(null),
                    readOnly: false,
                    labelText: AppLocalizations.of(context).email,
                    hintText: AppLocalizations.of(context).enter_email,
                    isFirst: true,
                    onChanged: (value) => {
                      controller.emailController.text = value,
                    },
                    validator: (input) => !input!.contains('@') ? AppLocalizations.of(context).input_email : null,

                  ),
                  Obx(() => TextFieldWidget(
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    labelText: AppLocalizations.of(context).password,
                    hintText: AppLocalizations.of(context).enter_your_password,
                    textController: TextEditingController(text: controller.passwordController.text),
                    obscureText: !controller.hidePassword.value,
                    onChanged: (value) => {
                      controller.passwordController.text = value
                    },
                    validator: (input) => input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null,
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
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.FORGOT_PASSWORD);
                      },
                      child: Text(AppLocalizations.of(context).forgot_password,style:
                      TextStyle(fontFamily: "Inter",fontSize: 14, color: primaryColor, fontWeight: FontWeight.w500)),
                    ),
                  ),

                  if(!(controller.emailController.text != "" &&
                      controller.emailController.text.contains('@') &&
                      controller.passwordController.text !=''&&
                      controller.passwordController.text.length >= 6))...[
                    SizedBox(
                      width: Get.width,
                      child:
                      BlockButtonWidget(
                          color: disableButtonColor,
                          haveBorder: false,
                          text: Text(AppLocalizations.of(context).login, style: Get.textTheme.labelMedium),
                          onPressed: (){
                            controller.login();
                          })).marginOnly(top: 20),
                  ]else...[
                    SizedBox(
                      width: Get.width,
                      child: Obx(() => !controller.loginLoading.value?
                      BlockButtonWidget(
                          color: primaryColor,
                          haveBorder: false,
                          text: Text(AppLocalizations.of(context).login, style: Get.textTheme.labelMedium),
                          onPressed: (){
                            controller.login();
                          }):
                      BlockButtonWidget(
                        color: primaryColor,
                        haveBorder: false,
                        onPressed: () async {

                        },
                        text: const SizedBox(height: 30,
                            child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                      ),),
                    ).marginOnly(top: 20),
                  ],

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).no_account_yet,
                        style: TextStyle(color: Color(0xff666262), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Inter'),
                      ),
                      TextButton(
                          onPressed: (){
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: Text(AppLocalizations.of(context).register, style: (TextStyle(color: primaryColor,fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Inter'))
                          )
                      )
                    ],
                  ).marginOnly(top: 10),

                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1, color: Color(0xffC9C9C9))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context).or.toUpperCase(),
                          style: TextStyle(color: Color(0xffC9C9C9), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1, color: Color(0xffC9C9C9))),
                    ],
                  ).marginOnly(top: 10, bottom: 30),

                  _socialButton(
                    text: "  ${AppLocalizations.of(context).login_with_Apple}     ",
                    onTapped: () {

                    },
                    imagePath: 'assets/images/logos_apple.png',
                  ),

                  SizedBox(height: 10,),

                  _socialButton(
                    text: "  ${AppLocalizations.of(context).login_with_google}    ",
                    onTapped: () {
                      controller.handleGoogleSignIn();
                    },
                    imagePath: 'assets/images/logos_google.png',
                  ),

                  SizedBox(height: 10,),

                  _socialButton(
                    text: "  ${AppLocalizations.of(context).login_with_facebook}",
                    onTapped: () {
                    },
                    imagePath: 'assets/images/logos_facebook.png',
                  ),



                ],
              ),
            ).marginOnly(top: 180)
        )
      ],
    );
  }

  Widget _socialButton({
    required imagePath,
    required String text,
    required VoidCallback onTapped,
  }) {
    return GestureDetector(
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // keeps row compact
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter'
                  ),
                ),
              ],
            ),)


      ),
      onTap: onTapped,
    );
  }
}
