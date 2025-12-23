import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordView extends GetView<ProfileController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Column(
        children: [
          // Grey header section with back button and title
          Container(
              height: 200,
              color: bgColor,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child:Row(
                children: [
                  Container(

                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12,),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    margin: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width/8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(width: 16),
                  Text(
                    AppLocalizations.of(context).change_password,
                    style: Get.textTheme.titleMedium,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              )
          ),

          // White content section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).change_password_message,
                    style: TextStyle(
                        color: Color(0xff2A2A2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter'
                    ),
                  ),
                  SizedBox(height: 32),

                  Obx(() => TextFieldWidget(
                    textController: controller.oldPasswordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePassword.value = !controller.hidePassword.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                    labelText: AppLocalizations.of(context).currrent_pwd,
                    hintText: AppLocalizations.of(context).enter_password,
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    obscureText: !controller.hidePassword.value,
                    onChanged: (value){
                      controller.oldPassword.value = value;
                      controller.oldPasswordController.text = value;
                    },
                    validator: (input) => input!.length < 6
                        ? AppLocalizations.of(context).enter_six_characters
                        : null,
                  )),


                  // Enter New Password
                  Obx(() => TextFieldWidget(
                    textController: controller.newPasswordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePassword.value = !controller.hidePassword.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                    labelText: AppLocalizations.of(context).enter_new_password,
                    hintText: AppLocalizations.of(context).enter_password,
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    obscureText: !controller.hidePassword.value,
                    onChanged: (value){
                      controller.newPassword.value = value;
                      controller.newPasswordController.text = value;
                    },
                    validator: (input) => input!.length < 6
                        ? AppLocalizations.of(context).enter_six_characters
                        : null,
                  )),

                  SizedBox(height: 24),

                  // Confirm New Password
                  Obx(() => TextFieldWidget(
                    textController: controller.confirmPasswordController,
                    labelText: AppLocalizations.of(context).confirm_new_password,
                    hintText: AppLocalizations.of(context).enter_password,
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                    obscureText: !controller.hidePassword.value,
                    onChanged: (value){
                      controller.confirmPassword.value = value;
                      controller.confirmPasswordController.text = value;
                    },
                    validator: (input) => input != controller.newPassword.value
                        ? AppLocalizations.of(context).confirm_enter_new_password
                        : null,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.hidePassword.value = !controller.hidePassword.value;
                      },
                      color: Theme.of(context).focusColor,
                      icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  )),



                ],
              ),
            ),
          ),

          // Continue button at bottom
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() {
                  bool isFormEmpty = controller.oldPassword.value.isEmpty ||
                      controller.newPassword.value.isEmpty ||
                      controller.confirmPassword.value.isEmpty;
                  return  ElevatedButton(
                    onPressed:(isFormEmpty || controller.onResetPassword.value)
                        ? null
                        : () {
                        controller.updatePassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormEmpty ? disableButtonColor : primaryColor,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:controller.onResetPassword.value
                        ? SpinKitThreeBounce(color: Colors.white, size: 20)
                        : Text(
                      AppLocalizations.of(context).save,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },)

            ),
          ),

        ],
                )
      ),

    );
  }
}