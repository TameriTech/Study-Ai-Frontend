import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../routes/app_routes.dart';
import '../controllers/files_controller.dart';
import '../widgets/file_card.dart';

class QuizTab extends GetView<FilesController> {
  const QuizTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  color: bgColorFileScreen
              ),
              height: Get.height,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Recents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    ).marginOnly(bottom: Get.height*0.025),
                  ),
                  Obx(() => SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: controller.quizzList.length,
                    itemBuilder: (context, index) {
                      final file = controller.quizzList[index];
                      return GestureDetector(
                        onTap: () async {
                          controller.currentQuestionIndex.value = 0;
                          await controller.extractQuestionsFromQuizzes(file.quizzData);
                          Get.toNamed(Routes.QUIZZ_POST_GENERATION_VIEW,);
                        },
                        child: FileCard(
                          title: file.title,
                          color: controller.getFileCardColor(file.type),
                          timeInfo: file.timeInfo,
                          level: file.level,
                          progress: file.progress,
                          subtitle: file.subtitle,
                          type: file.type,
                          createdAt: file.createdAt,
                        ),
                      );
                    },),)

                ],

              )

          ),
        )
      ],
    );
  }
}

