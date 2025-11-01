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
      child:  Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
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
        ),
      ),
    );
  }

  // Step 1: School Level Selection
  Widget buildSchoolLevelSelection(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => controller.previousStep(),
                icon: Icon(Icons.arrow_back, color: Colors.black),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
              SizedBox(width: 16),
              Text(
                'Select school Level',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            color: Color(0xFFF5F5F5),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, height: 1.4),
                      children: [
                        TextSpan(
                          text: '1 of 2 steps',
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: ' - Next: Select class.',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'what is your school level?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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
                    ? Color(0xFF0056D2)
                    : Color(0xFFD3D3D3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
                disabledBackgroundColor: Color(0xFFD3D3D3),
              ),
              child: Text(
                'Next',
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE3F2FD) : Colors.white,
          border: Border.all(
            color: isSelected ? Color(0xFF0066FF) : Colors.grey[300]!,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
      // Determine the header title based on selected level
      String headerTitle = controller.selectedSchoolLevel.value == 'Primary Education'
          ? 'Select Class Level'
          : controller.selectedSchoolLevel.value == 'Postgraduate'
          ? 'Academic Level'
          : 'Select Class Level';

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
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => controller.previousStep(),
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(width: 16),
                Text(
                  headerTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
              child: SingleChildScrollView(
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
                            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: ' - Final step',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      question,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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
                            color: isSelected ? Color(0xFFE3F2FD) : Colors.white,
                            border: Border.all(
                              color: isSelected ? Color(0xFF0066FF) : Colors.grey[300]!,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
                                    width: 2,
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
                      ? Color(0xFF0056D2)
                      : Color(0xFFD3D3D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Color(0xFFD3D3D3),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
      String headerTitle = controller.selectedSchoolLevel.value == 'Primary Education'
          ? 'Select Class Level'
          : controller.selectedSchoolLevel.value == 'Postgraduate'
          ? 'Academic Level'
          : 'Select Class Level';

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
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                SizedBox(width: 40), // Space for back button
                SizedBox(width: 16),
                Text(
                  headerTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Color(0xFFF5F5F5),
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
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: ' - Final step',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    question,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
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
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Setting up your profile',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3D3D3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Color(0xFFD3D3D3),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
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
                      'All set! Your account has\nbeen created successfully',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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
                  backgroundColor: Color(0xFF0056D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}


