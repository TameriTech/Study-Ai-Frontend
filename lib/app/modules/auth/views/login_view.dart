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
                Text("Studyai", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
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
                children: [
                  Text("Login to your account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                  TextFieldWidget(
                    textController: TextEditingController(text: controller.emailController.text),
                    suffixIcon: Icon(null),
                    suffix: Icon(null),
                    readOnly: false,
                    labelText: AppLocalizations.of(context).email,
                    hintText: 'Enter your email',
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
                    hintText: "Enter your password",
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
                      TextStyle(fontFamily: "poppins",fontSize: 16, color: buttonColor)),
                    ).marginOnly(bottom: 10),
                  ),

                  if(!(controller.currentUser.value.email!= null &&
                      controller.currentUser.value.email!.contains('@') &&
                      controller.currentUser.value.password!=null&&
                      controller.currentUser.value.password!.length >= 6))...[
                    SizedBox(
                      width: Get.width,
                      child:
                      BlockButtonWidget(
                          color: disableButtonColor,
                          haveBorder: false,
                          text: Text(AppLocalizations.of(context).login, style: Get.textTheme.labelSmall!.
                          merge(TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600))),
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
                          text: Text(AppLocalizations.of(context).login, style: Get.textTheme.labelSmall!.
                          merge(TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w600))),
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
                        style: TextStyle(color: Color(0xff474646), fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                          onPressed: (){
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: Text(AppLocalizations.of(context).register, style: Get.textTheme.bodyMedium!
                              .merge(TextStyle(color: primaryColor,))
                          )
                      )
                    ],
                  ).marginOnly(top: 15),

                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context).or,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ).marginOnly(top: 20, bottom: 30),

                  _socialButton(
                    text: "  Login with Apple     ",
                    onTapped: () {

                    },
                    imagePath: 'assets/images/logos_apple.png',
                  ),

                  SizedBox(height: 10,),

                  _socialButton(
                    text: "  Login with Google    ",
                    onTapped: () {
                      controller.handleGoogleSignIn();
                    },
                    imagePath: 'assets/images/logos_google.png',
                  ),

                  SizedBox(height: 10,),

                  _socialButton(
                    text: "  Login with Facebook",
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
                  ),
                ),
              ],
            ),)


      ),
      onTap: onTapped,
    );
  }
}
