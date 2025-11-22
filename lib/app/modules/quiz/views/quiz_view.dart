import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/files/controllers/files_controller.dart';
import 'package:studyai/app/modules/files/widgets/file_card.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import 'package:studyai/app/routes/app_routes.dart';
import 'package:studyai/color_constants.dart';
import 'package:studyai/common/ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Obx(() {
          if (controller.generationState.value == QuizGenerationState.start ||
              controller.generationState.value == QuizGenerationState.failed) {
            return _buildQuizSetup(context);
          } else {
            return _buildQuizInterface(context);
          }
        }),
      ),
    );
  }

  Widget _buildQuizSetup(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quiz', style: Get.textTheme.headlineSmall,),
              GestureDetector(
                onTap: (){},
                child:  Image.asset(
                  'assets/icons/notification_bell.png',
                  fit: BoxFit.cover,
                ),
              )
            ],
          ).marginSymmetric(vertical: 20, horizontal: 20),
          Text(
            'Create personalized quizzes tailored to\nyour needs',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff525866),
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter'
            ),
          ).marginOnly(left: 20, right: 20, top: 20),

          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: Colors.white),
            child: Column(
              children: [

                // Course Selection Card
                GestureDetector(
                  onTap: () {
                    _showCourseSelectionBottomSheet(context);
                  },
                  child: Obx(() => controller.selectedCourse.value.title == ''
                      ? Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFFFFF9E6),
                      border: Border.all(color: Color(0xFFE8DDB5)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.menu_book, size: 48, color: Color(0xFFB8860B)),
                        SizedBox(height: 12),
                        Text(
                          'Cole Palmer - UI/UX Designer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFB8860B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    height: 60,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFFFFF9E6),
                      border: Border.all(color: Color(0xFFE8DDB5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book, size: 32, color: Color(0xFFB8860B)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.selectedCourse.value.title,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),

                SizedBox(height: 20),

                // Instruction Input
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: controller.instructionText,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter detailed instructions',
                      hintStyle:TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          color: Color(0xff0E121B)
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Number of Questions
                _buildSettingCard(
                  context,
                  label: 'Number of questions',
                  child: Obx(() => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircularButton(
                            icon: Icons.remove,
                            onPressed: () {
                              if (controller.numberOfQuestions.value > 1)
                                controller.numberOfQuestions.value--;
                            },
                          ),
                          SizedBox(width: 40),
                          Text(
                            '${controller.numberOfQuestions.value}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 40),
                          _buildCircularButton(
                            icon: Icons.add,
                            onPressed: () {
                              if (controller.numberOfQuestions.value < 50)
                                controller.numberOfQuestions.value++;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Questions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Slider
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Color(0xFF1E40AF),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: Color(0xFF1E40AF),
                          overlayColor: Color(0xFF1E40AF).withOpacity(0.2),
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                        ),
                        child: Slider(
                          value: controller.numberOfQuestions.value.toDouble(),
                          min: 1,
                          max: 50,
                          onChanged: (value) {
                            controller.numberOfQuestions.value = value.toInt();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('25', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('50', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),

                SizedBox(height: 16),

                // Difficulty Level Dropdown
                _buildDropdownCard(
                  context,
                  label: 'Beginner level',
                  items: controller.difficultyLevels,
                  selectedIndex: controller.difficultyIndex,
                ),

                SizedBox(height: 16),

                // Question Type Dropdown
                _buildDropdownCard(
                  context,
                  label: 'Objective format',
                  items: controller.questionTypes,
                  selectedIndex: controller.questionTypeIndex,
                ),

                SizedBox(height: 40),

                // Generate Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (controller.selectedCourse.value.title.isEmpty) {
                        Get.showSnackbar(Ui.warningSnackBar(
                            message: 'Please select a course first'));
                        return;
                      }

                      _showGeneratingDialog(context);

                      controller.startGenerationProgress(
                        idCourse: controller.selectedCourse.value.id!,
                        instruction: controller.instructionText.text,
                        levelOfDifficulty:
                        controller.getLevelOfDifficulty(controller.difficultyIndex.value),
                        questionsNumber: controller.numberOfQuestions.value,
                        quizzType:
                        controller.getQuizzType(controller.questionTypeIndex.value),
                      );
                    },
                    child: Text(
                      'Generate Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingCard(BuildContext context, {required String label, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter'
            ),
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdownCard(BuildContext context,
      {required String label, required RxList<String> items, required RxInt selectedIndex}) {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: items[selectedIndex.value],
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          dropdownColor: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          items: items.asMap().entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedIndex.value = items.indexOf(newValue);
            }
          },
        ),
      ),
    ));
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFFE8F2FF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF1E40AF)),
      ),
    );
  }

  Widget _buildQuizInterface(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
          color: bgColor,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              Obx(() => Text(
                'Question ${controller.currentQuestionIndex.value + 1} of ${controller.questions.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'
                ),
              )),
            ],
          ),
        ),

        // Progress Bar - per question timer
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
          color: bgColor,
          child: Obx(() => LinearProgressIndicator(
            value: controller.questionProgress.value,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            minHeight: 4,
          )),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),

                // Question Text
                Obx(() => Text(
                  controller.questions[controller.currentQuestionIndex.value].text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    fontFamily: 'Inter'
                  ),
                  textAlign: TextAlign.center,
                )),

                SizedBox(height: 60),

                // Options List
                Obx(() => Column(
                  children: List.generate(
                    controller.questions[controller.currentQuestionIndex.value].options.length,
                        (index) => _buildOptionItem(context, index),
                  ),
                )),

                SizedBox(height: 40),

                // Bottom Navigation
                Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.1),
                  child: _buildNavigationButtons(context),
                ),
              ],
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildOptionItem(BuildContext context, int index) {
    return Obx(() {
      final isSelected = controller.selectedAnswer.value == index;
      final option = controller.questions[controller.currentQuestionIndex.value].options[index];

      return GestureDetector(
        onTap: () {
          controller.extractUserAnswer(index);
          controller.selectAnswer(
            index,
            controller.questions[controller.currentQuestionIndex.value].questionId,
            controller.userAnswer,
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFD1FAE5) : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Color(0xFF10B981) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontFamily: 'Inter'
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Color(0xFF10B981) : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isSelected ? Color(0xFF10B981) : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Obx(() {
      final isFirstQuestion = controller.currentQuestionIndex.value == 0;
      final isLastQuestion = controller.currentQuestionIndex.value >= controller.questions.length - 1;

      if (isFirstQuestion) {
        // Only Next/Submit button on first question
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            onPressed: () {
              if (isLastQuestion) {
                controller.submitQuiz(
                  courseId: controller.questions[controller.questions.length - 1].courseId,
                );
                _showSuccessDialog(context);
              } else {
                controller.nextQuestion();
              }
            },
            child: Text(
              isLastQuestion ? 'Submit' : 'Next',
              style: Get.textTheme.labelMedium
            ),
          ),
        );
      }

      // Previous and Next/Submit buttons for other questions
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                side: BorderSide(color: Colors.grey[300]!),
                backgroundColor: disableButtonColor,
              ),
              onPressed: controller.previousQuestion,
              child: Text(
                'Previous',
                style: Get.textTheme.labelMedium
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              onPressed: () {
                if (isLastQuestion) {
                  controller.submitQuiz(
                    courseId: controller.questions[controller.questions.length - 1].courseId,
                  );
                  _showSuccessDialog(context);
                } else {
                  controller.nextQuestion();
                }
              },
              child: Text(
                isLastQuestion ? 'Submit' : 'Next',
                style: Get.textTheme.labelMedium
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showCourseSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Obx(() {
          final availableCourses = Get.find<FilesController>()
              .courseList
              .where((p0) => p0.hasQuizz == false)
              .toList();

          if (availableCourses.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context).no_course_available),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: availableCourses.length,
            itemBuilder: (context, index) {
              final file = availableCourses[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  controller.selectedCourse.value = file;
                },
                child: FileCard(
                  title: file.title,
                  color: Get.find<FilesController>().getFileCardColor(file.type),
                  timeInfo: file.timeInfo,
                  level: file.level,
                  progress: file.progress,
                  subtitle: file.subtitle,
                  type: file.type,
                  createdAt: file.createdAt,
                  textPreview: file.type == "Course"
                      ? file.courseData[0]["body"]
                      : file.type == "Revision"
                      ? file.revisionData[0]["body"]
                      : file.quizzData[0]["question"],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _showGeneratingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Ongoing generation....',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Inter'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Obx(() {
            if (controller.quizzResultLoading.value) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading results...'),
                  ],
                ),
              );
            }

            if (!controller.gotQuizzResultSuccessfully.value) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).error_occurred,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.submitQuiz(
                          courseId: controller.questions[controller.questions.length - 1].courseId,
                        );
                        _showSuccessDialog(context);
                      },
                      child: Text(AppLocalizations.of(context).try_again),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFA500).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: Color(0xFFFFA500),
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Congratulations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166136),
                      fontFamily: 'Inter'
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your score is ${controller.quizzResultRating.text}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      color: Color(0xff0E121B),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    controller.quizzResultComment.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      color: Color(0xff0E121B),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        controller.viewResponses.value = true;
                        controller.quizzData = await controller.getCourseQuizzes(
                          courseId: controller.quizzData[0]['course_id'],
                        );
                        await Get.find<FilesController>()
                            .extractQuestionsFromQuizzes(controller.quizzData);
                        controller.viewResponses.value = false;
                        Navigator.of(context).pop();
                        Get.find<RootController>().changePageInRoot(0);
                        Get.toNamed(Routes.QUIZZ_POST_GENERATION_VIEW);
                      },
                      child: controller.viewResponses.value
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Review Answers',
                        style: Get.textTheme.labelMedium
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.back();
                    },
                    child: Text(
                      'New Challenge',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}