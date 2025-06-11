import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../color_constants.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/auth_service.dart';
import '../controllers/chat_controller.dart';

// ignore: must_be_immutable

class ChatPlatform extends GetView<ChatController> {
  final _myListKey = GlobalKey<AnimatedListState>();
  // final int ticketId;
  // final String code;

  ChatPlatform();


  Widget chatList() {
    return Obx(
          () {
        if (controller.isLoading.value) {
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
              key: _myListKey,
              reverse: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              itemCount: 0,
              shrinkWrap: false,
              primary: true,
              itemBuilder: (context, index) {
                List receivedMessages = [];
                Future.delayed(Duration.zero, (){
                  controller.messages.sort((a, b) => b["date"].compareTo(a["date"]));
                });
                if(Get.find<AuthService>().user.value.userId != controller.messages[index]['author_id']){
                  receivedMessages.add(controller.messages[index]);
                }

                return Column(
                    children: [
                      if(Get.find<AuthService>().user.value.userId == controller.messages[index]['author_id'])...[
                        getSentMessageTextLayout(context, controller.messages[index], index),
                        if(index == 0)...[
                          for(var a in controller.messagesSent)...[
                            getSentMessage(context, a)
                          ],
                        ],
                      ]else...[
                        getReceivedMessageTextLayout(context, controller.messages[index], index),
                      ],
                    ]
                );
              }
          );
        }
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
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
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
            print(Get.width);
            //controller.refreshMessages();
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
             Expanded(child: chatList()),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: Get.width-Get.width/80,
                        height: 80,
                        child: TextFormField(
                         // controller: controller.chatTextController,
                          style: Get.textTheme.bodyLarge?.merge(TextStyle(fontSize: 18)),
                          //expands: true,
                          //keyboardType: TextInputType.number,
                          maxLines: 5,
                          //onChanged: (value)=> controller.checkValue(value),

                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            hintText: 'Comment here'.tr,
                            hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                            suffixIcon:SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    //IconButton(
                                    //onPressed: () async {
                                    // //controller.ticketFiles.clear();
                                    // controller.ticketFiles.clear();
                                    // await controller.pickImage(ImageSource.gallery);
                                    //
                                    // //Navigator.pop(Get.context);
                                    // controller.enableImageSend.value = true;
                                    //}, icon: Icon(Icons.attach_file)),

                                    IconButton(
                                      padding: EdgeInsetsDirectional.only(end: 10, start: 10),
                                      onPressed: () async{
                                        // if(controller.enableImageSend.value){
                                        //
                                        //   print(controller.enableImageSend.value);
                                        //   String message = '';
                                        //   message = controller.chatTextController.text;
                                        //   await controller.messagesSent.add([controller.ticketFiles[controller.ticketFiles.length-1], message]);
                                        //   print(controller.messagesSent);
                                        //   var messageId = await controller.sendMessage(ticketId, Get.find<MyAuthService>().myUser.value.id, message);
                                        //   await controller.uploadTicketMessageImage(ticketId, controller.ticketFiles[controller.ticketFiles.length-1],messageId );
                                        //   Timer(Duration(milliseconds: 100), () {
                                        //     controller.chatTextController.clear();
                                        //     controller.enableImageSend.value = false;
                                        //     controller.enableSend.value = false;
                                        //   });
                                        //
                                        //
                                        // }
                                        // else{
                                        //
                                        //   String message = '';
                                        //   message = controller.chatTextController.text;
                                        //   if(message.isNotEmpty){
                                        //     controller.messagesSent.add(message);
                                        //     controller.sendMessage(ticketId, Get.find<MyAuthService>().myUser.value.id, message);
                                        //     Timer(Duration(milliseconds: 100), () {
                                        //       controller.chatTextController.clear();
                                        //       controller.enableSend.value = false;
                                        //     });
                                        //   }
                                        // }



                                      },
                                      icon: Icon(
                                        Icons.send_outlined,
                                        //color: controller.enableSend.value ? Get.theme.colorScheme.secondary : inactive,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                )
                            ),
                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  Widget getSentMessageTextLayout(context, var message, int index) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: Get.width
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Get.theme.focusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      //constraints: BoxConstraints(
                      //  maxWidth: Get.width - 40),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.only(top: 5.0),
                                child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: message['body'].length<4?'':message['body'].substring(3,message['body'].toString().length-4)+ "\n",
                                          ),
                                        ]
                                    )
                                )
                            ),
                            message['attachment_ids'].toString() != '[]'?
                            GestureDetector(
                              onTap: (){
                                showDialog(
                                    context: context, builder: (_){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Material(
                                          child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: FadeInImage(
                                          width: Get.width,
                                          height: Get.height/2,
                                          fit: BoxFit.cover,
                                          image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                              //headers: Domain.getTokenHeaders()
                                          ),
                                          placeholder: AssetImage(
                                              "assets/img/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Container(
                                                    width: Get.width/1.5,
                                                    height: Get.height/3,
                                                    color: Colors.white,
                                                    child: Center(
                                                        child: Icon(Icons.person, size: 150)
                                                    )
                                                )
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                });
                              },
                              child: Card(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: FadeInImage(
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                           // headers: Domain.getTokenHeaders()
                                        ),
                                        placeholder: AssetImage(
                                            "assets/img/loading.gif"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fitWidth);
                                        },
                                      )
                                  )
                              ),
                            )
                                :SizedBox()
                          ]
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text( DateFormat('d, MMM y | HH:mm').format(DateTime.parse(message['date'])),
                        overflow: TextOverflow.fade,
                        softWrap: false,)
                        )
                ],
              )
          ),
          ClipOval(
              child: FadeInImage(
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                image: NetworkImage('/image/res.partner//image_1920?unique=true&file_response=true',
                    //headers: Domain.getTokenHeaders()
                ),
                placeholder: AssetImage(
                    "assets/img/loading.gif"),
                imageErrorBuilder:
                    (context, error, stackTrace) {
                  return Image.asset(
                      'assets/img/téléchargement (3).png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.fitWidth);
                },
              )
          )
        ],
      ),
    );
  }

  Widget getSentMessage(context, var message) {

    return message is List ?
    Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              showDialog(
                  context: context, builder: (_){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                        child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        message[0],
                        width: Get.width,
                        height: Get.height/2,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              });
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: "ppppppp", ),
                                ]
                            )
                        )
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        message[0],
                        //controller.ticketFiles[index],
                        fit: BoxFit.cover,
                        width: 120,
                        height:100,
                      ),
                    )
                  ],
                )
            ),
          ),
        ]
    ):
    Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Get.theme.focusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(text: 'lllllllll' ),
                                    ]
                                )
                            )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text( DateFormat('d, MMM y | HH:mm').format(DateTime.now()),
                        overflow: TextOverflow.fade,
                        softWrap: false, )
                    ),
                ],
              )
          ),
        ]
    )
    ;

  }

  Widget getReceivedMessageTextLayout(context, var message, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
            child: FadeInImage(
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              image: NetworkImage('/image/res.partner/image_1920?unique=true&file_response=true',
                  //headers: Domain.getTokenHeaders()
              ),

              placeholder: AssetImage(
                  "assets/img/loading.gif"),
              imageErrorBuilder:
                  (context, error, stackTrace) {
                return Image.asset(
                    'assets/img/téléchargement (3).png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.fitWidth);
              },
            )
        ),
        Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Get.theme.colorScheme.secondary,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(text: message['body']!= ''?message['body'].toString().substring(3,message['body'].toString().length-4)+ "\n": '',
                                        ),
                                      ]
                                  )
                              )
                          ),
                          message['attachment_ids'].toString() != '[]'?
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context, builder: (_){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                        child: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close, size: 20))
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      child: FadeInImage(
                                        width: Get.width,
                                        height: Get.height/2,
                                        fit: BoxFit.cover,
                                        image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                            //headers: Domain.getTokenHeaders()
                                        ),
                                        placeholder: AssetImage(
                                            "assets/img/loading.gif"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child: Container(
                                                  width: Get.width/1.5,
                                                  height: Get.height/3,
                                                  color: Colors.white,
                                                  child: Center(
                                                      child: Icon(Icons.person, size: 150)
                                                  )
                                              )
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                );
                              });
                            },
                            child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      image: NetworkImage('https://preprod.hubkilo.com/ticket/attachment/${message['attachment_ids'][0]}?unique=true&file_response=true',
                                          //headers: Domain.getTokenHeaders()
                                      ),
                                      placeholder: AssetImage(
                                          "assets/img/loading.gif"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/img/240_F_89551596_LdHAZRwz3i4EM4J0NHNHy2hEUYDfXc0j.jpg',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fitWidth);
                                      },
                                    )
                                )
                            ),
                          )
                              :SizedBox()
                        ]
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      DateFormat('HH:mm | d, MMM y').format(DateTime.parse(message['date'])),
                      overflow: TextOverflow.fade,
                      softWrap: false,

                  ),
                ),
              ],
            )
        ),
      ],
    );
  }
}
