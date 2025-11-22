import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/profile/controllers/profile_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';


class CompleteProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child:   Material(
        type: MaterialType.transparency,
        child: Container(
            color: bgColor,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Obx(() => Container(
                  height: MediaQuery.of(context).size.height,
                  padding: !(controller.registrationStep.value == 3)? EdgeInsets.only(top: MediaQuery.of(context).size.height/10):EdgeInsets.zero,
                  color:controller.registrationStep.value == 2? Colors.black12 :!(controller.registrationStep.value == 3)?bgColor:Colors.white,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Obx(() {


                      switch (controller.registrationStep.value) {
                        case 0:
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
                              Text(
                                'Select school Level',
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          );
                        case 1:
                        // Determine the header title based on selected level
                          String headerTitle = controller.selectedSchoolLevel.value == 'Primary Education'
                              ? 'Select Class Level'
                              : controller.selectedSchoolLevel.value == 'Postgraduate'
                              ? 'Academic Level'
                              : 'Select Class Level';
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
                              Text(
                                headerTitle,
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                          );
                        case 2:
                          String headerTitle = controller.selectedSchoolLevel.value == 'Primary Education'
                              ? 'Select Class Level'
                              : controller.selectedSchoolLevel.value == 'Postgraduate'
                              ? 'Academic Level'
                              : 'Select Class Level';
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
                              Text(
                                headerTitle,
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                          );
                        case 3:
                          return SizedBox.shrink();
                        default:
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
                              Text(
                                'Select school Level',
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          );
                      }
                    }),


                  ),
                ),),
                Positioned(
                    child: Obx(() => Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color:controller.registrationStep.value == 2? Colors.grey.shade300:secondBgColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                      ),
                      child: Obx(() {
                        switch (controller.registrationStep.value) {
                          case 0:
                            return buildSchoolLevelSelection(context);
                          case 1:
                            return buildClassLevelSelection(context);
                          case 2:
                            return buildLoadingScreen(context);
                          case 3:
                            return buildSuccessScreen(context);
                          default:
                            return buildSchoolLevelSelection(context);
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
                          text: '1 of 2 steps',
                          style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                        ),
                        TextSpan(
                          text: ' - Next: Select class.',
                          style: TextStyle(color: Color(0xff9C9C9C), fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'what is your school level?',
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
                  'Next',
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
      String question = controller.selectedSchoolLevel.value == 'Primary Education'
          ? 'what is your primary education level?'
          : controller.selectedSchoolLevel.value == 'High School'
          ? 'what is your high school education level?'
          : controller.selectedSchoolLevel.value == 'Senior High School'
          ? 'what is your senior high school education level?'
          : controller.selectedSchoolLevel.value == 'Undergraduate'
          ? 'what is your undergraduate level?'
          : 'what is your postgraduate level?';

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
                            text: '2 of 2 steps',
                            style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                          ),
                          TextSpan(
                            text: ' - Final step',
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
                  'Next',
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


      String question = controller.selectedSchoolLevel.value == 'Primary Education'
          ? 'what is your primary education level?'
          : controller.selectedSchoolLevel.value == 'High School'
          ? 'what is your high school education level?'
          : controller.selectedSchoolLevel.value == 'Senior High School'
          ? 'what is your senior high school education level?'
          : controller.selectedSchoolLevel.value == 'Undergraduate'
          ? 'what is your undergraduate level?'
          : 'what is your postgraduate level?';

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
                          text: '2 of 2 steps',
                          style: TextStyle(color: Color(0xff121214), fontWeight: FontWeight.normal, fontSize: 14, fontFamily: 'Inter'),
                        ),
                        TextSpan(
                          text: ' - Final step',
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
                          'The details you provide help us deliver a more personalized and relevant experience.',
                          style: Get.textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Setting up your profile',
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
                    'Next',
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
                  'All set! Your account info has\nbeen completed successfully',
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
                 Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                    'Continue',
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


