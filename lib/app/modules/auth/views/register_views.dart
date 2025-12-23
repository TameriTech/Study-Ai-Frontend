import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterViews extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.registrationStep.value > 0 && controller.registrationStep.value < 3) {
          controller.previousStep();
          return false;
        }
        return Helper().onWillPop();
      },
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            color: bgColor,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Obx(() => Container(
                  height: MediaQuery.of(context).size.height,
                  padding: !(controller.registrationStep.value == 4)? EdgeInsets.only(top: MediaQuery.of(context).size.height/10):EdgeInsets.zero,
                  color:controller.registrationStep.value == 3? Colors.black12 :!(controller.registrationStep.value == 4)?bgColor:Colors.white,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Obx(() {


                      switch (controller.registrationStep.value) {
                        case 0:
                          return  Text(AppLocalizations.of(context).create_account, style: Get.textTheme.titleMedium,);
                        case 1:
                          return Row(
                            children: [
                              Container(

                                child: IconButton(
                                  onPressed: () => controller.previousStep(),
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.69,
                                child: Text(
                                  AppLocalizations.of(context).select_school_level,
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          );
                        case 2:
                        // Determine the header title based on selected level
                          String headerTitle = controller.selectedSchoolLevel.value == AppLocalizations.of(context).primary_education
                              ? AppLocalizations.of(context).select_class_level
                              : controller.selectedSchoolLevel.value == AppLocalizations.of(context).post_graduate
                              ? AppLocalizations.of(context).school_level
                              : AppLocalizations.of(context).select_class_level;
                          return  Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width/8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  onPressed: () => controller.previousStep(),
                                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12,),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                              SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.69,
                                child: Text(
                                  headerTitle,
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                        case 3:
                          String headerTitle = controller.selectedSchoolLevel.value == AppLocalizations.of(context).primary_education
                              ? AppLocalizations.of(context).select_class_level
                              : controller.selectedSchoolLevel.value == AppLocalizations.of(context).post_graduate
                              ? AppLocalizations.of(context).school_level
                              : AppLocalizations.of(context).select_class_level;
                          return  Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width/8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: IconButton(
                                  onPressed: () => controller.previousStep(),
                                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12,),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                              SizedBox(width: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.69,
                                child: Text(
                                  headerTitle,
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          );
                        case 4:
                          return SizedBox.shrink();
                        default:
                          return Text(AppLocalizations.of(context).create_account, style: Get.textTheme.titleMedium,);
                      }
                    }),


                  ),
                ),),
                Positioned(
                    child: Obx(() => Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color:controller.registrationStep.value == 3? Colors.grey.shade300:secondBgColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                      ),
                      child: Obx(() {
                        switch (controller.registrationStep.value) {
                          case 0:
                            return buildRegistrationForm(context);
                          case 1:
                            return buildSchoolLevelSelection(context);
                          case 2:
                            return buildClassLevelSelection(context);
                          case 3:
                            return buildLoadingScreen(context);
                          case 4:
                            return buildSuccessScreen(context);
                          default:
                            return buildRegistrationForm(context);
                        }
                      }),
                    ).marginOnly(top: 180),)
                )
              ],
            )
        ),
      ),

    );
  }


  // Step 0: Registration Form
  Widget buildRegistrationForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                AppLocalizations.of(context).register_account,
              style: Get.textTheme.headlineSmall
            ).marginOnly(bottom: 30, top: 20),

            TextFieldWidget(
              textController: TextEditingController(text: controller.fullNameController.text),
              onChanged: (value) => controller.fullNameController.text = value,
              validator: (input) => input!.length < 3 ? AppLocalizations.of(context).name_minimum_characters : null,
              suffixIcon: Icon(null),
              labelText: AppLocalizations.of(context).full_name,
              hintText: AppLocalizations.of(context).enter_full_name,
              suffix: Icon(null),
              readOnly: false,
              isFirst: true,
            ),

            // Email
            TextFieldWidget(
              textController: TextEditingController(text: controller.emailController.text),
              onChanged: (value) => controller.emailController.text = value,
              validator: (input) => !input!.contains('@') ? AppLocalizations.of(context).enter_valid_email_address : null,
              suffixIcon: Icon(null),
              labelText: AppLocalizations.of(context).email,
              hintText: AppLocalizations.of(context).enter_your_email,
              suffix: Icon(null),
              readOnly: false,
              isFirst: true,
            ),

            // Create Password
            Obx(() => TextFieldWidget(
              textController: TextEditingController(text: controller.passwordController.text),
              obscureText: !controller.hidePassword.value,
              onChanged: (value) => controller.passwordController.text = value,
              validator: (input) => input!.length < 6 ? AppLocalizations.of(context).password_minimum_characters : null,
              suffixIcon: Icon(null),
              labelText: AppLocalizations.of(context).create_password,
              hintText: AppLocalizations.of(context).create_your_password,
              suffix: Icon(null),
              readOnly: false,
              isFirst: true,
            )),

            Obx(() => TextFieldWidget(
              textController: TextEditingController(text: controller.confirmPasswordController.text),
              obscureText: !controller.hideConfirmPassword.value,
              onChanged: (value) => controller.confirmPasswordController.text = value,
              validator: (input) => input!.length < 6 ? AppLocalizations.of(context).password_minimum_characters : null,
              suffixIcon: Icon(null),
              suffix: Icon(null),
              labelText: AppLocalizations.of(context).confirm_password,
              hintText: AppLocalizations.of(context).confirm_your_password,
              readOnly: false,
              isFirst: true,
            )),
            SizedBox(height: 20),

            // Terms and Conditions
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).by_signing_up,
                  style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontFamily: 'Inter'),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppLocalizations.of(context).terms_conditions,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  ' ${AppLocalizations.of(context).and_our} ',
                  style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontFamily: 'Inter'),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    AppLocalizations.of(context).privacy_policy,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      fontFamily: 'Inter'
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => controller.nextStep(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !(controller.fullNameController.text != "" &&
                      controller.fullNameController.text.length>=3 &&
                      controller.emailController.text != "" &&
                      controller.emailController.text.contains('@') &&
                      controller.passwordController.text !=''&&
                      controller.passwordController.text.length >= 6&&
                      controller.confirmPasswordController.text !=''&&
                      controller.confirmPasswordController.text.length >= 6&&
                      controller.passwordController.text.length == controller.confirmPasswordController.text)?disableButtonColor:primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                    AppLocalizations.of(context).create_account,
                  style: Get.textTheme.labelMedium
                ),
              ),
            ),
            SizedBox(height: 20),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${AppLocalizations.of(context).already_account} ', style: TextStyle(
                    color: Color(0xff666262),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  fontFamily: 'Inter'
                )),
                GestureDetector(
                  onTap: () => Get.offAllNamed(Routes.LOGIN),
                  child: Text(
                    AppLocalizations.of(context).login,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                        fontSize: 14,
                      fontFamily: 'Inter'

                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Color(0xffB3B3B3),)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context).or_continue_with,
                    style: TextStyle(color: Color(0xffB3B3B3), fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'Inter'),
                  ),
                ),
                Expanded(child: Divider(thickness: 1, color: Color(0xffB3B3B3),)),
              ],
            ),
            SizedBox(height: 30),

            // Social Login Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => controller.handleFacebookSignIn(),
                  child: Container(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.facebook, color: Color(0xFF1877F2), size: 32),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => controller.handleGoogleSignIn(),
                  child: Container(
                    width: 56,
                    height: 56,

                    child: Image.asset('assets/images/logos_google.png', width: 32, height: 32),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 56,
                  height: 56,

                  child: Image.asset('assets/images/logos_apple.png', width: 32, height: 32),
                ),
              ],
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


