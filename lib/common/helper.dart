// coverage:ignore-file
import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../app/modules/root/controllers/root_controller.dart';
import '../color_constants.dart';
import 'ui.dart';
import '../../l10n/app_localizations.dart';

class Helper {
  late DateTime currentBackPressTime;
  final MethodChannel methodChannel;

  Helper({MethodChannel? methodChannel})
      : currentBackPressTime = DateTime.now(),
        methodChannel = methodChannel ?? MethodChannel('flutter/platform');

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.showSnackbar(Ui.defaultSnackBar(message: AppLocalizations.of(Get.context!).tap_again_to_leave));
      return false;
    }

    // Use SystemNavigator.pop() directly - no method channel needed
    SystemNavigator.pop();
    return true;
  }


  static Future<dynamic> getJsonFile(String path) async {
    return rootBundle.loadString(path).then(convert.jsonDecode);
  }

  static Future<dynamic> getFilesInDirectory(String path) async {
    var files = io.Directory(path).listSync();
    print(files);
    // return rootBundle.(path).then(convert.jsonDecode);
  }

  static String toUrl(String path) {
    if (!path.endsWith('/')) {
      path += '/';
    }
    return path;
  }

  static String toApiUrl(String path) {
    path = toUrl(path);
    if (!path.endsWith('/')) {
      path += '/';
    }
    return path;
  }
}