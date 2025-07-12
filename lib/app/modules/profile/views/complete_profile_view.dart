import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/profile/controllers/profile_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';

class CompleteProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: InkWell(
            onTap: (){
              if(controller.isBestSubjectsForm.value){
                Navigator.pop(context);
              }else{
                controller.isBestSubjectsForm.value = !controller.isBestSubjectsForm.value;
              }
            },
            child: Image.asset(
              'assets/images/arrow-left-circle 2.png',
              width: 30,
            )
          ),
          title: Obx(() => controller.isBestSubjectsForm.value
              ? Text(
            'Matières préférées',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ) : Text(
            "Objectifs d’Apprentissage ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ))
        ),
        body: SafeArea(
          child: Form(
            child: Obx(() => controller.isBestSubjectsForm.value
                ? bestSubjects(context) : learningObjectives(context)),
          )
        )
      )
    );
  }

  bestSubjects(BuildContext context){
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      children: [
        SizedBox(
          height: 450, // fixed height
          child: GridView.builder(
            itemCount: controller.subjects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3.0, // increased for wider buttons
            ),
            itemBuilder: (context, index) {
              return Obx((){
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: controller.edit.value ?
                    controller.selected.value == controller.subjects[index]  && controller.currentUser.value.bestSubjects.toString() == controller.selected.value ?
                    primaryColor : Colors.transparent :
                    controller.selected.value == controller.subjects[index] && controller.hasSelected.value ?
                    primaryColor : Colors.transparent,
                    side: BorderSide(
                        color: Colors.black
                    ),
                  ),
                  onPressed: () {
                    controller.hasSelected.value =  true;
                    controller.newSelected = controller.selected.value;
                    controller.selected.value = controller.subjects[index];
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      controller.subjects[index],
                      style: controller.edit.value ?
                      TextStyle(
                          color: controller.selected.value == controller.subjects[index]
                              && controller.currentUser.value.bestSubjects.toString() == controller.selected.value?
                          Colors.white : Colors.black, fontSize: 12)
                      : TextStyle(
                          color: controller.selected.value == controller.subjects[index] && controller.hasSelected.value ?
                          Colors.white : Colors.black, fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              });
            },
          ),
        ),
        SizedBox(height: 10),
        // Bouton "Autres"
        TextFieldWidget(
          suffixIcon: Icon(null),
          suffix: Icon(null),
          readOnly: false,
          labelText: 'Autre',
          hintText: 'Entre une autre matiere',
          isFirst: true,
          onChanged: (value) => {
          controller.hasSelected.value =  true,
          controller.newSelected = controller.selected.value,
          controller.selected.value = value,
          },
          //validator: (input) => !input!.contains('@') ? 'Input an email' : null,

        ),
        SizedBox(height: 10),
        SizedBox(
          width: Get.width,
          child: BlockButtonWidget(
              color: controller.hasSelected.value ? primaryColor : primaryColor.withOpacity(0.5),
              haveBorder: false,
              text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              onPressed: (){
                if(controller.hasSelected.value){
                  controller.isBestSubjectsForm.value = !controller.isBestSubjectsForm.value;
                }
              }),
        )
      ],
    );
  }

  learningObjectives(BuildContext context){
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      children: [

        for(var level in controller.learningObjectives)...[
          InkWell(
            onTap: (){
              controller.selectedObj.value = level;
              controller.newObjSelected = controller.selectedObj.value;
              controller.hasSelectedObj.value = true;
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              height: 73,
              width: Get.width,
              decoration: controller.edit.value ?
              BoxDecoration(
                color: controller.selectedObj.value == level && controller.hasSelectedObj.value ?
                primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ) : BoxDecoration(
                color: controller.selectedObj.value == level &&
                    controller.hasSelectedObj.value  ?
                primaryColor : Colors.white,
              ),
              child: Text(level, style: Get.textTheme.labelSmall!
                  .merge(TextStyle(fontWeight: FontWeight.w400, color: controller.selectedObj.value == level && controller.hasSelectedObj.value ?
              Colors.white : Colors.black))
              ),
            ).marginOnly(bottom: 20),
          ),
        ],

        SizedBox(
          width: Get.width,
          child: controller.selectedObj.value == controller.newObjSelected ?
          BlockButtonWidget(
              color: controller.hasSelectedObj.value ?
              primaryColor : primaryColor.withOpacity(0.5),
              haveBorder: false,
              text: controller.isLoading.value ?
              SpinKitThreeBounce(color: Colors.white, size: 20) :
              Text('Soumetre', style: Get.textTheme.labelSmall!
                  .merge(TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w600))),
              onPressed: ()async{

                controller.newSelected = controller.selected.value;
                controller.newObjSelected = controller.selectedObj.value;
                await controller.updateProfile();
                Navigator.pop(context);

              }) :
          BlockButtonWidget(
              color: Colors.black.withOpacity(0.5),
              haveBorder: false,
              text: controller.isLoading.value ?
              SpinKitThreeBounce(color: Colors.white, size: 20) :
              Text('Soumetre', style: Get.textTheme.labelSmall!
                  .merge(TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w600))),
              onPressed: (){ }
          )
        )
      ],
    );
  }

}


