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
import '../../../routes/app_routes.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/chat_controller.dart';



class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Discussion History Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(
                    maxHeight: isSmallScreen ? screenHeight * 0.4 : screenHeight * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: bgColorChatScreen,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Historique de discussion',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ).marginOnly(bottom: 16),

                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.historicList.length,
                          itemBuilder: (context, index) {
                            final historic = controller.historicList[index];
                            return GestureDetector(
                              onTap: () => Get.toNamed(Routes.CHAT_PLATFORM),
                              child: HistoricWidget(
                                smallDescription: historic.smallDescription,
                                onPressed: () {},
                                date: historic.date,
                                course: historic.course,
                              ).marginOnly(bottom: 10),
                            );
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.HISTORY),
                          child: Text(
                            'Voir tout...',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.blue,
                            ),
                          ),
                        ).marginOnly(top: 8),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// IA Exercise Header
                Text(
                  'Exerce toi avec notre IA',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ).marginOnly(bottom: 10),

                /// Exercise Scroll Cards
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/new_account.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: screenWidth * 0.4,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              color: bgColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Un problème de math',
                                    style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Filme tu envoie on bosse ensemble',
                                    style: TextStyle(fontSize: screenWidth * 0.025),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ).marginOnly(right: 10);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


