
import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:studyai/app/modules/chat/views/text_animation.dart';
import '../../../../color_constants.dart';
import '../controllers/chat_controller.dart';
import 'expandable_markdown.dart';

class ChatPlatform extends GetView<ChatController> {
  ChatPlatform({super.key});
  final _myListKey = GlobalKey<AnimatedListState>();
  // final int ticketId;
  // final String code;

  Widget chatList() {
    return Obx(
          () {
            if(controller.messagesSent.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 200, height: 200),
                  TypewriterText(
                    text: "Welcome back! How can I help you today?",
                    speed: Duration(milliseconds: 50),
                    startDelay: Duration(seconds: 1), // speed between each character
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ]
              );
            }else{
              return ListView.builder(
                  key: _myListKey,
                  controller: controller.scrollController,
                  reverse: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  itemCount: controller.messagesSent.length +1,
                  shrinkWrap: false,
                  itemBuilder: (context, index) {

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(index == controller.messagesSent.length)...[
                            if(controller.isLoading.value)
                              Row(
                                  mainAxisSize: MainAxisSize.min, // shrink wrap width to the spinner
                                  mainAxisAlignment: MainAxisAlignment.start, // align left inside row
                                  children: [
                                    SpinKitThreeBounce(color: courseColor, size: 20),
                                  ]
                              )
                          ]else...[
                            if(controller.messagesSent[index].sender == "user")...[
                              if(controller.messagesSent[index].document != "")...[
                                PdfView(controller.messagesSent[index].document)
                              ],
                              SizedBox(height: 5),
                              BubbleSpecialOne(
                                text: controller.messagesSent[index].text,
                                isSender: true,
                                color: courseColor,
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                            if(controller.messagesSent[index].sender == "bot")
                              ExpandableMarkdown(
                                markdown: controller.messagesSent[index].text,
                              )
                              /*BubbleSpecialOne(
                                  text: controller.messagesSent[index].text,
                                  isSender: false,
                                  color: Color(0xFFFFFFFF),
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  )
                              )*/
                          ]
                        ]
                    );
                  }
              );
            }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Tameri Study AI"),
          leading: IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          actions: [
            InkWell(
              onTap: (){
                controller.messagesSent.clear();
              },
              child: Image.asset("assets/images/logo.png"),
            )
          ],
          centerTitle: true,
          automaticallyImplyLeading: false,

      ),
      body: RefreshIndicator(
          onRefresh: ()async{
            //controller.refreshMessages();
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
             Expanded(child: chatList()),

              Obx((){
                if(controller.fileName.value == ""){
                  return SizedBox.shrink();
                }else{
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                    ),
                    height: 80,
                    width: Get.width - 10,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/file_pdf.svg", width: 30, height: 50,),
                        SizedBox(width: 10),
                        SizedBox(
                          width: Get.width/1.8,
                          child: Text(controller.fileName.value, overflow: TextOverflow.ellipsis)
                        )
                      ]
                    )
                  );
                }

              }),
              MessageBar(
                messageBarHintText: "Ask any question",
                onSend: (_) async{
                  if(controller.filePath.isEmpty){
                    controller.messagesSent.add(Message(text: controller.msgController.text, sender: 'user', document: ''));
                    await controller.sendPrompt(controller.msgController.text, 0);
                  }else{
                    controller.messagesSent.add(
                        Message(
                            text: controller.msgController.text,
                            sender: 'user',
                            document: controller.fileName.value
                        )
                    );
                    controller.fileName.value = "";
                    await controller.getFileId(controller.filePath);
                  }
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
                    onTap: ()async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        controller.fileName.value = result.files.first.xFile.name;
                        controller.filePath = result.files.last.xFile.path;
                      }
                    }
                  ),
                  /*Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),*/
                ],
              ),
            ],
          )
      ),
    );
  }

  Widget PdfView(String fileName){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 100, top: 10),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: courseColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset("assets/images/file_pdf.svg", width: 35, height: 35),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
