import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../controllers/language_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageView extends GetView<LanguageController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:  AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => {
              Navigator.pop(context),
              //Get.back()
            },
          ),
          title: Text(
            AppLocalizations.of(context).language,
           // AppLocalizations.of(context).language,
            style: TextStyle(color: Colors.black87, fontSize: 26.0),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)), ),
          child: ListView(
            primary: true,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: Ui.getBoxDecoration(),
                  child: Obx(() => Column(
                    children: List.generate(controller.languageList.length, (index) {
                      var _lang = controller.languageList.elementAt(index).obs;
                      return Obx(() => RadioListTile(
                        value: _lang.value,
                        groupValue: controller.selectedLanguage.value,
                        activeColor: tertiaryColor,
                        onChanged: (value) async{
                          print("value is :${value}");
                          controller.changeLanguage(value!);
                          //controller.updateLocale(value);
                        },

                        title: Obx(() => Text(controller.getLanguageDisplayName(_lang.value, context), ),),
                      ),);
                    }).toList(),
                  ),),
                )

            ],
          ),
        ));
  }
}
