import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../../../../l10n/app_localizations.dart';

class LanguageController extends GetxController {
  var box = GetStorage();
  late RxString selectedLanguage = Get.locale.toString().obs;

  // Use hardcoded language codes instead of accessing AppLocalizations
  var languageList = [
    'fr', // French
    'en', // English
  ].obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize selected language from storage or current locale
    String? storedLanguage = box.read('language');
    if (storedLanguage != null) {
      selectedLanguage.value = storedLanguage;
    } else {
      selectedLanguage.value = Get.locale.toString();
    }
  }

  // Get display name for language code
  String getLanguageDisplayName(String languageCode, BuildContext context) {
    switch (languageCode) {
      case 'fr':
        return AppLocalizations.of(context)!.fr;
      case 'en':
        return AppLocalizations.of(context)!.en;
      default:
        return languageCode;
    }
  }

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    box.write('language', languageCode);

    // Update the app locale
    Locale locale = Locale(languageCode);
    Get.updateLocale(locale);
  }
}