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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Change Password",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instruction text
                    Text(
                      "To change password, enter current and new password",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Enter Current Password
                    Text(
                      "Enter Current Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        obscureText: !controller.hidePassword.value,
                        onChanged: (value) => controller.oldPassword.value = value,
                        validator: (input) => input!.length < 6
                            ? AppLocalizations.of(context).enter_six_characters
                            : null,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                              !controller.hidePassword.value;
                            },
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    )),

                    SizedBox(height: 24),

                    // Enter New Password
                    Text(
                      "Enter New Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        obscureText: !controller.hidePassword.value,
                        onChanged: (value) => controller.newPassword.value = value,
                        validator: (input) => input!.length < 6
                            ? AppLocalizations.of(context).enter_six_characters
                            : null,
                        decoration: InputDecoration(
                          hintText: "Re-enter password",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                              !controller.hidePassword.value;
                            },
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    )),

                    SizedBox(height: 24),

                    // Confirm New Password
                    Text(
                      "Confirm New Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        obscureText: !controller.hidePassword.value,
                        onChanged: (value) => controller.confirmPassword.value = value,
                        validator: (input) => input != controller.newPassword.value
                            ? AppLocalizations.of(context).confirm_enter_new_password
                            : null,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                              !controller.hidePassword.value;
                            },
                            icon: Icon(
                              controller.hidePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    )),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            bool isFormEmpty = controller.oldPassword.value.isEmpty ||
                controller.newPassword.value.isEmpty ||
                controller.confirmPassword.value.isEmpty;

            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isFormEmpty || controller.onResetPassword.value)
                    ? null
                    : () {
                  if (formKey.currentState!.validate()) {
                    controller.updatePassword();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormEmpty ? Colors.grey.shade300 : Colors.blue,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: controller.onResetPassword.value
                    ? SpinKitThreeBounce(color: Colors.white, size: 20)
                    : Text(
                  "Save",
                  style: TextStyle(
                    color: isFormEmpty ? Colors.grey.shade500 : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}