import 'dart:ffi';
import 'dart:ui';

class FileCardModel {
  String title;
  int? id;
  String? subtitle;
  String timeInfo;
  double? progress;
  String? level;
  String type;
  String createdAt;
  dynamic courseData;
  dynamic revisionData;
  dynamic quizzData;
  dynamic vocabulariesData;
  dynamic hasQuizz;

  FileCardModel({
    required this.title,
    this.subtitle,
    required this.timeInfo,
    this.progress,
    this.level,
    required this.type,
    this.courseData,
    this.revisionData,
    this.quizzData,
    this.vocabulariesData,
    this.id,
    required this.createdAt,
    this.hasQuizz
  });


}
