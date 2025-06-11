import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../color_constants.dart';
import '../../../common/ui.dart';

class AddInstructionWidget extends StatelessWidget {

  AddInstructionWidget({
    Key? key,
    this.initialValue,
    this.textController,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.errorText,
    this.obscureText,
    this.focus,
    required this.suffixIcon,
    this.editable,
    this.style,
    this.textAlign,
    this.onTap,
    this.maxLines,
    this.selection,
    this.onCancelTapped
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final Function()? onTap;
  final Function()? onCancelTapped;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  var errorText;
  final TextAlign? textAlign;
  final TextStyle? style;
  final bool? editable;
  final String? initialValue;
  final bool? obscureText;
  final bool? focus;
  final Widget suffixIcon;
  final int? maxLines;
  var selection;
  var textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 113,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xffECECEC)
      ),
      child: TextFormField(
        autofocus: focus??false,
        controller: textController?? TextEditingController(text: null),
        initialValue: initialValue,
        maxLines: keyboardType == TextInputType.multiline ? null : 16,
        key: key,
        keyboardType: keyboardType ?? TextInputType.text,
        onSaved: onSaved,
        onTap: onTap,
        readOnly: false,
        onChanged: onChanged,
        minLines: maxLines,
        validator: validator,
        enabled: editable,
        style: style ?? Get.textTheme.headlineMedium,
        obscureText: obscureText ?? false,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          hintText: hintText ?? '',
            contentPadding: EdgeInsets.only(top: 25, left: 20),
            suffixIcon: suffixIcon.paddingOnly(right: Get.width*0.08),
          border: InputBorder.none
        )

      ).marginOnly(bottom: 20),
    );
  }



}
