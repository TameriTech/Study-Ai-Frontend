import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

class ChangeUsernameView extends GetView<ProfileController> {
  const ChangeUsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
        text: controller.currentUser.value.fullName ?? ""
    );

    return Scaffold(
      backgroundColor:Colors.white,
      body: Column(
        children: [
          // Grey header section with back button and title
          Container(
              height: 200,
              color: bgColor,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child:Row(
                children: [
                  Container(

                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 12,),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    margin: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width/8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Change Username',
                    style: Get.textTheme.titleMedium,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              )
          ),

          // White content section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your name correctly below, it will be displaced the same way it is entered',
                    style: TextStyle(
                        color: Color(0xff2A2A2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter'
                    ),
                  ),
                  SizedBox(height: 32),

                  TextFieldWidget(
                    textController: nameController,
                    onChanged: (value){
                      nameController.text= value;
                    },
                    validator: (input) => input!.length < 3 ? 'Name must be at least 3 characters' : null,
                    suffixIcon: Icon(null),
                    labelText: 'Full Name',
                    hintText: "Enter your full name",
                    suffix: Icon(null),
                    readOnly: false,
                    isFirst: true,
                  ),

                ],
              ),
            ),
          ),

          // Continue button at bottom
          Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                onPressed: controller.onResetUserName.value?(){}
                    :(){
                  controller.currentUser.value.fullName = nameController.text;
                  controller.updateProfile().then((_) {
                    Get.back();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:controller.onResetUserName.value?
                SpinKitThreeBounce(color: Colors.white, size: 20)
                    :Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),)
            ),
          ),

        ],
      ),
    );

  }
}