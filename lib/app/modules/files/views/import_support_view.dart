import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/file_card_model.dart';
import 'package:studyai/app/modules/files/controllers/files_controller.dart';
import 'package:studyai/app/modules/global_widgets/add_instruction_widget.dart';
import '../../../../color_constants.dart';
import '../../global_widgets/block_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class ImportSupportView extends GetView<FilesController> {
  const ImportSupportView({
    super.key});

  @override
  Widget build(BuildContext context) {
    if(Get.arguments!= null){
       controller.importedFile = Get.arguments;
    }
    return  Scaffold(
        backgroundColor: controller.courseGenerationState[3] == controller.generationState.value?
        courseColor
        :bgColor,

        body: Obx(() => controller.courseGenerationState[0] == controller.generationState.value || controller.courseGenerationState[2] == controller.generationState.value?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).import_support, style: TextStyle( fontSize: 24),).marginOnly(left: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                ) ,

                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xffF3F1D3)
                      ),
                      child: controller.importedFile.path.contains('.pdf')?
                          Container(child: Center(child: Text(controller.importedFile.path, textAlign: TextAlign.center, ),),):
                      Image.file(
                        fit: BoxFit.cover,
                          File(controller.importedFile.path)),
                    ).marginOnly(bottom: 20),



                    AddInstructionWidget(
                      textController: controller.instructionsController,
                      suffixIcon: Image.asset('assets/images/edit.png'),
                      hintText: AppLocalizations.of(context).add_instructions,
                      maxLines: 16,
                    ),

                    SizedBox(
                      width: Get.width,
                      child: BlockButtonWidget(
                          color: primaryColor,
                          haveBorder: false,
                          text: Text(AppLocalizations.of(context).generate, style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                          onPressed: () async {
                            controller.startProgress();

                            showDialog(
                                context: context,
                                builder: (context) => Obx(() => Dialog(
                                  backgroundColor: controller.courseGenerationState[1] == controller.generationState.value?Colors.transparent:bgColor,
                                  alignment: Alignment.center,
                                  shape: Border.symmetric(horizontal: BorderSide.none, vertical: BorderSide.none),
                                  insetPadding: EdgeInsets.zero,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: Get.height/3,),
                                        SizedBox(
                                          child: CircularProgressIndicator(
                                            color: Color(0xff9CBBF7),
                                            strokeWidth: 8,

                                          ),
                                          height: Get.height/6,
                                          width: Get.height/6,
                                        ).marginOnly(bottom: 40),
                                        Text(AppLocalizations.of(context).ongoing_generation),
                                        Spacer(),
                                        Obx(() => controller.courseGenerationState[1] == controller.generationState.value?
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
                                            ),
                                            height: Get.height*0.2,
                                            padding: EdgeInsets.all(Get.width/6),
                                            child: Center(
                                              child: Text(AppLocalizations.of(context).ongoing_generation_message ,
                                                textAlign: TextAlign.center,
                                              ),)):SizedBox(),)
                                      ],
                                    ),
                                  ),
                                ),));


                          }),
                    ).marginOnly(top: 20),
                  ],
                ),
              ),
            ),
          ],
        ):
        Container(
          color: courseColor,
          child: Column(
          children: [ Row(
            children: [
              IconButton(onPressed: () async {
                Navigator.of(context).pop();

              }, icon: Icon(Icons.arrow_back_ios)),
              SizedBox(
                width: Get.width*0.85,
                  child: Text(controller.generatedCourse.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff1A3C7D)),)),
            ],
          ),

            Text("${controller.generatedCourse.courseData.length} modules- ${controller.generatedCourse.timeInfo} - niveau ${controller.generatedCourse.subtitle}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),).marginOnly(left: 10, top: 10, bottom: 10),


            LinearProgressIndicator(
              color: Color(0xff1A3C7D),
              value: 10,
            ).marginSymmetric(horizontal: 16,),
            TabViewCourse(context, controller.generatedCourse)
          ],
        ),)
        ).marginOnly(top: 50)

    );

  }

  Widget TabViewCourse(BuildContext context, FileCardModel fileCardModel) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Expanded(

        child: Scaffold(
          backgroundColor: courseColor,
          appBar: AppBar(
              leadingWidth: 0,
              centerTitle: true,
              backgroundColor: courseColor,
              leading: Icon(null),
              toolbarHeight: 50,
              title: TabBar(
                dividerColor: Colors.transparent,
                labelPadding: EdgeInsets.zero,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                labelColor: Colors.white,
                unselectedLabelColor: Color(0xff4A4A48),
                labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: appColor,

                ),
                onTap: (value) {
                  if(value == 0){
                    controller.introductionSelected.value = false;
                    controller.notationVocabularySelected.value = true;
                    controller.otherSelected.value = true;
                  }
                  if(value == 1){
                    controller.introductionSelected.value = true;
                    controller.notationVocabularySelected.value = false;
                    controller.otherSelected.value = true;
                  }

                },
                splashBorderRadius: BorderRadius.circular(40),
                automaticIndicatorColorAdjustment: true,
                tabs: [
                  Tab( child: Obx(() => Container(
                    decoration: controller.introductionSelected.value?BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xffD9D9D9),

                    ):null,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                    child: Text(AppLocalizations.of(context).introduction,),),),),
                  Tab( child: Obx(() => Container(
                    decoration: controller.notationVocabularySelected.value?BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xffD9D9D9),

                    ):null,
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                    child: Text(AppLocalizations.of(context).notations_and_vocabularies,),),),),

                  // Tab( child: Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                  //   child: Text('Revisions'),),),
                ]
              )
          ),
          body: TabBarView(
            children: [
              IntroductionPage(context, fileCardModel),
              NotationVocabularyPage(context,fileCardModel)
            ],
          ),
        ),
      ),
    );
  }


  Widget IntroductionPage(BuildContext context, FileCardModel fileCardModel) {
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
                  for(var item in fileCardModel.courseData)...[
                    SliverToBoxAdapter(
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item["topic"],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, ), textAlign: TextAlign.justify,),
                      )
                    ),
                    SliverToBoxAdapter(
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item["body"],
                          style: TextStyle(fontSize: 14), textAlign: TextAlign.justify,),
                      ).marginOnly(bottom: Get.height*0.025),
                    )
                  ]
                ]
              )
          ),
        )
      ],
    );
  }

  Widget NotationVocabularyPage(BuildContext context, FileCardModel fileCardModel) {
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
                  if(fileCardModel.vocabulariesData != null)...[
                    for(var item in fileCardModel.vocabulariesData)...[
                      SliverToBoxAdapter(
                        child:  Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item["term"],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, ), textAlign: TextAlign.justify,),
                        )
                      ),
                      SliverToBoxAdapter(
                        child:  Align(
                          alignment: Alignment.centerLeft,
                          child: Text(item["definition"],
                            style: TextStyle(fontSize: 14, ), textAlign: TextAlign.justify,),
                        ).marginOnly(bottom: Get.height*0.025),
                      )
                    ]
                  ]else...[
                    SliverToBoxAdapter(
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).term,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, ), textAlign: TextAlign.justify,),
                      )
                    ),
                    SliverToBoxAdapter(
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).definition,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, ), textAlign: TextAlign.justify,),
                      ).marginOnly(bottom: Get.height*0.025),
                    )
                  ]
                ]
              )
          ),
        )
      ],
    );
  }

}
