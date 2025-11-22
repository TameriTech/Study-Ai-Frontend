import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:studyai/color_constants.dart';

import 'block_button_widget.dart';
import '../../../../l10n/app_localizations.dart';

class WarningDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: MediaQuery.of(context).size.height/6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/icons/warning.png',
          width: 55,
          height: 52,
        ),
        content: Text(message, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
          textAlign: TextAlign.justify,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width/2.5,
                child: BlockButtonWidget(
                  color: disableButtonColor,
                  haveBorder: false,
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  text:  Text(AppLocalizations.of(context).cancel, style: Get.textTheme.labelMedium),
                ),
              ),
              SizedBox(
                width: Get.width/2.5,
                child: BlockButtonWidget(
                  color: Color(0xffB91F13),
                  haveBorder: false,
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    if (onConfirm != null) onConfirm();
                  },
                  text:  Text(confirmText, style: Get.textTheme.labelMedium),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}