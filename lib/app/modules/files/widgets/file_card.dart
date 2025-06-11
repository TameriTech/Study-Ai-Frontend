import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FileCard extends StatelessWidget {
  final int? id;
  final String title;
  final String? subtitle;
  final String? level;
  final Color color;
  final double? progress;
  final String timeInfo;
  final String type;
  final String createdAt;


  const FileCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.level,
    required this.color,
    this.progress,
    required this.timeInfo,
    required this.type,
    this.id,
    required this.createdAt
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth * 0.035; // Dynamically scales with screen width

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: TextStyle(
              fontSize: baseFontSize + 2,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.fade,
            softWrap: true,
          ),
          const SizedBox(height: 4),

          /// Subtitle
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: baseFontSize,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.fade,
              softWrap: true,
            ),

          /// Level
          if (level != null)
            Text(
              level!,
              style: TextStyle(
                fontSize: baseFontSize,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.fade,
              softWrap: true,
            ),

          const Spacer(),

          /// Bottom row (time + progress/icon)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  timeInfo,
                  style: TextStyle(
                    fontSize: baseFontSize - 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              /// Progress OR Revision Icon
              if (progress != null)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Text(
                    "${(progress! * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                )
              else if (type.toLowerCase() == 'revision')
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xffFDDF83),
                  child: Image.asset(
                    'assets/images/file_text.png',
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}


