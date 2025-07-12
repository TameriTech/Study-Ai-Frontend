import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../files/controllers/files_controller.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/color_constants.dart';

class QuizzPostGenerationView extends GetView<FilesController> {
  const QuizzPostGenerationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: quizzColor,
      appBar: AppBar(
        backgroundColor: quizzColor,
        leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back_ios)
        ),
        title: Text(controller.questions[0].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Obx(() => Text(
                '${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),)
          ),
        ],
      ),
      body:Obx(() {
        return  _buildQuizInterface(context);
      }),

    );
  }

  Widget _buildQuizInterface( BuildContext context) {
    return Container(
      //padding: const EdgeInsets.only(top: 100, bottom: 50),
        height: Get.height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: backgroundColor,
            border: Border.all(color: backgroundColor)),
      child: SingleChildScrollView(
        child: Obx(() => _buildQuestionAndAnswerCard(context)),
      )
    );
  }

  Widget _buildQuestionAndAnswerCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${controller.currentQuestionIndex.value+1}: ${controller.questions[controller.currentQuestionIndex.value].title}",
          style: const TextStyle(
              color: Color(0xff174523),
              fontWeight: FontWeight.w900,
              fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          controller.questions[controller.currentQuestionIndex.value].text,
          style: const TextStyle(
              color: Color(0xff174523),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for(int index = 0; index<controller.questions[controller.currentQuestionIndex.value].options.length; index++)...[
              Obx(() => Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: controller.selectedAnswers.isEmpty?null:
                  controller.selectedAnswers[controller.currentQuestionIndex.value] == controller.questions[controller.currentQuestionIndex.value].options[index]?controller.selectedAnswers[controller.currentQuestionIndex.value]==controller.correctAnswers[controller.currentQuestionIndex.value]
                      ? null : Border.all(color: Colors.red) : null,
                  color: controller.correctAnswers.isEmpty?Colors.white
                      :controller.correctAnswers[controller.currentQuestionIndex.value] == controller.questions[controller.currentQuestionIndex.value].options[index]?
                  quizzColor:Colors.white,
                ),
                child: Text(
                  controller.questions[controller.currentQuestionIndex.value].options[index],
                  style: const TextStyle(color: Colors.black),
                ),
              ))
            ]
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: BlockButtonWidget(
                color: controller.currentQuestionIndex.value > 0
                    ? primaryColor
                    : Colors.grey,
                haveBorder: false,
                text: const Text('Précédent', style: TextStyle(color: Colors.white, fontSize: 14)),
                onPressed: controller.currentQuestionIndex.value > 0
                    ? controller.previousQuizzQuestion
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BlockButtonWidget(
                color: primaryColor,
                haveBorder: false,
                text: Text(
                    controller.currentQuestionIndex.value < controller.questions.length - 1
                        ? 'Suivant'
                        : 'Terminer',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                onPressed: () {
                  if (controller.currentQuestionIndex.value < controller.questions.length - 1) {
                    controller.nextQuizzQuestion();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}






