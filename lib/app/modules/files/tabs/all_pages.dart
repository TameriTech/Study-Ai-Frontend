import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/files_controller.dart';
import '../widgets/file_card.dart';


class AllPages extends GetView<FilesController> {
  const AllPages({super.key});

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
                  color: tertiaryColor
              ),
              height: Get.height,
              child: CustomScrollView(
                slivers: [
                  Obx(() => controller.filesLoading.value?
                  SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(

                    )),
                  ):controller.filesList.isEmpty?SliverToBoxAdapter(
                      child: Center(child: Column(

                        children: [
                          Text(AppLocalizations.of(context).no_files)
                        ],)
                      )):
                  Obx(() => SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: controller.filesList.length,

                    itemBuilder: (context, index) {
                      final file = controller.filesList[index];
                      return GestureDetector(
                        onTap: () async {
                          if(file.type == "Course"){
                            controller.generationState.value = controller.courseGenerationState[3];
                            controller.generatedCourse = file;
                            Get.toNamed(Routes.IMPORT_SUPPORT,);
                          }else if (file.type == "Revision"){
                            controller.currentRevisionIndex.value = 0;
                            controller.revisions = file.revisionData;
                            Get.toNamed(Routes.REVISION, arguments: file);
                          }
                          else{
                            controller.currentQuestionIndex.value = 0;
                            await controller.extractQuestionsFromQuizzes(file.quizzData);
                            Get.toNamed(Routes.QUIZZ_POST_GENERATION_VIEW,);
                          }

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
                          textPreview: file.type == "Course"?file.courseData[0]["body"]
                              :file.type == "Revision"?file.revisionData[0]["body"]
                          :file.quizzData[0]["question"],
                        ),
                      );

                    },),),)


                ],

              )

          ),
        )
      ],
    );
  }
}

