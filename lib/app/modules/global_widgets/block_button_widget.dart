import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({Key? key, required this.color, required this.text, required this.onPressed, required this.haveBorder}) : super(key: key);

  final Color color;
  final Widget text;
  final haveBorder;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: MaterialButton(
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        color: this.color,
        disabledElevation: 0,
        disabledColor: Get.theme.focusColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: haveBorder? BorderSide(width: 0.1, color: Colors.black): BorderSide(color: Colors.transparent)),
        child: this.text,
        elevation: 0,
      ),
    );
  }
}
