import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/permission_service.dart';
import '../../../services/settings_services.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';


class RegisterViews extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
          backgroundColor: bgColor,
          bottomSheet: Container(
            color: bgColor,
              child: actionBottomSheet(context),),
          body: SafeArea(
            child: Form(
              key: controller.registerFormKey,
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                children: [
                  Obx(() => !controller.registerInfoComplete.value?
                  GestureDetector(
                    onTap: (){
                      if(controller.minimumInformationStep1.value && controller.minimumInformationStep2.value )
                      {
                        controller.minimumInformationStep2.value = false;
                      } else if(controller.minimumInformationStep1.value && !controller.minimumInformationStep2.value){
                        controller.minimumInformationStep1.value = false;
                      }
                      else{
                        Navigator.of(context).pop();
                        controller.minimumInformationStep2.value = false;
                      }

                    },
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/arrow-left-circle 2.png',
                          fit: BoxFit.cover,


                        )).marginOnly(top: 10, bottom: 20),
                  ):
                  SizedBox()),

                  Obx(() =>  !controller.registerInfoComplete.value?
                  !controller.minimumInformationStep1.value?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width/6,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10,
                        decoration:  BoxDecoration(
                            color: Color(0xffADAAAA),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration:BoxDecoration(
                            color: Color(0xffADAAAA),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),

                    ],): !controller.minimumInformationStep2.value?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration:  BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration: BoxDecoration(
                            color: Color(0xffADAAAA),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),


                    ],) :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration:BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Container(
                        width: Get.width/6,
                        height: 10.0,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      const SizedBox(width: 20,),



                    ],):
                  SizedBox()).marginOnly(bottom: 20),


                  Obx(() =>  !controller.minimumInformationStep1.value?
                  buildMinimumInformationStep1(context):!controller.minimumInformationStep2.value?
                  buildMinimumInformationStep2(context):!controller.minimumInformationStep3.value?
                  buildMinimumInformationStep3(context):buildMinimumInformationStep4(context),),

                ],
              ),
            ),
          )
      
      ),
    );


  }

  buildMinimumInformationStep1(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 40,),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Ton nom !', style: Get.textTheme.labelLarge,).marginOnly(bottom: 20)),
        TextFieldWidget(
          suffixIcon: Icon(null),
          suffix: Icon(null),
          readOnly: false,
          isFirst: true,
          labelText: '',
          hintText: "John",
          onChanged: (value) => controller.currentUser.value.fullName = value,
          validator: (input) => input!.length < 3 ? 'input at least 3 characters' : null,
        ),
    TextFieldWidget(
    suffixIcon: Icon(null),
    suffix: Icon(null),
    readOnly: false,
    labelText: 'Gmail',
    hintText: 'user@gmail.com',
    isFirst: true,
    onChanged: (value) => {
    controller.currentUser.value.email = value,
    },
    validator: (input) => !input!.contains('@') ? 'Input an email' : null,

    ),
    Obx(() => TextFieldWidget(
    suffix: Icon(null),
    readOnly: false,
    isFirst: true,
    labelText: 'Mot de passe',
    hintText: "••••••••••••••••",
    textController: TextEditingController(text: controller.currentUser.value.password),
    obscureText: !controller.hidePassword.value,
    onChanged: (value) => {
    controller.currentUser.value.password = value
    },
    validator: (input) => input!.length < 6 ? 'input at least 6 characters' : null,
    keyboardType: TextInputType.visiblePassword,
    suffixIcon: IconButton(
    onPressed: () {
    controller.hidePassword.value = !controller.hidePassword.value;
    },
    color: Theme.of(context).focusColor,
    icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
    ),

    ),),


      ],
    );
  }

  buildMinimumInformationStep2(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 40,),
        Text('C’est quoi ton niveau scolaire ?', style: Get.textTheme.labelLarge,).marginOnly(bottom: 20),
        for(var level in controller.schoolLevel)...[
          InkWell(
            onTap: (){
              controller.currentUser.value.academicLevel = level;
              controller.selectedSchoolLevel.value = level;
            },
            child: Obx(() => Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              height: 73,
              width: Get.width,
              decoration: BoxDecoration(
                color: controller.selectedSchoolLevel.value == level?tertiaryColor.withOpacity(0.8):Colors.white,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Text(level, style: Get.textTheme.labelSmall!.merge(TextStyle(fontWeight: FontWeight.w400)),),
            ),).marginOnly(bottom: 20),
          ),
        ],

        

      ],

    );
  }

  buildMinimumInformationStep3(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 40,),
        Text('Quelle classe précisément?', style: Get.textTheme.labelLarge,).marginOnly(bottom: 20),
        for(var level in controller.classDegree)...[
          InkWell(
            onTap: (){
              controller.currentUser.value.classLevel = level;
              controller.selectedClassLevel.value = level;
            },
            child: Obx(() => Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              height: 73,
              width: Get.width,
              decoration: BoxDecoration(
                color: controller.selectedClassLevel.value == level?tertiaryColor.withOpacity(0.8):Colors.white,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Text(level, style: Get.textTheme.labelSmall!.merge(TextStyle(fontWeight: FontWeight.w400)),),
            ),).marginOnly(bottom: 20),
          )
        ],

        

      ],
    );
  }

  buildMinimumInformationStep4(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 40,),
        Obx(() => !controller.registerInfoHalfSaved.value?
        SizedBox(
          height: 223,
            child: Text("Les informations que nous demandons nous permettent de mieux personnalisé votre expérience sur l’app" , style: Get.textTheme.labelLarge,).marginOnly(bottom: 20)):
        SizedBox(
          height: 223,
            child: Text("C’est presque termine " , style: Get.textTheme.labelLarge,).marginOnly(bottom: 20)),
        ),
        

            SizedBox(
              width: 167,
              height: 7,
              child: LinearProgressIndicator(
                        //value: controller.progress.value, // Current progress
                        color: tertiaryColor,
                        backgroundColor: Color(0xffF3F1D3),
                      ),
            ),

        
        Visibility(
          visible: !controller.registerInfoHalfSaved.value,
            child: Text('Creation du profil scolaire ')).marginOnly(top: Get.height/20)


      ],
    );
  }


  actionBottomSheet(BuildContext context){
    return Obx(() =>  !controller.minimumInformationStep1.value?
    SizedBox(
      width: Get.width,
      child: BlockButtonWidget(
          color: Colors.black,
          haveBorder: false,
          text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          onPressed: (){
    if (controller.registerFormKey.currentState!.validate()) {
      controller.minimumInformationStep1.value = !controller.minimumInformationStep1.value;
    }



          }),
    ):!controller.minimumInformationStep2.value?
    SizedBox(
      width: Get.width,
      child: BlockButtonWidget(
          color: Colors.black,
          haveBorder: false,
          text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          onPressed: (){
            controller.minimumInformationStep2.value = !controller.minimumInformationStep2.value;

          }),
    ):!controller.minimumInformationStep3.value?
    SizedBox(
      width: Get.width,
      child: BlockButtonWidget(
          color: Colors.black,
          haveBorder: false,
          text: Text('Suivant', style: Get.textTheme.labelSmall!.merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
          onPressed: (){
            controller.minimumInformationStep3.value = !controller.minimumInformationStep3.value;
            controller.registerInfoComplete.value = true;
            controller.progress.value = 0.0;
            controller.register();

          }),
    ):SizedBox(),).marginOnly(left: 20, right:20, bottom: 0);
  }




}