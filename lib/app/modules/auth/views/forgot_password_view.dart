import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Get.back(),
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
                    AppLocalizations.of(context).enter_email,
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
                      AppLocalizations.of(context).enter_email_message,
                      style: TextStyle(
                        color: Color(0xff2A2A2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter'
                      ),
                    ),
                    SizedBox(height: 32),

                    TextFieldWidget(
                      textController: TextEditingController(text: controller.emailController.text),
                      onChanged: (value){
                        controller.currentUser.value.email = value;
                        controller.emailController.text = value;
                      },
                      validator: (input) => !input!.contains('@') ? AppLocalizations.of(context).enter_valid_email_address : null,
                      suffixIcon: Icon(null),
                      labelText: AppLocalizations.of(context).email,
                      hintText: AppLocalizations.of(context).enter_email,
                      suffix: Icon(null),
                      readOnly: false,
                      isFirst: true,
                    ),

                  ],
                ),
              ),
            ),

            // Continue button at bottom
            Padding(
              padding: EdgeInsets.all(20),
              child: Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.emailController.text.isEmpty
                      ? null
                      : () async {
                    if (controller.emailController.text.isNotEmpty) {
                      controller.recoverLoading.value = true;
                      await controller.resetPassword(controller.emailController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.emailController.text.isNotEmpty
                        ? primaryColor
                        : Color(0xff9C9C9C),
                    disabledBackgroundColor: disableButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: controller.recoverLoading.value
                      ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    AppLocalizations.of(context).continu,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ),

          ],
        ),
      ),
    );
  }
}