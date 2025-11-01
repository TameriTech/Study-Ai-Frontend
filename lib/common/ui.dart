// coverage:ignore-file
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../color_constants.dart';

class Ui {
  static GetSnackBar SuccessSnackBar({String title = 'Success', required String message}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.headlineMedium!.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message, style: Get.textTheme.headlineMedium!.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.green,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      icon: Icon(Icons.check_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 2),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error', required String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.headlineSmall!.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message.substring(0, min(message.length, 200)), style: Get.textTheme.headlineMedium?.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Colors.redAccent,
      icon: Icon(Icons.remove_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar InfoSnackBar({String title = 'Info', required String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.headlineSmall!.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message.substring(0, min(message.length, 200)), style: Get.textTheme.headlineMedium?.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Colors.blue,
      icon: Icon(Icons.info_outline_rounded, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar warningSnackBar({String title = 'Warning', required String message}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.headlineSmall!.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message.substring(0, min(message.length, 200)), style: Get.textTheme.headlineMedium?.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.orangeAccent,
      icon: Icon(Icons.warning_amber_rounded, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar defaultSnackBar({String title = 'Alert', required String message}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.headlineSmall!.merge(TextStyle(color: Get.theme.hintColor))),
      messageText: Text(message, style: Get.textTheme.headlineMedium!.merge(TextStyle(color: Get.theme.focusColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Get.theme.primaryColor,
      borderColor: Get.theme.focusColor.withOpacity(0.1),
      icon: Icon(Icons.warning_amber_rounded, size: 32, color: Get.theme.hintColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar notificationSnackBar({String title = 'Notification', required String message, required OnTap onTap, required Widget mainButton}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      onTap: onTap,
      mainButton: mainButton,
      isDismissible: true,
      dismissDirection: DismissDirection.vertical,
      titleText: Text(title.tr, style: Get.textTheme.titleSmall),
      messageText: Text(message, style: Get.textTheme.headlineMedium?.merge(TextStyle(color: buttonColor, fontSize: 12)), maxLines: 2),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Get.theme.primaryColor,
      borderColor: Get.theme.focusColor.withOpacity(0.1),
      icon: Icon(Icons.notifications_none, size: 32, color: Get.theme.hintColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 5,
      duration: Duration(seconds: 5),
    );
  }

  static BoxDecoration getBoxDecoration({Color? color, double? radius, Border? border, Gradient? gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static InputDecoration getInputDecoration({String hintText = '', var errorText, required var prefixIcon, required Widget suffixIcon, required Widget suffix, var isFirst}) {
    return InputDecoration(
        fillColor: Color(0xffF7F7F7),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
        prefixIcon: prefixIcon != null? prefixIcon: SizedBox(),
        prefixIconConstraints: prefixIcon != null ? BoxConstraints.expand(width: 38, height: 38) : BoxConstraints.expand(width: 10, height: 10),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: EdgeInsets.all(20),
        border: isFirst== null? OutlineInputBorder(borderSide:BorderSide.none)
            :OutlineInputBorder(borderSide:BorderSide(width: 0, style: BorderStyle.solid, color: Color(0xffF7F7F7) ), borderRadius: BorderRadius.circular(12),),
        focusedBorder: isFirst== null? OutlineInputBorder(borderSide:BorderSide.none)
            :OutlineInputBorder(borderSide:BorderSide(width: 0, style: BorderStyle.solid, color: Color(0xffF7F7F7)), borderRadius: BorderRadius.circular(12)),
        enabledBorder: isFirst== null? OutlineInputBorder(borderSide:BorderSide.none)
            :OutlineInputBorder(borderSide:BorderSide(width: 0, style: BorderStyle.solid,color: Color(0xffF7F7F7)), borderRadius: BorderRadius.circular(12)),
        suffixIcon: suffixIcon,
        suffix: suffix,
        errorText: errorText,
        errorBorder:  errorText!=null?OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black ),borderRadius: BorderRadius.circular(30)):OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Colors.red ),borderRadius: BorderRadius.circular(30))
    );
  }

  static InputDecoration getSearchInputDecoration({String hintText = '', required String errorText, required Widget suffixIcon, required Widget prefixIcon, required Widget suffix}) {
    return InputDecoration(
      contentPadding: EdgeInsets.zero,
      hintText: hintText,
      hintStyle: Get.textTheme.headlineMedium!.merge(TextStyle(color: Colors.grey, fontSize: 16)),
      prefixIcon: prefixIcon != null ? prefixIcon.marginOnly(left: 14, right: 14) : SizedBox(),
      //prefixIconConstraints: prefixIcon != null ? BoxConstraints.expand(width: 38, height: 38) : BoxConstraints.expand(width: 0, height: 0),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      //contentPadding: EdgeInsets.all(20),
      border: OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black ), borderRadius: BorderRadius.circular(30),),
      focusedBorder: OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Colors.black), borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid,color: Colors.black), borderRadius: BorderRadius.circular(30)),
      suffixIcon: suffixIcon,
      suffix: suffix,
      //errorText: errorText,


    );
  }

  static Color parseColor(String hexCode, {required double opacity}) {
    try {
      return Color(int.parse(hexCode.replaceAll("#", "0xFF"))).withOpacity(opacity ?? 1);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }
  }


}
