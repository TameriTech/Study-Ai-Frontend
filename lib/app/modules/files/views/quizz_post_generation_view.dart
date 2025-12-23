import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../files/controllers/files_controller.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/color_constants.dart';

class QuizzPostGenerationView extends GetView<FilesController> {
  const QuizzPostGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            controller.currentQuestionIndex.value = 0;
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Obx(() => Text(
          '${AppLocalizations.of(context).quizz_review} ${controller.currentQuestionIndex.value + 1} ${AppLocalizations.of(context).of_preposition} ${controller.questions.length}',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter'
          ),
        )),
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => LinearProgressIndicator(
              value: (controller.currentQuestionIndex.value + 1) / controller.questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              minHeight: 4,
            )),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Obx(() => _buildQuestionReviewCard(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionReviewCard(BuildContext context) {
    final currentQuestion = controller.questions[controller.currentQuestionIndex.value];
    final correctAnswer = controller.correctAnswers.isNotEmpty
        ? controller.correctAnswers[controller.currentQuestionIndex.value]
        : null;
    final userAnswer = controller.selectedAnswers.isNotEmpty
        ? controller.selectedAnswers[controller.currentQuestionIndex.value]
        : null;

    print('Current Question Index: ${controller.currentQuestionIndex.value}');
    print('Correct Answer: $correctAnswer');
    print('User Answer: $userAnswer');
    print('Options: ${currentQuestion.options}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 40),

        // Question Text
        Text(
          currentQuestion.text,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.4,
              fontFamily: 'Inter'
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 60),

        // Options List with Answer Feedback
        Column(
          children: List.generate(
            currentQuestion.options.length,
                (index) => _buildReviewOptionItem(
              context,
              currentQuestion.options[index],
              isCorrectAnswer: correctAnswer != null && currentQuestion.options[index] == correctAnswer,
              isUserAnswer: userAnswer != null && currentQuestion.options[index] == userAnswer,
            ),
          ),
        ),

        SizedBox(height: 40),

        // Navigation Buttons
        _buildNavigationButtons(context),

        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildReviewOptionItem(
      BuildContext context,
      String option,
      {required bool isCorrectAnswer,
        required bool isUserAnswer}
      ) {
    Color backgroundColor;
    Color borderColor;
    bool showBorder = false;

    if (isCorrectAnswer) {
      // Correct answer - green background
      backgroundColor = Color(0xFFD1FAE5);
      borderColor = Color(0xFF10B981);
    } else if (isUserAnswer) {
      // User's wrong answer - red background with red border
      backgroundColor = Color(0xFFFFE5E5);
      borderColor = Colors.red;
      showBorder = true;
    } else {
      // Other options - neutral
      backgroundColor = Color(0xFFF5F5F5);
      borderColor = Colors.transparent;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showBorder ? borderColor : (isCorrectAnswer ? borderColor : Colors.transparent),
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
                fontWeight: isCorrectAnswer || isUserAnswer ? FontWeight.w600 : FontWeight.normal,
                color: Colors.black,
                  fontFamily: 'Inter'
              ),
            ),
          ),
          SizedBox(width: 16),
          // Radio button indicator
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCorrectAnswer
                    ? Color(0xFF10B981)
                    : (isUserAnswer ? Colors.red : Colors.grey[400]!),
                width: 2,
              ),
              color: (isCorrectAnswer || isUserAnswer)
                  ? (isCorrectAnswer ? Color(0xFF10B981) : Colors.red)
                  : Colors.transparent,
            ),
            child: (isCorrectAnswer || isUserAnswer)
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
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Obx(() {
      final isFirstQuestion = controller.currentQuestionIndex.value == 0;
      final isLastQuestion = controller.currentQuestionIndex.value >= controller.questions.length - 1;

      if (isFirstQuestion) {
        // Only Next button on first question
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
                Navigator.of(context).pop();
                controller.currentQuestionIndex.value = 0;
              } else {
                controller.nextQuizzQuestion();
              }
            },
            child: Text(
              isLastQuestion ? AppLocalizations.of(context).end : AppLocalizations.of(context).next,
              style: Get.textTheme.labelMedium
            ),
          ),
        );
      }

      // Previous and Next buttons for other questions
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
              onPressed: controller.previousQuizzQuestion,
              child: Text(
                AppLocalizations.of(context).previous,
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
                  Navigator.of(context).pop();
                  controller.currentQuestionIndex.value = 0;
                } else {
                  controller.nextQuizzQuestion();
                }
              },
              child: Text(
                isLastQuestion ? AppLocalizations.of(context).end : AppLocalizations.of(context).next,
                style: Get.textTheme.labelMedium
              ),
            ),
          ),
        ],
      );
    });
  }
}