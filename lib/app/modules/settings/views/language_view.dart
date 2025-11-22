import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../../global_widgets/block_button_widget.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  @override
  Widget build(BuildContext context) {
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
                    'Select New Language',
                    style: Get.textTheme.titleMedium,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              )
          ),

          // White content section
          Expanded(
            child:  ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.languageList.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                var lang = controller.languageList.elementAt(index);
                return Obx(() => InkWell(
                  onTap: () => controller.changeLanguage(lang),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.getLanguageDisplayName(lang, context),
                          style: TextStyle(
                            fontSize: 14,
                            color: controller.selectedLanguage.value == lang
                                ? Color(0xFF0066FF)
                                : Colors.black87,
                            fontWeight: controller.selectedLanguage.value == lang
                                ? FontWeight.w500
                                : FontWeight.normal,
                            fontFamily: 'Inter'
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.selectedLanguage.value == lang
                                  ? Color(0xFF0066FF)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: controller.selectedLanguage.value == lang
                                ? Color(0xFF0066FF)
                                : Colors.transparent,
                          ),
                          child: controller.selectedLanguage.value == lang
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ));
              },
            ),
          ),

          // Continue button at bottom
          SizedBox(
            width: Get.width,
            child: BlockButtonWidget(
                color: primaryColor,
                haveBorder: false,
                text: Text('Save', style: Get.textTheme.labelMedium),
                onPressed: (){
                  Navigator.pop(context);
                }),
          ).marginSymmetric(vertical: 20,horizontal: 20)

        ],
      ),
    );

  }
}