import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studyai/app/modules/files/tabs/all_pages.dart';
import 'package:studyai/app/modules/files/tabs/quiz_tab.dart';
import 'package:studyai/app/modules/global_widgets/search_text_field_widget.dart';
import 'package:studyai/app/modules/root/controllers/root_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_routes.dart';
import '../../../services/image_picker_service.dart';
import '../controllers/files_controller.dart';
import '../tabs/courses_tab.dart';
import '../tabs/revision_tab.dart';

class FilesView extends GetView<FilesController> {
  const FilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          toolbarHeight: 80,
          leadingWidth: 0,
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: Icon(null),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good morning,",
                style: Get.textTheme.labelLarge,),
              Text(
                controller.currentUser.value.fullName ?? "User",
                style: Get.textTheme.labelLarge,
              ),
            ],
          ),
          actions: [
           GestureDetector(
             onTap: (){},
             child:  Image.asset(
               'assets/icons/notification_bell.png',
               fit: BoxFit.cover,
             ),
           ).marginOnly(right: 20)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.onInit();
          },
          child: Container(
            color: Colors.grey[100],
            height: Get.height,
            child: Column(
              children: [
                SearchTextFieldWidget(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  hintText: AppLocalizations.of(context).search_course_quizz,
                  errorText: '',
                  suffixIcon: Icon(null),
                  suffix: Icon(null),
                  readOnly: false,
                  onChanged: (value) {
                    controller.searchBasedOnName(value);
                  },
                ).marginSymmetric(horizontal: 16, vertical: 10),
                TabViewWidget(context),
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(() => FloatingActionButton.extended(
          backgroundColor: appColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: Icon(
            controller.selectedHomeIndex.value == 2
                ? Icons.bolt_outlined
                : Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            if (controller.selectedHomeIndex.value == 2) {
              controller.selectedHomeIndex.value = 0;
              Get.find<RootController>().changePageInRoot(1);
            } else {
              controller.generationState.value =
              controller.courseGenerationState[0];
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => showButtomSheet(context),
              );
            }
          },
          label: Text(
            controller.selectedHomeIndex.value == 2
                ? "Create new quiz"
                : "Create new course",
            style: Get.textTheme.labelMedium,
          ),
        )).marginOnly(bottom: 80, right: 10),
      ),
    );
  }

  TabViewWidget(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Expanded(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            leadingWidth: 0,
            centerTitle: true,
            backgroundColor: Colors.grey[100],
            elevation: 0,
            leading: Icon(null),
            toolbarHeight: 60,
            title: TabBar(
              dividerColor: Colors.transparent,
              labelColor: primaryColor,
              unselectedLabelColor: Color(0xff99A0AE),
              labelStyle: Get.textTheme.labelSmall?.merge(TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),),
              unselectedLabelStyle: Get.textTheme.labelSmall?.merge(
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                controller.selectedHomeIndex.value = value;
              },
              tabs: [
                Tab(text: AppLocalizations.of(context).all),
                Tab(text: AppLocalizations.of(context).courses),
                Tab(text: AppLocalizations.of(context).quiz),
                Tab(text: AppLocalizations.of(context).revisions),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllPages(),
              CoursesTab(),
              QuizTab(),
              RevisionTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showButtomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 40),
              Text(
                "Create new course",
                style: Get.textTheme.titleMedium
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),


          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final ImagePickerService imagePickerService =
              ImagePickerService();
              var picture = await imagePickerService.pickFromCamera();
              if (picture != null) {
                var file = XFile(picture.path);
                controller.importedFile = file;
                Navigator.of(context).pop();
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (context) => _showAddInstructionsSheet(context));
              }

            },
            child: Container(
              height: 120,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffFFF9E6),
                border: Border.all(color: Color(0xffE5DCC0), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Color(0xffD4A574),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Scan your course",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffA67C52),
                      fontFamily: 'Inter'
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () async {

              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf','jpg','png','jpeg'],
              );

              if (result != null) {
                var file = result.files.first.xFile;
                controller.importedFile = file;
                Navigator.of(context).pop();
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (context) => _showAddInstructionsSheet(context));
              }
            },
            child: Container(
              height: 120,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file_outlined,
                    size: 40,
                    color: Color(0xffD4A574),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Upload a document",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                        fontFamily: 'Inter'
                    ),
                  ),
                  Text(
                    "(pdf and images) only",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                        fontFamily: 'Inter'
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _showAddInstructionsSheet(BuildContext context) {
   return  Container(
       height: Get.height * 0.85,
       decoration: BoxDecoration(
       color: Colors.grey[100],
       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
     child: Column(
       children: [
         // Header
         Container(
           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
           decoration: BoxDecoration(
             color: Colors.grey[100],
             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               SizedBox(width: 40),
               Text(
                 "Add Instructions",
                 style: Get.textTheme.titleMedium,
               ),
               IconButton(
                 icon: Icon(Icons.close, color: Colors.black),
                 onPressed: () => Navigator.of(context).pop(),
               ),
             ],
           ),
         ),
         // Content
         Expanded(
           child: SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.all(20),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // File Preview Container
                   Container(
                     height: 140,
                     width: Get.width,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(16),
                       color: Color(0xffFFF9E6),
                       border: Border.all(color: Color(0xffE5DCC0), width: 1),
                     ),
                     child: controller.importedFile.path.contains('.pdf')
                         ? Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(
                             Icons.picture_as_pdf,
                             size: 50,
                             color: Color(0xffD4A574),
                           ),
                           SizedBox(height: 8),
                           Text(
                             controller.importedFile.path.split('/').last,
                             textAlign: TextAlign.center,
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(
                               fontSize: 12,
                               color: Colors.black87,
                             ),
                           ).paddingSymmetric(horizontal: 16),
                         ],
                       ),
                     )
                         : ClipRRect(
                       borderRadius: BorderRadius.circular(16),
                       child: Image.file(
                         File(controller.importedFile.path),
                         fit: BoxFit.cover,
                       ),
                     ),
                   ),
                   SizedBox(height: 24),

                   // Instructions Input
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(16),
                       border: Border.all(color: Colors.grey.shade300, width: 1),
                     ),
                     padding: EdgeInsets.all(16),
                     child: TextField(
                       controller: controller.instructionsController,
                       maxLines: 6,
                       style: TextStyle(
                         fontSize: 14,
                         color: Colors.black87,
                       ),
                       decoration: InputDecoration(
                         hintText: "Enter detailed instructions",
                         hintStyle: TextStyle(
                           fontSize: 14,
                           fontWeight: FontWeight.w400,
                           fontFamily: 'Inter',
                           color: Color(0xff0E121B)
                         ),
                         border: InputBorder.none,
                         enabledBorder: InputBorder.none,
                         focusedBorder: InputBorder.none,
                       ),
                     ),
                   ),
                   SizedBox(height: 20),

                   // Level Selector
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.grey.shade300, width: 1),
                     ),
                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                     child: Obx(() => DropdownButton<String>(
                       value: controller.selectLevel.value.isEmpty
                           ? null
                           : controller.selectLevel.value,
                       hint: Text(
                         "Select level",
                         style: TextStyle(
                             fontSize: 14,
                             color: Color(0xff9C9C9C),
                             fontWeight: FontWeight.normal,
                             fontFamily: 'Inter'
                         ),
                       ),
                       isExpanded: true,
                       underline: SizedBox(),
                       icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                       items: ['Beginner', 'Intermediate', 'Advanced']
                           .map((String level) {
                         return DropdownMenuItem<String>(
                           value: level,
                           child: Text(level),
                         );
                       }).toList(),
                       onChanged: (String? newValue) {
                         if(newValue != null){
                           controller.selectLevel.value = newValue;
                         }
                       },
                     ),)
                   ),
                   SizedBox(height: 30),

                   // Generate Button
                   SizedBox(
                     width: Get.width,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: appColor,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12),
                         ),
                         padding: EdgeInsets.symmetric(vertical: 16),
                         elevation: 0,
                       ),
                       onPressed: () async {
                         Navigator.of(context).pop();
                         Get.toNamed(Routes.IMPORT_SUPPORT);
                         controller.startProgress();
                       },
                       child: Text(
                           AppLocalizations.of(context).generate,
                         style: Get.textTheme.labelMedium
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       ],

     ),
   );
  }
}