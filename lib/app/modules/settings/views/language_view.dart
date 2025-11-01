import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select New Language',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
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
                            fontSize: 16,
                            color: controller.selectedLanguage.value == lang
                                ? Color(0xFF0066FF)
                                : Colors.black87,
                            fontWeight: controller.selectedLanguage.value == lang
                                ? FontWeight.w500
                                : FontWeight.normal,
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
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Save and go back
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0066FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}