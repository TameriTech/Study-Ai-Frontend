import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: bgColor,
          leading: Icon(null),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Hey ${controller.currentUser.value.fullName}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
              Text("Etudiant en ${controller.currentUser.value.classLevel}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey),),

          ],),
          actions: [
            Image.asset(
              'assets/images/settings.png',
              fit: BoxFit.cover,
            ).marginOnly(right: 16)
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              //await controller.refreshCommunity();
              controller.onInit();
            },
            child:  Container(
              color: backgroundColor,
              height: Get.height,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Pense à finaliser ton\ninscription",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.COMPLETE_PROFILE_VIEW);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Inscription",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Plus d’option et plus de\npersonnalisation",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Mes stats",style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),

                  // Deuxième carte
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ma progression",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Progress bar personnalisée
                        Stack(
                          children: [
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: double.parse(controller.currentUser.value.statistic.toString()), // 64% de progression
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  "${controller.currentUser.value.statistic!}%",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ),
            ),

          ),
        ),



    );
  }
}


