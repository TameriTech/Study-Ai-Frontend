import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/profile_controller.dart';

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
          backgroundColor: Color(0xFF14213D),
          leading: Icon(null),
          title: Text('Mon profile', style: TextStyle(fontSize: 24, color: Colors.white)),
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
                            Text("Hey ${controller.currentUser.value.fullName}",
                              style: TextStyle(fontSize: 24, color: Colors.white),),
                            Text("Etudiant en ${controller.currentUser.value.classLevel}",
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
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                height: controller.edit.value ? 650 : 350,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                              "Pense à finaliser ton\ninscription",
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
                                                backgroundColor: Colors.black,
                                                shape: StadiumBorder(),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 40,
                                                  vertical: 12,
                                                ),
                                              ),
                                              child: Text(
                                                "Inscription",
                                                style: TextStyle(color: Colors.white, fontSize: 18),
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              "Plus d’option et plus de\npersonnalisation",
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
                                              title: Text("Objectifs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                              subtitle: Text(controller.currentUser.value.bestSubjects.toString(),
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),
                                              ),
                                            ),
                                            ListTile(
                                              trailing: Icon(Icons.check_box_sharp, color: Colors.grey),
                                              title: Text("Cours préféré", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                              subtitle: Text(controller.currentUser.value.learningObjectives.toString(),
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                                    SizedBox(height: 30),
                                    ListTile(
                                      title: Text("Se déconnecter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black)),
                                      trailing: Icon(Icons.logout, color: Colors.grey),
                                      onTap: () => Get.toNamed(Routes.LOGIN),
                                    ),
                                    ListTile(
                                      title: Text("Supprimer mon compte", style: TextStyle(fontSize: 16, color: Colors.red)),
                                      trailing: Icon(Icons.delete_forever, color: Colors.red),
                                      onTap: (){},
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "Ma progression",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            progressionIndicator(context),
                            SizedBox(height: 15)
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
            labelText: 'Nom',
            hintText: "John",
            onChanged: (value) {
              controller.currentUser.value.fullName = value;
              controller.newName = value;
            },
            validator: (input) => input!.length < 3 ? 'input at least 3 characters' : null,
          ),
          TextFieldWidget(
            suffixIcon: Icon(null),
            textController: controller.email,
            suffix: Icon(null),
            readOnly: false,
            labelText: 'Gmail',
            hintText: 'user@gmail.com',
            isFirst: true,
            onChanged: (value) => {
              controller.currentUser.value.email = value,
              controller.newEmail = value
            },
            validator: (input) => !input!.contains('@') ? 'Input an email' : null,

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
                                    ? tertiaryColor.withOpacity(0.8):Colors.white,
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
                                  ? tertiaryColor.withOpacity(0.8):Colors.white,
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
              child: Text('Autres...', style: Get.textTheme.labelSmall!.
              merge(TextStyle(color: tertiaryColor, fontWeight: FontWeight.w600))),
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
                child: Text('Soumettre', style: Get.textTheme.labelSmall!.
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
            labelText: 'Ancien mot de passe',
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

          ),
          ),
          Obx(() => TextFieldWidget(
            suffix: Icon(null),
            readOnly: false,
            isFirst: true,
            labelText: 'Nouveau mot de passe',
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

          ),
          ),
          Obx(() => TextFieldWidget(
            suffix: Icon(null),
            readOnly: false,
            isFirst: true,
            labelText: 'Confirmer le mot de passe',
            hintText: "••••••••••••••••",
            textController: TextEditingController(text: controller.currentUser.value.password),
            obscureText: !controller.hidePassword.value,
            onChanged: (value) => {
              controller.currentUser.value.password = value
            },
            validator: (input) => input != controller.newPassword.value ? 'confirm password and new password must be the same' : null,
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
          BlockButtonWidget(
              color: Colors.black,
              haveBorder: false,
              text: Center(
                child: Text('Soumettre', style: Get.textTheme.labelSmall!.
                merge(TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              ),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  controller.updatePassword();
                }
              })
        ],
      ),
    );
  }

  Widget progressionIndicator(BuildContext context){
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            value: double.parse(controller.currentUser.value.statistic.toString()),
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.orange,
          ),
        ),
        Text( controller.currentUser.value.statistic.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  TabViewWidget(BuildContext context) {
    return DefaultTabController(
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
                Tab(text: 'Info'),
                Tab(text: 'Mot de passe'),
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
    );
  }
}


