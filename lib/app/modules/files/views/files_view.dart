import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyai/app/modules/files/tabs/all_pages.dart';
import 'package:studyai/app/modules/files/tabs/quiz_tab.dart';
import 'package:studyai/app/modules/global_widgets/search_text_field_widget.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../../../services/image_picker_service.dart';
import '../controllers/files_controller.dart';
import '../tabs/courses_tab.dart';
import '../tabs/revision_tab.dart';


class FilesView extends GetView<FilesController> {
  const FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: bgColor,
          leading: Icon(null),
          title: Text("Mes Fichiers", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
          actions: [
            Image.asset(
              'assets/images/settings.png',
              fit: BoxFit.cover,
            ).marginOnly(right: 16)
          ],
        ),
        floatingActionButton: SizedBox(
          height: 53,
          width: 53,
          child: FloatingActionButton(
              backgroundColor: Colors.black,
              shape: CircleBorder(),
              child: Obx(() => controller.selectedHomeIndex.value == 2?
              Icon(Icons.electric_bolt_outlined, color: Colors.white, )
                :Icon(Icons.add, color: Colors.white, ),),
              onPressed: (){
                if(controller.selectedHomeIndex.value == 2){
                controller.selectedHomeIndex.value = 0;
                  Get.find<RootController>().changePageInRoot(1);

                }else{
                  controller.generationState.value = controller.courseGenerationState[0];
                  showModalBottomSheet(
                    context: context,
                    //useRootNavigator: false,
                    builder: (context) =>  showButtomSheet(context),
                  );
                }
              }),
        ).marginOnly(bottom: 80, right: 10),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              //await controller.refreshCommunity();
              controller.onInit();
            },
            child:  Container(
              color: backgroundColor,
              height: Get.height,
              child: Column(
                children: [
                  SearchTextFieldWidget(
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffADAAAA)),
                    hintText: "Rechercher un cour, quiz...",
                    errorText: '',
                      suffixIcon: Icon(null),
                      suffix: Icon(null),
                      readOnly: false,
                    onChanged: (value){
                      //if(value.length>=3){
                        controller.searchBasedOnName(value);
                     // }

                    },
                  )
                      .marginSymmetric(horizontal: 16),
                  TabViewWidget(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  TabViewWidget(BuildContext context) {
      return DefaultTabController(
        length: 4, // Number of tabs
        child: Expanded(

          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(

                leadingWidth: 0,
                centerTitle: true,
                backgroundColor: backgroundColor,
                leading: Icon(null),
                toolbarHeight: 30,


                title: TabBar(
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  labelColor: Colors.black,
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Color(0xff4A4A48),
                  labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xffD9D9D9),

                  ),
                  splashBorderRadius: BorderRadius.circular(40),
                  automaticIndicatorColorAdjustment: true,
                  onTap: (value) {
                    controller.selectedHomeIndex.value = value;
                  },
                  tabs: [
                    Tab( child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Text('Tous',),),),
                    Tab( child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Text('Cours'),),),
                    Tab( child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Text('Quizz'),),),
                    Tab( child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Text('Revisions'),),),
                  ],
                )
            ),
            body: TabBarView(
              children: [
                AllPages(),
                CoursesTab(),
                QuizTab(),
                RevisionTab()
              ],
            ),
          ),
        ),
      );
    }

  Widget showButtomSheet(BuildContext context){
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      height: 338,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              final ImagePickerService imagePickerService = ImagePickerService();
              var picture = await imagePickerService.pickFromCamera();
              if (picture != null) {
                var file = XFile(picture.path);
                Get.toNamed(Routes.IMPORT_SUPPORT, arguments: file);
              } else {
                // User canceled the picker
              }
            },
            child: Container(
              height: 100,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xffE9E9E7)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/camera_plus.png',
                  ),
                  SizedBox(height: 10,),
                  Text('Prenez votre cour en photo...')
                ],
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          GestureDetector(
            onTap: () async{
              Navigator.of(context).pop();
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                var file = result.files.first.xFile;
                Get.toNamed(Routes.IMPORT_SUPPORT, arguments: file);
              } else {
                // User canceled the picker
              }

            },
            child: Container(
              height: 100,
              width: Get.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xffF3F1D3)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/file_plus .png',
                  ),
                  SizedBox(height: 10,),
                  Text('Importez votre document...')
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
