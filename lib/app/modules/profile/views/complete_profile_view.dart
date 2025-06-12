import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/profile/controllers/profile_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../global_widgets/block_button_widget.dart';

class CompleteProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Form(
            child: Obx(() => controller.isBestSubjectsForm.value?bestSubjects(context):learningObjectives(context),) ,
          ),
        ),
      ),
    );
  }

  bestSubjects(BuildContext context){
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/arrow-left-circle 2.png',
              fit: BoxFit.cover,
            ).marginOnly(top: 10, bottom: 20),
          ),
        ),
        Text(
          'Matières préférées',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        // Grille des matières
        controller.subjects == null
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
          height: 250, // fixed height
          child: GridView.builder(
            itemCount: controller.subjects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.0, // increased for wider buttons
            ),
            itemBuilder: (context, index) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: StadiumBorder(),
                  side: BorderSide(color: Colors.black),
                ),
                onPressed: () {
                  // action if needed
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    controller.subjects[index],
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        // Bouton "Autres"
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: StadiumBorder(),
              side: BorderSide(color: Colors.black, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            onPressed: () {
              // action Autres
            },
            child: Text(
              'Autres',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20,),
        SizedBox(
          width: Get.width,
          child: BlockButtonWidget(
              color: Colors.black,
              haveBorder: false,
              text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              onPressed: (){
                controller.isBestSubjectsForm.value = !controller.isBestSubjectsForm.value;

              }),
        )

      ],
    );
  }

  learningObjectives(BuildContext context){
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      children: [
        GestureDetector(
          onTap: () {
            controller.isBestSubjectsForm.value = !controller.isBestSubjectsForm.value;
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/arrow-left-circle 2.png',
              fit: BoxFit.cover,
            ).marginOnly(top: 10, bottom: 20),
          ),
        ),
        Text(
          "Objectifs d’Apprentissage ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        // Grille des matières
        for(var level in controller.learningObjectives)...[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              height: 73,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Text(level, style: Get.textTheme.labelSmall!.merge(TextStyle(fontWeight: FontWeight.w400)),),
            ).marginOnly(bottom: 20),
          ),
        ],


        SizedBox(
          width: Get.width,
          child: BlockButtonWidget(
              color: Colors.black,
              haveBorder: false,
              text: Text('Terminer', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              onPressed: (){

              }),
        )
      ],
    );
  }

}


