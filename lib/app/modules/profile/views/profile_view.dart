import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../global_widgets/warning_pupop.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: appColor,
          leading: Icon(null),
          title: Text(AppLocalizations.of(context).my_profile, style: TextStyle(fontSize: 24, color: Colors.white)),
          actions: [
            Obx((){
              return controller.currentUser.value.bestSubjects != "" ?
                InkWell(
                  onTap: (){
                    controller.edit.value = !controller.edit.value;
                    controller.fullName.text = controller.currentUser.value.fullName.toString();
                    controller.email.text = controller.currentUser.value.email.toString();
                    controller.selected.value = controller.currentUser.value.bestSubjects.toString();
                    controller.selectedObj.value = controller.currentUser.value.learningObjectives.toString();
                    controller.hasSelected.value = !controller.hasSelected.value;
                    controller.hasSelectedObj.value = !controller.hasSelectedObj.value;
                    controller.selectedClassLevel.value = controller.currentUser.value.classLevel.toString();
                    controller.selectedSchoolLevel.value = controller.currentUser.value.academicLevel.toString();
                  },
                  child: controller.edit.value ? Icon(Icons.cancel, color: Colors.white)
                      : Image.asset(
                    'assets/images/edit.png',
                    fit: BoxFit.cover,
                  ).marginOnly(right: 16)
              ) : SizedBox.shrink();
            }),
            SizedBox(width: 10)
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              //await controller.refreshCommunity();
              controller.onInit();
            },
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Obx((){
                    if(controller.edit.value){
                      return Container(
                        padding: const EdgeInsets.only(bottom: 60),
                        width: double.infinity,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF14213D),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                        ),
                        child: SizedBox.shrink()
                      );
                    }else{
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        height: Get.height/3.5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF14213D),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/logo.png", width: 200, height: 100),
                            Text("${AppLocalizations.of(context).hey} ${controller.currentUser.value.fullName}",
                              style: TextStyle(fontSize: 24, color: Colors.white),),
                            Text("${AppLocalizations.of(context).school_level} : ${controller.currentUser.value.classLevel}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
                Obx((){
                  return Positioned.fill(
                      top: controller.edit.value ? 0 : Get.height/4.5,
                      left: 0,
                      right: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Container(
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                height: controller.edit.value ? 700 : null,
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Obx((){
                                      if(controller.currentUser.value.bestSubjects == ""){
                                        return Column(
                                          children: [
                                            Text(
                                              "${AppLocalizations.of(context).remember_to_finalize_your}\n${AppLocalizations.of(context).inscription}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.toNamed(Routes.COMPLETE_PROFILE_VIEW);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: primaryColor,
                                                shape: StadiumBorder(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 40,
                                                  vertical: 12,
                                                ),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context).inscription,
                                                style: TextStyle(color: Colors.white, fontSize: 18),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "${AppLocalizations.of(context).more_option_and_more}\n${AppLocalizations.of(context).personalization}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        );
                                      }else{
                                        return controller.edit.value
                                            ? TabViewWidget(context)
                                            : Column(
                                          children: [
                                            ListTile(
                                              trailing: Icon(Icons.question_mark, color: Colors.grey),
                                              title: Text(AppLocalizations.of(context).objectives, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                              subtitle: Text(controller.currentUser.value.bestSubjects.toString(),
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),
                                              ),
                                            ),
                                            ListTile(
                                              trailing: Icon(Icons.check_box_sharp, color: Colors.grey),
                                              title: Text(AppLocalizations.of(context).favorite_courses, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                              subtitle: Text(controller.currentUser.value.learningObjectives.toString(),
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                  ],
                                )
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).my_progress,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  progressionIndicator(context),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(AppLocalizations.of(context).language, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                                onTap: () => Get.toNamed(Routes.SETTINGS_LANGUAGE),
                                subtitle: Text(controller.languageBox.read('language') =='fr'?"Français":"English", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey.shade900)),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(AppLocalizations.of(context).logout, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                    trailing: Icon(Icons.logout, color: Colors.grey),
                                    onTap: () => Get.toNamed(Routes.LOGIN),
                                  ),
                                  ListTile(
                                    title: Text(AppLocalizations.of(context).delete_account, style: TextStyle(fontSize: 16, color: Colors.red)),
                                    trailing: Icon(Icons.delete_forever, color: Colors.red),
                                    onTap: () {
                                      WarningDialog.show(
                                          context: context,
                                          title: AppLocalizations.of(context).attention,
                                          message: AppLocalizations.of(context).delete_account_warning,
                                          confirmText: AppLocalizations.of(context).ok,
                                          onConfirm: () {
                                            controller.deleteAccount();
                                          }
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      )
                  );
                })
              ],
            ),
            ),
          ),
        ),
    );
  }

  TabViewWidget(BuildContext context) {
    return SizedBox(
      height: 600,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.black,
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                onTap: (value) {
                  controller.selectedHomeIndex.value = value;
                },
                tabs: [
                  Tab(text: AppLocalizations.of(context).info),
                  Tab(text: AppLocalizations.of(context).password),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded( // This is crucial!
              child: TabBarView(
                children: [
                  Info(context),
                  Password(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Info(BuildContext context){
    final GlobalKey<FormState> _formKeyInfo = GlobalKey<FormState>();
    var user = controller.currentUser.value;
    return Form(
      key: _formKeyInfo,
      child: Column(
        children: [
          TextFieldWidget(
            suffixIcon: Icon(null),
            suffix: Icon(null),
            textController: controller.fullName,
            readOnly: false,
            isFirst: true,
            labelText: AppLocalizations.of(context).name,
            hintText: "John",
            onChanged: (value) {
              controller.currentUser.value.fullName = value;
              controller.newName = value;
            },
            validator: (input) => input!.length < 3 ? AppLocalizations.of(context).enter_three_characters : null,
          ),
          TextFieldWidget(
            suffixIcon: Icon(null),
            textController: controller.email,
            suffix: Icon(null),
            readOnly: false,
            labelText: AppLocalizations.of(context).email,
            hintText: 'user@gmail.com',
            isFirst: true,
            onChanged: (value) => {
              controller.currentUser.value.email = value,
              controller.newEmail = value
            },
            validator: (input) => !input!.contains('@') ? AppLocalizations.of(context).input_email : null,

          ),
          Container(
              color: bgColor,
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
              width: Get.width,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(var level in controller.classDegree)...[
                        InkWell(
                          onTap: (){
                            controller.currentUser.value.classLevel = level;
                            controller.selectedClassLevel.value = level;
                            controller.newSelected = level;
                          },
                          child: Obx(() => Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: controller.selectedClassLevel.value == controller.currentUser.value.classLevel.toString()
                                    && controller.selectedClassLevel.value == level
                                    ? primaryColor.withOpacity(0.8):Colors.white,
                                borderRadius: BorderRadius.circular(20),

                              ),
                              child: Text(level, style: Get.textTheme.labelSmall!.merge(TextStyle(fontWeight: FontWeight.w400)),),
                          ),),
                        )
                      ],
                    ],
                  )
              )
          ),
          Container(
            color: bgColor,
              height: 70,
              width: Get.width,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for(var level in controller.schoolLevel)...[
                        InkWell(
                          onTap: (){
                            controller.currentUser.value.academicLevel = level;
                            controller.selectedSchoolLevel.value = level;
                            controller.newObjSelected = level;
                          },
                          child: Obx(() => Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: controller.selectedSchoolLevel.value == controller.currentUser.value.academicLevel.toString()
                                  && controller.selectedSchoolLevel.value == level
                                  ? primaryColor.withOpacity(0.8) : Colors.white,
                              borderRadius: BorderRadius.circular(20),

                            ),
                            child: Text(level, style: Get.textTheme.labelSmall!.merge(TextStyle(fontWeight: FontWeight.w400)),),

                          ),),
                        ),
                      ]
                    ],
                  )
              )
          ),

          SizedBox(height: 20),
          TextButton(
              onPressed: (){
                Get.toNamed(Routes.COMPLETE_PROFILE_VIEW);
              },
              child: Text(AppLocalizations.of(context).others, style: Get.textTheme.labelSmall!.
              merge(TextStyle(color: primaryColor, fontWeight: FontWeight.w600))),
          ),
          SizedBox(height: 10),
          BlockButtonWidget(
              color: controller.newName != user.fullName.toString() &&
                  controller.newEmail != user.email.toString() &&
                  controller.newClassLevel != user.classLevel.toString() &&
                  controller.newAcademicLevel != user.academicLevel.toString() ?
              Colors.black : Colors.black.withOpacity(0.5),
              haveBorder: false,
              text: Center(
                child: Text(AppLocalizations.of(context).submit, style: Get.textTheme.labelSmall!.
                merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              ),
              onPressed: (){
                if(controller.newName != user.fullName.toString() &&
                    controller.newEmail != user.email.toString() &&
                    controller.newClassLevel == user.classLevel.toString() &&
                    controller.newAcademicLevel == user.academicLevel.toString()
                ){
                  if(_formKeyInfo.currentState!.validate()){
                    controller.updateProfile();
                  }
                }
              })
        ],
      ),
    );
  }

  Widget Password(BuildContext context){
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Obx(() => TextFieldWidget(
            suffix: Icon(null),
            readOnly: false,
            isFirst: true,
            labelText: AppLocalizations.of(context).old_password,
            hintText: "••••••••••••••••",
            textController: TextEditingController(text: controller.currentUser.value.password),
            obscureText: !controller.hidePassword.value,
            onChanged: (value) => controller.oldPassword.value = value,
            validator: (input) => input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                controller.hidePassword.value = !controller.hidePassword.value;
              },
              color: Theme.of(context).focusColor,
              icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),

          ),
          ),
          Obx(() => TextFieldWidget(
            suffix: Icon(null),
            readOnly: false,
            isFirst: true,
            labelText: AppLocalizations.of(context).enter_new_password,
            hintText: "••••••••••••••••",
            textController: TextEditingController(text: controller.currentUser.value.password),
            obscureText: !controller.hidePassword.value,
            onChanged: (value) => controller.newPassword.value = value,
            validator: (input) => input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                controller.hidePassword.value = !controller.hidePassword.value;
              },
              color: Theme.of(context).focusColor,
              icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),

          ),
          ),
          Obx(() => TextFieldWidget(
            suffix: Icon(null),
            readOnly: false,
            isFirst: true,
            labelText: AppLocalizations.of(context).confirm_password,
            hintText: "••••••••••••••••",
            textController: TextEditingController(text: controller.currentUser.value.password),
            obscureText: !controller.hidePassword.value,
            onChanged: (value) => controller.confirmPassword.value = value,
            validator: (input) => input != controller.newPassword.value ? AppLocalizations.of(context).confirm_enter_new_password : null,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                controller.hidePassword.value = !controller.hidePassword.value;
              },
              color: Theme.of(context).focusColor,
              icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),

          ),
          ),
          SizedBox(height: 20),
          Obx(() {
            return !controller.onResetPassword.value ?
            BlockButtonWidget(
                color: Colors.black,
                haveBorder: false,
                text: Center(
                  child: Text(AppLocalizations.of(context).submit, style: Get.textTheme.labelSmall!.
                  merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    controller.updatePassword();
                  }
                }) :
            BlockButtonWidget(
                color: Colors.black,
                haveBorder: false,
                text: Center(
                  child: SpinKitThreeBounce(color: Colors.white, size: 20)
                ),
                onPressed: (){
                });
          }),
        ],
      ),
    );
  }

  Widget progressionIndicator(BuildContext context){
    var val = double.parse(controller.currentUser.value.statistic.toString()) / 100;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            value: val,
            strokeWidth: 10,
            backgroundColor: bgColor,
            color: (){
              if (val <= 0.30) return Colors.red;
              if (val > 0.31 && val < 0.50) return Colors.orange;
              return Colors.green;
            }()
          )
        ),
        Text( controller.currentUser.value.statistic.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

}


