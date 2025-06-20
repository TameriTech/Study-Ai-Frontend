import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/chat/views/text_animation.dart';
import 'package:studyai/app/modules/global_widgets/historic_widget.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    //final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    //final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome message
              TypewriterText(
                text: 'Bienvenue 👋',
                speed: Duration(milliseconds: 50),
                startDelay: Duration(seconds: 1), // speed between each character
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                )
              ),
              SizedBox(height: 8),

              // 2. Intro description

              TypewriterText(
                  text: 'Ton assistant d’étude intelligent est là pour t’aider à comprendre, réviser, et progresser.',
                  speed: Duration(milliseconds: 50),
                  startDelay: Duration(seconds: 1), // speed between each character
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey[700],
                  ),
              ),
              SizedBox(height: 16),

              // 3. Features preview
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.smart_toy, color: Colors.black, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: TypewriterText(
                      text: 'Pose des questions ou envoie un fichier PDF : on bosse ensemble.',
                      speed: Duration(milliseconds: 50),
                      startDelay: Duration(seconds: 1), // speed between each character
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 4. Illustration (optional)
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  height: Get.height/3,
                  decoration: BoxDecoration(
                    color: bgColorChatScreen,
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: AssetImage("assets/images/new_account.png"),
                    fit: BoxFit.cover)
                  )
                )
              ),
              // 5. Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => {
                    controller.messagesSent.clear(),
                    Get.toNamed(Routes.CHAT_PLATFORM),
                  },
                  child: Text(
                    "Continuer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Discussion History Section
              /*Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                decoration: BoxDecoration(
                  color: bgColorChatScreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.HISTORY),
                        child: Text(
                          'Voir tout...',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.blue,
                          ),
                        ),
                      ).marginOnly(top: 10),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),*/

              /// IA Exercise Header
              Text(
                'Exerce toi avec notre IA',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ).marginOnly(bottom: 10),

              SizedBox(height: 20),
              /// Exercise Scroll Cards
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: ()=> Get.toNamed(Routes.CHAT_PLATFORM),
                      child: Stack(
                        children: [
                          Container(
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              border: Border.all(color: Colors.grey, width: 2),
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
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border(
                                    right: BorderSide(color: Colors.grey, width: 2),
                                    left: BorderSide(color: Colors.grey, width: 2),
                                    bottom: BorderSide(color: Colors.grey, width: 2),
                                )
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),

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
                      ).marginOnly(right: 10),
                    );
                  },
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}


