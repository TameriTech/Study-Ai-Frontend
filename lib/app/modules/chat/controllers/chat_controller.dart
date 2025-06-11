
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:get/get.dart';
import 'package:studyai/app/models/historic_model.dart';

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/files_repository.dart';
import '../../../repositories/quizz_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/auth_service.dart';
import 'package:latlong2/latlong.dart';

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

  var messagesSent = [];

  ChatController() {

  }

  @override
  void onInit() async {
    super.onInit();
  }


}












