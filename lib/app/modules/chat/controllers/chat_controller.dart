
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/historic_model.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../../../services/global_services.dart';

class ChatController extends GetxController{
  final Rx<UserModel> currentUser = Get
      .find<AuthService>()
      .user;

  var historicList= [
    HistoricModel(date: '8 Avril 14: 24', course: 'Math', smallDescription: 'Si on définit la fonction f(x)=2x+3f(x)=2x+3, alors...'),
    HistoricModel(date: '8 Avril 14: 24', course: 'Physics', smallDescription: 'Consider an inclined field with a slope of 30 degrees...'),
    HistoricModel(date: '8 Avril 14: 24', course: 'Computer Science', smallDescription: 'Artificial intellignence...')
  ];

  var isLoading = false.obs;

  var messages = [];

  final RxList<Message> _messagesSent = <Message>[].obs;

  RxList<Message> get messagesSent => _messagesSent;

  TextEditingController msgController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  ChatController() {

  }

  @override
  void onInit() async {
    super.onInit();
    ever(messagesSent, (_) => scrollBottom());
  }

  Future sendPrompt(String question, int id)async{
    isLoading.value = true;
    try {
      var headersList = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('${GlobalService().baseUrl}/chat/ask');

      var body = {
        "question": question,
        "document_id": id
      };

      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        isLoading.value = false;
        var data = jsonDecode(resBody)["answer"];
        print("AI response: $data");

        const int chunkSize = 500;
        final List<String> chunks = [];
        for (int i = 0; i < data.length; i += chunkSize) {
          chunks.add(
            data.substring(i, i + chunkSize > data.length ? data.length : i + chunkSize),
          );
        }
        // ✅ Add each chunk as a separate message with a delay
        for (var chunk in chunks) {
          isLoading.value = true;
          await Future.delayed(Duration(seconds: 1), (){
            messagesSent.add(Message(text: chunk, sender: 'bot'));
          });
          isLoading.value = false;
          await Future.delayed(Duration(seconds: 1));
        }
      }
      else {
        print(res.reasonPhrase);
      }
    } catch (e) {

    }
  }

  Future getFileId(String path)async{

    try {
      var headersList = {
        'Content-Type': 'application/json'
      };
      var url = Uri.parse('${GlobalService().baseUrl}/documents?user_id=${currentUser.value.userId}');

      var req = http.MultipartRequest('POST', url);
      req.headers.addAll(headersList);

      req.files.add(await http.MultipartFile.fromPath('file', path));

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        isLoading.value = false;
        var data = jsonDecode(resBody);
        print(data);
        //await sendPrompt(msgController.text, 0);
      }
      else {
        print(res.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  void scrollBottom(){
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class Message {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});
}











