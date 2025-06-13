import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../controllers/chat_controller.dart';

class ChatPlatform extends GetView<ChatController> {
  final _myListKey = GlobalKey<AnimatedListState>();
  // final int ticketId;
  // final String code;

  ChatPlatform();

  Widget chatList() {
    return Obx(
          () {
            return ListView.builder(
                key: _myListKey,
                controller: controller.scrollController,
                reverse: false,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemCount: controller.messagesSent.length,
                shrinkWrap: false,
                itemBuilder: (context, index) {

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(controller.messagesSent[index].sender == "user")...[
                          BubbleSpecialTwo(
                            text: controller.messagesSent[index].text,
                            isSender: true,
                            color: Color(0xFFFCF398),
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          if(controller.isLoading.value)
                            Row(
                              mainAxisSize: MainAxisSize.min, // shrink wrap width to the spinner
                              mainAxisAlignment: MainAxisAlignment.start, // align left inside row
                              children: [
                                SpinKitThreeBounce(color: courseColor, size: 20),
                              ],
                            )
                        ],
                        if(controller.messagesSent[index].sender == "bot")
                          BubbleSpecialOne(
                              text: controller.messagesSent[index].text,
                              isSender: false,
                              color: Color(0xFFFFFFFF),
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              )
                          )
                      ]
                  );
                }
            );
      },
    );
  }
  // Widget imageContainer() {
  //   return Obx(
  //         () {
  //       return ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           padding: EdgeInsets.all(12),
  //           itemBuilder: (context, index){
  //             return Stack(
  //               //mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 10),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                       child: Image.file(
  //                         controller.ticketFiles[index],
  //                         fit: BoxFit.cover,
  //                         width: Get.width,
  //                         height:Get.height/1.4,
  //                       ),
  //                     )
  //                 ),
  //                 Positioned(
  //                   top:0,
  //                   right:0,
  //                   child: Align
  //                     (
  //                     //alignment: Alignment.centerRight,
  //                     child: IconButton(
  //                         onPressed: (){
  //                           controller.ticketFiles.removeAt(index);
  //                           controller.enableImageSend.value = false;
  //                         },
  //                         icon: Icon(Icons.delete, color: inactive, size: 25, )
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //           separatorBuilder: (context, index){
  //             return SizedBox(width: 8);
  //           },
  //           itemCount: controller.ticketFiles.length);
  //
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),

            ],
          ),
          automaticallyImplyLeading: false,
          leadingWidth: 110,

      ),
      body: RefreshIndicator(
          onRefresh: ()async{
            //controller.refreshMessages();
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
             Expanded(child: chatList()),

              MessageBar(
                onSend: (_) async{

                  controller.messagesSent.add(Message(text: controller.msgController.text, sender: 'user'));
                  await controller.sendPrompt(controller.msgController.text);
                },
                onTextChanged: (value) {
                  controller.msgController.text = value;
                },
                actions: [
                  InkWell(
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}
