import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/global_widgets/historic_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../color_constants.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/chat_controller.dart';



class HistoryView extends GetView<ChatController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            "Historique de discussion",
            style: TextStyle(
              fontSize: screenWidth * 0.055, // responsive font size
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: bgColorChatScreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: ListView.builder(
                itemCount: controller.historicList.length * 3, // if you want 3 copies
                itemBuilder: (context, index) {
                  final item = controller.historicList[index % controller.historicList.length];
                  return HistoricWidget(
                    smallDescription: item.smallDescription,
                    onPressed: () {},
                    date: item.date,
                    course: item.course,
                  ).marginOnly(bottom: 16);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


