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
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Text(
                      'Enter Email Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48), // Balance the back button width
                ],
              ),
            ),

            // White content section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the email address you used to register your account',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: TextEditingController(text: controller.emailController.text),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        controller.currentUser.value.email = value;
                        controller.emailController.text = value;
                      },
                      validator: (input) => !GetUtils.isEmail(input ?? '')
                          ? AppLocalizations.of(context).enter_valid_email_address
                          : null,
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
                        ? Color(0xFF0056D2)
                        : Colors.grey[400],
                    disabledBackgroundColor: Colors.grey[400],
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
                    'Continue',
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