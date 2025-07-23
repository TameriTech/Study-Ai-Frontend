import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
            height: Get.height,
            child: Stack(
              children: [

                Image.asset(
                  'assets/images/login_image.png',
                  width: Get.width,
                  fit: BoxFit.fitWidth,
                  height: 300,
                ),
                Positioned(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                            labelText: AppLocalizations.of(context).email,
                            hintText: "johndoe@gmail.com",
                            isFirst: true,
                            onChanged: (value) => {
                              controller.currentUser.value.email = value,
                              controller.email.value = value
                            },
                            validator: (input) => !GetUtils.isEmail(input!) ? AppLocalizations.of(context).enter_valid_email_address.tr : null,

                          ),
                          Obx(() => BlockButtonWidget(
                            onPressed: ()async=> {
                              if(controller.email.value.isNotEmpty){
                                controller.recoverLoading.value = true,
                                await controller.resetPassword(controller.email.value),
                              }

                            },
                            text: !controller.recoverLoading.value? Text(
                                AppLocalizations.of(context).submit, style: Get.textTheme.labelSmall!.
                            merge(TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w600)
                            )
                            ): SizedBox(
                                height: 30,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                            color: controller.email.value.isNotEmpty ?
                            primaryColor : primaryColor.withOpacity(0.5),
                            haveBorder: false,
                          ).paddingSymmetric(vertical: 35, horizontal: 20)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context).no_account_yet.tr, style: TextStyle(color: Colors.black)),
                              TextButton(
                                onPressed: () {
                                  Get.offAllNamed(Routes.REGISTER);
                                },
                                child: Text(AppLocalizations.of(context).register.tr,
                                    style: Get.textTheme.bodyMedium!
                                        .merge(TextStyle(color: primaryColor, decoration: TextDecoration.underline))
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context).remember_password.tr, style: TextStyle(color: Colors.black)),
                              TextButton(
                                onPressed: () {
                                  Get.offAllNamed(Routes.LOGIN);
                                },
                                child: Text(AppLocalizations.of(context).login.tr,
                                    style: Get.textTheme.bodyMedium!
                                        .merge(TextStyle(color: primaryColor, decoration: TextDecoration.underline))
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ).marginOnly(top: 250)
                )
              ]
            )
        ),
      ),
    );
  }
}
