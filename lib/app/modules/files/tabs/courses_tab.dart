import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/color_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../controllers/files_controller.dart';
import '../widgets/file_card.dart';


class CoursesTab extends GetView<FilesController> {
  const CoursesTab({super.key});

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

                  Obx(() => SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: controller.courseList.length,
                    itemBuilder: (context, index) {
                      final file = controller.courseList[index];
                      return GestureDetector(
                        onTap: (){
                          controller.generationState.value = controller.courseGenerationState[3];
                          controller.generatedCourse = file;
                          Get.toNamed(Routes.IMPORT_SUPPORT,);
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
                          textPreview: file.courseData[0]["body"]
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

