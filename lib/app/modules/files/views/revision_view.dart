import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/file_card_model.dart';
import 'package:studyai/app/modules/global_widgets/add_instruction_widget.dart';
import '../../../../color_constants.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/files_controller.dart';


class RevisionView extends GetView<FilesController> {
  const RevisionView({
    super.key});

  @override
  Widget build(BuildContext context) {
    var fileInfo;
    if(Get.arguments!= null){
      fileInfo = Get.arguments;
    }
    return  Scaffold(
        backgroundColor: Color(0xffFEFCE5FE),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xffFEFCE5FE),
          ),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () async {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.arrow_back_ios)),
                  SizedBox(
                    width: Get.width*0.74,
                      child: Text(fileInfo.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff1A3C7D)),)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() => Text(
                      '${controller.currentRevisionIndex.value + 1}/${controller.revisions.length}',
                      style: TextStyle(color: Colors.black),
                    ),)
                  )
                ],
              ),
              SizedBox(height: 40,),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.revisions.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: List.generate(3, (i) {
                            int offset = 3 - i;
                            return Positioned(
                              top: 10.0 * offset,
                              child: Stack(
                                children: [
                                  Container(
                                    //constraints: BoxConstraints(
                                      height: MediaQuery.of(context).size.height * 0.7,
                                    //),
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: MediaQuery.of(context).size.height * 0.05,
                                      bottom: 100, // Add bottom padding for scroll view
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Scrollbar(
                                      controller: controller.scrollController,
                                      radius: Radius.circular(8),
                                      thickness: 6,
                                      child: SingleChildScrollView(
                                        controller: controller.scrollController,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: controller.revisions[index]['topic'] + "\n\n",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: controller.revisions[index]['body'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Buttons positioned over the card
                                  Positioned(
                                    bottom: 30,
                                    left: 30,
                                    right: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: controller.previousRevisionCard,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: StadiumBorder(),
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          ),
                                          child: Text("Précédent", style: TextStyle(color: Colors.white, fontSize: 14)),
                                        ),
                                        ElevatedButton(
                                          onPressed: controller.nextRevisionCard,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: StadiumBorder(),
                                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          ),
                                          child: Text("Suivant", style: TextStyle(color: Colors.white, fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }

                ),
              ),

            ],
          ),
        ),

        );


  }
}
