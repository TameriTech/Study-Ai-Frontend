import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/file_card_model.dart';
import 'package:studyai/app/modules/files/controllers/files_controller.dart';
import '../../../../color_constants.dart';
import '../../../../l10n/app_localizations.dart';

class ImportSupportView extends GetView<FilesController> {
  const ImportSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // Show loading dialog
        if (controller.generationState.value == controller.courseGenerationState[0] ||
            controller.generationState.value == controller.courseGenerationState[1]) {
          return Container(
            width: Get.width,
            height: Get.height,
            color: Colors.grey[100],
            child: Column(
              children: [
                SizedBox(height: Get.height / 3),
                SizedBox(
                  child: CircularProgressIndicator(
                    color: appColor,
                    strokeWidth: 6,
                  ),
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 40),
                Text(
                  "Ongoing generation....",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Inter'
                  ),
                ),
                Spacer(),
                if (controller.generationState.value == controller.courseGenerationState[1])
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: Get.height * 0.2,
                    padding: EdgeInsets.all(Get.width / 6),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).ongoing_generation_message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        // Show course detail view when generated
        if (controller.generationState.value == controller.courseGenerationState[3]) {
          return CourseDetailView(context, controller.generatedCourse);
        }

        // Default empty state
        return Container();
      }),
    );
  }

  Widget CourseDetailView(BuildContext context, FileCardModel fileCardModel) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          SafeArea(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    controller.generatedCourse.title,
                    style: Get.textTheme.titleMedium,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "level - ${controller.generatedCourse.subtitle}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          color: Color(0xff525866),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Read Time - ${controller.generatedCourse.timeInfo}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                          color: Color(0xff525866),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab View
          Expanded(
            child: TabViewCourse(context, fileCardModel),
          ),
        ],
      ),
    );
  }

  Widget TabViewCourse(BuildContext context, FileCardModel fileCardModel) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.introductionSelected.value = false;
                      controller.notationVocabularySelected.value = true;
                    },
                    child: Obx(() => Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !controller.introductionSelected.value
                            ? Color(0xFF2F80ED)
                            : Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: !controller.introductionSelected.value
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.introductionSelected.value = true;
                      controller.notationVocabularySelected.value = false;
                    },
                    child: Obx(() => Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.introductionSelected.value
                            ? Color(0xFF2F80ED)
                            : Color(0xffE0E0E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Vocabularies",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: controller.introductionSelected.value
                                ? Colors.white
                                : Color(0xff525866),
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.introductionSelected.value
                ? NotationVocabularyPage(context, fileCardModel)
                : IntroductionPage(context, fileCardModel)),
          ),
        ],
      ),
    );
  }

  Widget IntroductionPage(BuildContext context, FileCardModel fileCardModel) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          SizedBox(height: 16),
          for (var item in fileCardModel.courseData) ...[
            if (item["topic"] != null && item["topic"].toString().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  item["topic"],
                  style: Get.textTheme.headlineSmall
                ),
              ),
            if (item["body"] != null && item["body"].toString().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  item["body"],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.6,
                    fontFamily: 'Inter'
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget NotationVocabularyPage(
      BuildContext context, FileCardModel fileCardModel) {
    return Container(
      color: Colors.white,
      child: fileCardModel.vocabulariesData != null &&
          fileCardModel.vocabulariesData!.isNotEmpty
          ? ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          for (var item in fileCardModel.vocabulariesData!) ...[
            if (item["term"] != null &&
                item["term"].toString().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  item["term"],
                  style: Get.textTheme.headlineSmall
                ),
              ),
            if (item["definition"] != null &&
                item["definition"].toString().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  item["definition"],
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.6,
                      fontFamily: 'Inter'
                  ),
                ),
              ),
          ],
        ],
      )
          : Center(
        child: Text(
          "No vocabularies available",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}