import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizzSettingItemWidget extends StatelessWidget {

  QuizzSettingItemWidget({
    required this.value,
    required this.label,
    required this.onDecrease,
    required this.onIncrease,
    Key? key,

  }) : super(key: key);

  final Function() onIncrease;
  final Function() onDecrease;
  final String label;
  final String value;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF1F6FD),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 60,
      child: Row(
        children: [
          Text(label),
          Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onDecrease,
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onIncrease,
          ),
        ],
      ),
    );;
  }



}
