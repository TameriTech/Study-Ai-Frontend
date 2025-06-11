import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/files/controllers/files_controller.dart';
import 'package:studyai/app/modules/files/widgets/file_card.dart';
import 'package:studyai/app/modules/global_widgets/add_instruction_widget.dart';
import 'package:studyai/app/modules/quizz/controllers/quizz_controller.dart';
import 'package:studyai/app/modules/quizz/widgets/quizz_setting_item.dart';
import 'package:studyai/app/modules/global_widgets/block_button_widget.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import 'package:studyai/app/routes/app_routes.dart';
import 'package:studyai/color_constants.dart';
import 'package:studyai/common/ui.dart';

class QuizzView extends GetView<QuizzController> {
  const QuizzView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        if (controller.generationState.value == QuizzGenerationState.start || controller.generationState.value == QuizzGenerationState.failed) {
          return _buildQuizSetup(context);
        } else {
          return _buildQuizInterface();
        }
      }),
    );
  }

  Widget _buildQuizSetup(BuildContext context) {
    return  ListView(

      children: [
        Text('Generer un Quizz', style: TextStyle(fontSize: 24),).marginOnly(left: 20, bottom: 10),
        Container(
          height: Get.height,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
          ) ,

          child: ListView(
            children: [
              GestureDetector(
                onTap:(){
                  showModalBottomSheet(context: context,
                    builder: (context) => Container(
                      padding: EdgeInsets.all(20),
                      child:Obx(() => Get.find<FilesController>().courseList.where((p0) => p0.hasQuizz == false).toList().isNotEmpty?
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: Get.find<FilesController>().courseList.where((p0) => p0.hasQuizz == false).toList().length,
                        itemBuilder: (context, index) {
                          final file = Get.find<FilesController>().courseList.where((p0) => p0.hasQuizz == false).toList()[index];
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
                            ),
                          );


                        },
                      )
                        :Center(
                        child: Text("Aucun cours disponible"
                        ),
                      ),)
                      ,

                    ),);
                },
                child: Obx(()=> controller.selectedCourse.value.title == ''?Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  // height: 100,
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xffF3F1D3)
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/document.png'),
                      Text('choisir le cour')
                    ],
                  )
                  ,):SizedBox(
                  width: Get.width,
                  height: 150,
                  child: FileCard(
                    id: controller.selectedCourse.value.id,
                    title: controller.selectedCourse.value.title,
                    color: Get.find<FilesController>().getFileCardColor(controller.selectedCourse.value.type),
                    timeInfo: controller.selectedCourse.value.timeInfo,
                    type: controller.selectedCourse.value.type,
                    level: controller.selectedCourse.value.level,
                    progress: controller.selectedCourse.value.progress,
                    subtitle: controller.selectedCourse.value.subtitle,
                    createdAt: controller.selectedCourse.value.createdAt,
                  ),
                )

                ).marginOnly(bottom: 20),
              ),


              AddInstructionWidget(
                textController: controller.instructionText,
                suffixIcon: Image.asset('assets/images/edit.png'),
                hintText: 'Ajouter des instructions',
                maxLines: 16,
              ).marginOnly(bottom: 20),

              Obx(() =>  QuizzSettingItemWidget(
                value: controller.numberOfQuestions.value.toString(),
                label: "Nombre de questions",
                onDecrease: (){
                  if (controller.numberOfQuestions.value > 0)
                    controller.numberOfQuestions.value--;
                },
                onIncrease: (){
                  controller.numberOfQuestions.value++;
                },
              ),),

              Obx(() =>  QuizzSettingItemWidget(
                value: controller.difficultyLevels[controller.difficultyIndex.value],
                label: "Niveau de difficulte",
                onDecrease: (){
                  if (controller.difficultyIndex.value > 0)
                    controller.difficultyIndex.value--;
                },
                onIncrease: (){
                  if (controller.difficultyIndex.value < controller.difficultyLevels.length - 1)
                    controller.difficultyIndex.value++;
                },
              ),),

              Obx(() =>  QuizzSettingItemWidget(
                value: controller.questionTypes[controller.questionTypeIndex.value],
                label: "Type de question",
                onDecrease: (){
                  if (controller.questionTypeIndex.value > 0)
                    controller.questionTypeIndex.value--;
                },
                onIncrease: (){
                  if (controller.questionTypeIndex.value < controller.questionTypes.length - 1)
                    controller.questionTypeIndex.value++;
                },
              ),),

              SizedBox(
                width: Get.width,
                child: BlockButtonWidget(
                    color: primaryColor,
                    haveBorder: false,
                    text: Text('Generer le quizz', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                    onPressed: (){
                      if(Get.find<FilesController>().courseList.where((p0) => p0.hasQuizz == false).toList().isNotEmpty){
                        controller.startGenerationProgress(
                            idCourse: controller.selectedCourse.value.id!,
                            instruction: controller.instructionText.text,
                            levelOfDifficulty: controller.getLevelOfDifficulty(controller.difficultyIndex.value) ,
                            questionsNumber: controller.numberOfQuestions.value,
                            quizzType: controller.getQuizzType(controller.questionTypeIndex.value));
                        showDialog(context: context,

                            builder: (context) => Obx(() => Dialog(
                              backgroundColor: QuizzGenerationState.ongoing == controller.generationState.value?Colors.transparent:bgColor,
                              alignment: Alignment.center,
                              shape: Border.symmetric(horizontal: BorderSide.none, vertical: BorderSide.none),
                              insetPadding: EdgeInsets.zero,
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height/3,),
                                    SizedBox(
                                      child: CircularProgressIndicator(
                                        color:Color(0xff1B7B38),
                                        strokeWidth: 8,

                                      ),
                                      height: Get.height/6,
                                      width: Get.height/6,
                                    ).marginOnly(bottom: 40),
                                    Text('Generation du quizz en cours...'),
                                    Spacer(),
                                    Obx(() => QuizzGenerationState.failed == controller.generationState.value?
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                                      ),
                                      height: Get.height*0.2,
                                      padding: EdgeInsets.all(Get.width/6),
                                      child: Center(
                                        child: Text('Cette opération peut prendre un certain temps en fonction de votre connexion' ,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),):SizedBox(),)
                                  ],
                                ),
                              ),
                            ),));
                      }
                      else{
                        Get.showSnackbar(Ui.warningSnackBar(message: 'Vous devez avoir un cours disponible pour generer un quizz'));
                      }



                    }),
              ).marginOnly(top: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuizInterface() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 50),
      decoration: const BoxDecoration(color: lightQuizzBackgroundColor),
      child: ListView(
        children: [
          LinearProgressIndicator(
              value: controller.questionProgress.value,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff1B7B38))),
          const SizedBox(height: 20),
          _buildQuestionCard(),
          const SizedBox(height: 40),
          _buildOptionsList(),
          const SizedBox(height: 20),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xff8CD9A0))),
      child: Column(
        children: [
          Text(
            controller.questions[controller.currentQuestionIndex.value].title,
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
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return Container(
      padding: EdgeInsets.all(20),
      //height: Get.height * 0.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(int index = 0; index< controller.questions[controller.currentQuestionIndex.value].options.length; index++)...[
            GestureDetector(
              onTap: () {
                controller.extractUserAnswer(index);
                controller.extractedUserAnswerIndex = index;
                controller.selectAnswer(index, controller.questions[controller.currentQuestionIndex.value].questionId, controller.userAnswer);
              },
              child: Obx(() => Container(
                width: Get.width,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius:controller.selectedAnswers.isEmpty?null: controller.selectedAnswer == index
                      ? BorderRadius.circular(30)
                      : null,
                  color: controller.selectedAnswers.isEmpty?Colors.white:controller.selectedAnswer == index
                      ? quizzColor
                      : Colors.white,
                ),
                child: Text(
                  controller.questions[controller.currentQuestionIndex.value].options[index],
                  style: const TextStyle(color: Colors.black),
                ),
              )),
            ),
          ]
        ],
      )
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: BlockButtonWidget(
            color: controller.currentQuestionIndex.value > 0
                ? primaryColor
                : Colors.grey,
            haveBorder: false,
            text: const Text('Précédent', style: TextStyle(color: Colors.white, fontSize: 14)),
            onPressed: controller.currentQuestionIndex.value > 0
                ? controller.previousQuestion
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
                    : 'Soumettre',
                style: const TextStyle(color: Colors.white, fontSize: 14)),
            onPressed: () {
              if (controller.currentQuestionIndex.value < controller.questions.length - 1) {
                controller.nextQuestion();
              } else {
                controller.submitQuiz(courseId: controller.questions[controller.questions.length-1].courseId);
                showSuccessDialog(Get.context!);
              }
            },
          ),
        ),
      ],
    );
  }


  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFEFF6FF), // Light blue background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Obx(() => controller.quizzResultLoading.value?Center(
            child: CircularProgressIndicator(),
          )
              :controller.gotQuizzResultSuccessfully.value?
            Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, color: Colors.orange, size: 50), // Trophy icon
              const SizedBox(height: 10),
              Text(
                "Félicitations",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${controller.quizzResultRating.text} reussi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.brown[700],
                ),
              ),
              const SizedBox(height: 10),
               Text(
                "${controller.quizzResultComment.text}.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    Get.find<FilesController>().extractQuestionsFromQuizzes(controller.quizzData);
                    Navigator.of(context).pop();
                    Get.find<RootController>().changePageInRoot(0);
                    Get.toNamed(Routes.QUIZZ_POST_GENERATION_VIEW,);
                  },
                  child: const Text(
                    "Voir les responses",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              )
            ],
          )
            :Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "An error occured,",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 8),
             TextButton(onPressed: (){
               Navigator.of(context).pop();
               controller.submitQuiz(courseId: controller.questions[controller.questions.length-1].courseId);
               showSuccessDialog(Get.context!);

             }, child: Text("Try again", style: TextStyle(fontSize: 12, color: Colors.grey),))
            ],
          ),)
        );
      },
    );
  }

}