// Step 1: School Level Selection
  Widget buildSchoolLevelSelection(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30,),
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              //padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, height: 1.4),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context).one_two_steps,
                          style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context).next_select_class}',
                          style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context).school_level_question,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Inter'),
                  ),
                  SizedBox(height: 24),

                  // School Level Options with Obx wrapper
                  Obx(() => Column(
                    children: controller.schoolLevels.map((level) {
                      return _buildSchoolLevelOption(
                        icon: level['icon'],
                        title: level['name'],
                        isSelected: controller.selectedSchoolLevel.value == level['name'],
                        onTap: () => controller.selectSchoolLevel(
                          level['name'],
                          level['icon'],
                          List<String>.from(level['classes']),
                        ),
                      );
                    }).toList(),
                  )),
                ],
              ),
            ),
          ),
        ),

        // Next Button
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.selectedSchoolLevel.value.isNotEmpty
                  ? () => controller.nextStep()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.selectedSchoolLevel.value.isNotEmpty
                    ? primaryColor
                    : Color(0xFFD3D3D3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
                disabledBackgroundColor: Color(0xFFD3D3D3),
              ),
              child: Text(
                  AppLocalizations.of(context).next,
                style: Get.textTheme.labelMedium
              ),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSchoolLevelOption({
    required String icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE3F2FD) :  Color(0xffF7F7F7),
          border: Border.all(
            color: isSelected ? Color(0xFF0066FF) : Color(0xffE0E0E0)!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: isSelected ? Color(0xFF0066FF) : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Step 2: Class Level Selection
  Widget buildClassLevelSelection(BuildContext context) {
    return Obx(() {


      // Determine the question based on selected level
      String question = controller.selectedSchoolLevel.value == AppLocalizations.of(context).primary_education
          ? AppLocalizations.of(context).primary_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).high_school_student
          ? AppLocalizations.of(context).high_school_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).senior_high_school
          ? AppLocalizations.of(context).senior_high_school_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).undergraduate
          ? AppLocalizations.of(context).undergraduate_level_question
          : AppLocalizations.of(context).postgraduate_level_question;

      return Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
               // padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, height: 1.4, fontFamily: 'Inter'),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context).two_two_steps,
                            style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                          ),
                          TextSpan(
                            text: ' ${AppLocalizations.of(context).final_step}',
                            style:  TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      question,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Inter'),
                    ),
                    SizedBox(height: 24),

                    // Class Level Options
                    ...controller.availableClassLevels.map((classLevel) {
                      bool isSelected = controller.selectedClassLevel.value == classLevel;
                      return GestureDetector(
                        onTap: () => controller.selectClassLevel(classLevel),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          decoration: BoxDecoration(
                            color: isSelected ? Color(0xFFE3F2FD) : Color(0xffF7F7F7),
                            border: Border.all(
                              color: isSelected ? Color(0xFF0066FF) : Color(0xffE0E0E0)!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                classLevel,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? Color(0xFF0066FF) : Colors.black,
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected ? Color(0xFF0066FF) : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? Color(0xFF0066FF) : Colors.grey[400]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: isSelected
                                    ? Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),

          // Next Button
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.selectedClassLevel.value.isNotEmpty
                    ? () => controller.nextStep()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.selectedClassLevel.value.isNotEmpty
                      ? primaryColor
                      : Color(0xFFD3D3D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Color(0xFFD3D3D3),
                ),
                child: Text(
                  AppLocalizations.of(context).next,
                  style: Get.textTheme.labelMedium,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

// Step 3: Loading Screen
  Widget buildLoadingScreen(BuildContext context) {
    return Obx(() {


      String question = controller.selectedSchoolLevel.value == AppLocalizations.of(context).primary_education
          ? AppLocalizations.of(context).primary_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).high_school_student
          ? AppLocalizations.of(context).high_school_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).senior_high_school
          ? AppLocalizations.of(context).senior_high_school_education_question
          : controller.selectedSchoolLevel.value == AppLocalizations.of(context).undergraduate
          ? AppLocalizations.of(context).undergraduate_level_question
          : AppLocalizations.of(context).postgraduate_level_question;

      return Column(
        children: [

          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, height: 1.4),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context).two_two_steps,
                          style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                        ),
                        TextSpan(
                          text: ' ${AppLocalizations.of(context).final_step}',
                          style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    question,
                    style: Get.textTheme.headlineSmall
                  ),
                  SizedBox(height: 40),

                  // Loading Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).setting_up_profile_message,
                          style: Get.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        Text(
                          AppLocalizations.of(context).setting_profile,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            color: Colors.black

                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CircularProgressIndicator(
                            value: controller.registrationProgress.value,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0056D2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Next Button (Disabled)
          Container(
            color: Colors.grey.shade300,
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: disableButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: disableButtonColor,
                ),
                child: Text(
                    AppLocalizations.of(context).next,
                  style: Get.textTheme.labelMedium
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

// Step 4: Success Screen
  Widget buildSuccessScreen(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(right: 40, left: 40, top: MediaQuery.of(context).size.height*0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFF27AE60),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  '${AppLocalizations.of(context).account_completed_first_part}\n${AppLocalizations.of(context).account_completed_second_part}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.4,
                    fontFamily: 'Inter'
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Continue Button
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                    AppLocalizations.of(context).continu,
                  style: Get.textTheme.labelMedium
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}